# ADR: gasoline bottle and Molotov on Forge 1.7.10

Status: qualified in the recorded Forge/Java 8 laboratory for source, two dedicated-server boots and the Angelica client. See `MOLOTOV-QUALIFICATION-2026-09-14.md`. Crucible/Java 21, authenticated multiplayer, pack/world copy, shaders, audio listening and final artwork remain separate gates; no independent external approval is claimed.

## Evidence and scope

Frozen IP 1.21.1 commit `e6cb01df32d4adfd096d49c02bb91e60fef56a15`:

- `common/items/GasolineBottleItem.java`: 250 mB, stack 16, unsided recipient, glass returned when emptied outside creative mode.
- `common/items/MolotovItem.java`: twenty use ticks, flint-and-steel ignition, one lit bottle, creative fuse exemption, throw velocity 0.75 / inaccuracy 1, bottle return at expiry.
- `common/entity/MolotovItemEntity.java`: flame particle; terminal block/entity impact; any fluid at the impact origin extinguishes; six-neighbour air flood with squared radius 9; damage is a separate 6.5-wide AABB centred at integer block coordinates, 1 HP from the player owner.
- Generated recipes `bottling/gasoline_bottle.json`, `molotov_wool.json`, `molotov_fabric.json`: glass + 250 mB gasoline; vertically adjacent wool/hemp fabric above the filled bottle.

Legacy APIs were checked against `build/rfg/minecraft-src/java`: `EntityPlayer`, `ItemStack`, `EntityThrowable`, `BlockFire`, `BlockPortal.Size`, `World`, `ForgeHooks.onPlaceItemIntoWorld`, `ForgeEventFactory`, `BlockSnapshot`, `SlotCrafting`, `EntityJoinWorldEvent`. IE 0.7.9 `BottlingMachineRecipe` signatures were checked with `javap` against the pinned IE jar. No upstream texture, model or sound files were copied.

## Content and integration

`PetroleumMolotovContent.register()` runs in preInit and registers `gasoline_bottle`, `molotov`, `molotov_lit`, and entity `Molotov` with mod entity ID 62. `registerRecipesAndEvents()` runs in init after fluids/IE; it registers the native bottling recipe, `FluidContainerRegistry` 250 mB gasoline to one glass bottle, both shaped recipes and the dimension journal tick listener. The gasoline bottle deliberately has no global `Item.containerItem`: crafting a Molotov consumes the glass as part of the weapon and cannot produce an extra empty bottle.

`MolotovClient.register()` registers one original renderer for the projectile and the three items. `MolotovProbe.runIfRequested(server)` is the dedicated server hook. Kill switches are `PetroleumConfig.enableMolotov` and `enableGasolineBottle`; registry identities remain stable and disabling Molotov pauses its fuse/projectile operation. Already owed journal returns remain deliverable.

The fluid registry entry allows other adapters, including the Motorboat's standard container path, to recognise the filled bottle. This does not by itself prove a Motorboat gameplay interaction; that remains part of its own campaign.

## Ignition, inventory and lifetime

There is no offhand in 1.7.10. The first flint-and-steel in hotbar index order 0–8 is selected at charge start. The same held stack, held slot, world, lighter stack and lighter slot must survive twenty distinct server player ticks. A replaced lighter, released charge, changed held stack or missing room for the remaining unlit bottles aborts without consuming either input.

On success, exactly one unlit bottle becomes one lit bottle in the selected slot. The remaining unlit stack is moved/merged into a compatible inventory slot; it is never discarded by vanilla's returned-stack assignment. `attemptDamageItem(1)` is applied to a copy of the native lighter, preserving Unbreaking semantics, before the complete inventory plan is committed. Creative ignition consumes one unlit bottle as in the frozen source, but does not damage the lighter.

The fuse stores a typed versioned **remaining inventory tick count**, initially 300, directly in the item NBT. It does not use world time; crossing dimensions or clock corrections cannot renew it. It advances only in a player's main inventory, matching the source's player-only inventory tick. Chest, ground and disconnected-player time are paused. At zero the exact slot becomes one vanilla glass bottle. Creative mode freezes the remaining fuse. Missing state on a newly created lit registry item initialises a fresh fuse; present malformed/future state is preserved and cannot launch or automatically expire.

Two source defects are explicitly corrected to the requested behaviour: the modern integer-seconds test `duration > 15` actually permits sixteen seconds; this port expires at 300 ticks. The modern throw check on item damage also prevents throwing during the first second; this port allows throwing immediately after the twenty-tick ignition. No claim of byte-for-byte bug compatibility is made.

## Publication and recovery

`MolotovTransactions` guards an entire player interaction before foreign fluid or entity callbacks. Gasoline transfer requires exact 250 mB simulation, an unchanged held snapshot and the same live loaded recipient. The bottle's fluid operation occurs outside `ForgeHooks.onPlaceItemIntoWorld`, whose block-placement wrapper rewinds stack size/NBT around snapshot events and is unsuitable for an already committed external fluid transfer.

Before an actual fluid fill or projectile spawn, a UUID reservation containing the original one-item NBT, owner UUID, operation and origin slot is written to `MolotovWorldData`; survival inventory authority is removed before the callback. Exact acknowledgement completes the record. An explicit zero-fluid acknowledgement or unmodified rejected spawn changes it into an owed return. The return first uses inventory space and preserves a held replacement performed by another mod; with a full inventory it attempts a normal `EntityItem` publication. Explicitly canceled item drops are retried later. Loaded dimensions are searched for the owner if a callback moved that player; no dimension or terrain is loaded for delivery.

A callback exception, out-of-contract partial fluid acknowledgement, or rejected entity already added/killed by a callback retains an **uncertain** record and is never automatically repeated or refunded. The record stores the original item and acknowledgement/reason as recovery evidence; it is not a claim that the entire original item is safe to reissue. In particular, a partial fill's observed amount must be accounted for during manual recovery. Malformed/future journal records remain raw and are not executed. There is no automatic admin recovery command in this family.

These guarantees cover synchronous callbacks and ordinary NBT save/reload. Minecraft's separate player, entity, chunk and WorldSavedData files are not a distributed transaction. Abrupt process termination between their independent disk writes has not been proven atomic and is not represented as exactly-once crash durability.

## Flight, impact and protection

The projectile uses native `EntityThrowable` physics with velocity 0.75 and inaccuracy 1. UUID ownership is persisted independently of legacy player names. An offline/absent owner cannot create new fire or player damage after reload. Native mob owners are allowed only while `mobGriefing` is true; they use the named mod fake player `[IP-Molotov]` for placement protection. Player-owned use remains available when `mobGriefing` is false.

Before native movement or fluid ray tracing, every crossed chunk and the collision footprint is checked using loaded-chunk queries. At an unloaded boundary the projectile pauses with velocity intact. Fluids intersected along flight extinguish the projectile; flowing fluid at the current position also extinguishes it. A terminal impact is marked consumed before callbacks, and repeated/reentrant impacts cannot repeat fire or damage. One native flame particle per client tick and native glass/fizz/bow/liquid sounds provide feedback; legacy sounds approximate modern bottle sound events that do not exist in 1.7.10.

The fire flood itself visits at most the 123 integer points within squared radius 9, through connected air, with the source's special treatment of the initial point. Unloaded cells are impermeable. Subsequent spread is ordinary vanilla fire governed by native gamerules; the radius is the ignition footprint, not a permanent bound on later fire spread.

Native `BlockFire.onBlockAdded` attempts portal formation before a normal placement event. Its scanner and frame checks can read 22 cells horizontally. The adapter checks this loaded window, captures the native fire/portal mutations as one Forge snapshot scope, checks `canMineBlock`/`canPlayerEdit` on every affected position, and publishes `PlaceEvent` or `MultiPlaceEvent`. A world-level latch rejects reentry during capture, protection events, rollback and notifications. If the loaded window is unavailable, that initial flame is refused without forcing chunks.

Cancellation restores only identifiable native AIR/FIRE/PORTAL changes that still match the post-capture block/metadata and have no tile entity. A third party's replacement remains intact. The earliest original snapshot for each coordinate is restored once. Unexpected third-party changes are not assumed reversible. After neighbour notification begins, there is no blind rollback of published effects.

The legacy `BlockSnapshot.restore` helper is deliberately avoided: its source checks metadata using `x & 15` / `z & 15` as world coordinates and ignores `setBlock` failure. This adapter restores using absolute coordinates and verifies the resulting block/metadata. It never restores inventories or tile NBT from fire snapshots.

Player-attributed 1 HP damage uses native `attackEntityFrom` and therefore exposes `LivingAttackEvent`/ordinary damage protections. Placement protection and damage protection are distinct native events; canceling a placement event alone does not automatically veto area damage.

## Prepared verification

Thirteen JUnit tests cover exact fuse timing, creative pause, save/reload, corrupt/future schemas, opaque journal records, the complete radius-three integer sphere, wall occlusion, unloaded boundaries, origin handling and ownership/gamerule policy.

`tools/run-molotov-campaign.ps1` uses two isolated dedicated-server boots with a fresh UUID world and retained evidence:

1. `write`: native crafting/SlotCrafting remainders, IE bottling/Forge fluid registration, real `EntityPlayer.onUpdate` ignition, stacked remainder, changed lighter, full inventory, reentrant canceled launch with held replacement, a throwing spawn listener, direct/reentrant fluid recipient, callback exception after accepting fluid, item fuse expiry, a real chest checkpoint and one real spawned projectile.
2. `verify-reload`: unchanged paused chest fuse, two unchanged uncertain journal entries, projectile UUID ownership from entity NBT, exactly one terminal damage event, radius, water, both mobGriefing cases, canceled fire/damage, a native obsidian portal's MultiPlace cancellation with a third-party diamond replacement, and an unloaded flight boundary.

The fixture's player subclasses native `EntityPlayer` and has no authenticated multiplayer connection. The adversarial fluid handler deliberately implements the foreign callback protocol in a temporary TE and is removed before saving. These are explicit fixture boundaries, not a claim of full multiplayer integration or every external tank implementation.

`tools/run-molotov-client-probe.ps1` requests twelve offscreen item render calls (three items × four render contexts), checks GL state restoration, then captures a separate three-bottle client-world fixture and held lit item. Successful GL calls will only approve the renderer foundation with the actual tested client stack. Final artwork, shader-on behaviour, authenticated multiplayer, audio listening validation and measured tick/network/FPS impact require separate evidence.

At source handoff, the two PowerShell files parse successfully. Gradle, server boots and client were intentionally not executed by this subtask; the project lead controls the shared runtime mutex and approval gates.
