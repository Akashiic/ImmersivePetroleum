# ADR: Auto Lubricator, Oil Can and native lubrication adapters

Status: implementation frozen for integration and execution. No build, dedicated campaign, multiplayer or visual PASS is claimed by this document.

## Oracle and verified legacy interfaces

- Frozen IP 1.21.1 commit `e6cb01df32d4adfd096d49c02bb91e60fef56a15`: `AutoLubricatorTileEntity`, `AutoLubricatorBlock`, `OilCanItem`, `LubricantHandler`, `LubricatedHandler`, the three `common/lubehandlers` and generated `auto_lubricator.json` / `oil_can.json` recipes.
- Pinned IE `libs/ImmersiveEngineering-garden-cloche-test-2.jar`: direct `javap` inspection of `TileEntityCrusher`, `TileEntityExcavator`, `TileEntityBucketWheel`, their native formations, `ItemToolUpgrade`, `ChemthrowerHandler`, `IEContent` and `IEPotions`.
- Local inspection artifacts: `run/lube-crusher-formation.javap.txt`, `run/lube-excavator-formation.javap.txt`, `run/lube-crusher-runtime.javap.txt`, `run/lube-tool-upgrades.javap.txt`. These are development evidence, not distributable copied assets.

## Functional contract

The automatic oiler occupies two owned cells. The bottom owns 8,000 mB, a phase in `[0,3]`, orientation, recovery state and a random formation identity. Only the upper cell's UP/unsided fluid port is exposed. Both parts accept ordinary Forge fluid-container interaction. Fluid NBT is part of identity. Plant oil costs 12 mB and Petroleum lubricant costs 3 mB per four eligible active ticks.

Phase zero immediately reserves one payment and invokes one extra native machine tick. The other three eligible ticks advance phase without an extra invocation. Inactive machines and insufficient liquid do not advance the phase. Saving, breaking to an item and reinstalling preserve phase. This fixes the modern reader's missing restoration of its saved counter.

The registered modern machines are precisely Crusher, Excavator and Pumpjack. Crusher calls its own update, preserving native recipes, RF use, item output and mob-grinding behavior. Excavator invokes the bucket-wheel master's native update, preserving the source distinction between wheel acceleration and additional machine processing. Pumpjack calls its existing transaction adapter; it still requires its normal Well, energy and output conditions. Hydrotreater, Coker and Derrick receive no invented lubrication bonus.

The native IE 0.7.9 geometry differs from modern IE. Its Crusher master `pos=17` is on the floor. The adapted oiler occupies that floor, two blocks in front of the master, facing inward. Excavator master `pos=4` and wheel master `pos=24` are resolved from the pinned bytecode; its body advances opposite its stored facing. The oiler is beside body depth four, on the lower layer, respecting the native mirror. Pumpjack uses canonical IP position `(3,0,4)` through the existing backport transform. A placement outline and direction arrow expose these positions to players.

Master and wheel resolution use `blockExists` before tile lookup and never create chunk tickets. The native IE update retains the same internal neighbor access as its ordinary tick; this implementation does not claim to change IE's own loading behavior or introduce a new distance/chunk cap.

The Oil Can stores 8,000 mB and supports Forge `IFluidContainerItem` automation. As in modern `FluidHandlerItemStack`, it can carry registered fluids; only registered lubricants activate machine/golem effects. A manual machine application costs 100 automatic payments: 300 mB lubricant or 1,200 mB plant oil. Ordinary use refreshes a shorter application to 600 and refuses an equal or longer one. The source's post-decrement endpoint, 600 through 0, is intentionally preserved, including its final phase-zero tick. Applications pause in unloaded chunks and persist per dimension. A UUID in Forge tile data prevents a replacement machine at the same position from inheriting the previous machine's application.

The Oil Can grants iron golems speed II and strength II for 1,200 ticks. Two explicitly approved source repairs apply: health increases by two with the game's maximum clamp, and a non-player/null attack context pays normally instead of dereferencing a null player. The source's `max(health+2,maxHealth)` would refill ordinary damaged golems completely.

The chemthrower uses the pinned native effect API. Plant oil lubricates; lubricant combines lubrication with native IE `slippery` for 60 ticks, amplifier 1. This avoids the modern registrations overwriting `LubricantEffect` with a potion-only effect. Mechanical potion bonuses are restricted to iron golems with a valid lubricant, correcting the source's AND/OR guard and avoiding division by zero. Native chemthrower consumption determines additive machine/golem duration, capped at the source's 1,200 ticks. Higher-amplifier existing potions are preserved.

Both recipes use ore dictionary materials: three glass, two treated wood and one native fluid pipe for the automatic oiler; two iron plates, red dye and a bucket for the Oil Can. Registries and saved state remain available when `enableAutoLubricator` or `enableOilCan` pauses functionality.

## Publication, lifecycle and persistence review

All item-container callbacks on the automatic oiler run under the master latch, beginning before `getFluid`, simulation or callbacks on a copied item. Commit revalidates the entire owned pair, clicked part, held item identity and full held NBT. It requires the exact admitted volume. Callback replacement of the hand is retained, with no tank debit or overwritten replacement.

The Oil Can guards the original `ItemStack` before calling an external fluid handler. A push debits liquid and writes a pending reservation before publication; only a bounded confirmed rejection is restored. A pull reserves capacity and writes its expected fluid before execution. Malformed acknowledgements or exceptions retain the pending/raw state and quarantine the can. A callback cannot fill/drain the reserved can through its API. The same held object is updated after an external callback; inventory slots are never replaced after that callback. Unknown/malformed fluid tags are rejected rather than coerced to empty tags.

Pair placement commits the player's item before neighbor publication. Rollback is limited to the newly created tile identities before publication. No published callback is undone by recreating consumed material.

A player break publishes exactly one packed block. An explicit canceled spawn leaves both cells and their fluid intact; an uncertain publication freezes the persisted authority and is not retried. Arbitrary external block removal cannot be vetoed by Forge `breakBlock`: its packed state is instead transferred to per-world escrow before the pair is removed. Explicit cancellation remains retryable; a throwing spawn remains quarantined. Additions during publication are staged to avoid reentrant iterator modification. `doTileDrops=false` and creative harvesting retain ordinary deliberate no-drop behavior.

Malformed/future tank state is preserved as opaque NBT. Corrupt upper-state data is retained in the packed recovery data and quarantines the master; it is not silently discarded. Publication uncertainty is an outer persisted flag, separate from a future raw state schema. A future world application schema remains opaque; independently identified recovery records allow new external-break escrow without overwriting that raw schema. These are normal save/reload guarantees, not a claim of atomic host-power-loss recovery across Minecraft's separate chunk and saved-data files.

## Presentation and networking

Models are original Java geometry: wood pedestal, brass reservoir cage, visible liquid column and scale, top input collar, directional nozzle, and machine-specific pipe runs. The Oil Can has its own original three-dimensional red container, handle, spout and fill gauge. No upstream geometry or texture is copied. Static faces and normals are compiled once; filled liquid/gauge meshes use transforms instead of rebuilding geometry each frame. Amber drops use the native particle atlas with original color and dynamics. Manual use maps the modern bucket-empty sound to the available 1.7 liquid sound; the source automatic oiler has no independent motor loop.

Timed client animation uses a separate read-only S2C channel. Its 20-byte payload contains dimension, position and remaining ticks. Invalid length/coordinates/duration are rejected. Netty receives into a concurrent queue; all tile access and animation execute on the client tick. The server periodically refreshes nearby clients and sends removal on expiry/quarantine. Clients cannot use this message to spend RF, transfer liquid, change inventories or invoke server ticks. Real multiplayer transport/authority and shader-on visuals remain execution gates.

## Required integration hooks

- Pre-init: `PetroleumLubricationContent.register()`.
- Init after IE/Petroleum fluids: `PetroleumLubricationContent.registerEvents()` (recipes, lubricant registry, chemthrower, world tick, S2C channel).
- Client init: `LubricationClient.register()` (TESR, item models, ghost, client animation and opt-in renderer probe).
- Dedicated server-start probe hook: `LubricationProbe.runIfRequested(server)`.
- Config: `enableAutoLubricator`, `enableOilCan`.
- Registry names: `auto_lubricator`, `oil_can`, `immersivepetroleum:auto_lubricator`.
- Translation keys: `tile.immersivepetroleum.autoLubricator.name`, `.desc`; `item.immersivepetroleum.oilCan.name`, `.desc`; `immersivepetroleum.lubrication.quarantined`.

## Validation supplied, not yet executed

Ten JUnit tests cover phase/rate, pause, refresh/payment bounds, tagged-fluid persistence, opaque future data and strict Netty decoding. `tools/run-lubrication-campaign.ps1` supplies four dedicated boots in a unique scratch world. Assertions cover real native Crusher formation, eight orientations/mirrors, measured native 8 versus 10 processing ticks and matching RF expenditure, both lubricant prices, top-only ports, held-item replacement, reentrant item and external tank callbacks, uncertain can transfer persistence, golem behavior, combined chemthrower effects, physical packed drops after restart, cancellation, external escrow, and future/upper raw preservation.

The wheel case uses an explicitly identified fixture of the real native Excavator and BucketWheel tile classes; it proves invocation/rotation, not construction of the complete IE Excavator. End-to-end Pumpjack production with an oiler still needs to be added to the established Well/Pumpjack campaign. The Oil Can's native upgrade interaction is covered through its normal container/tool APIs, not a newly fabricated drill upgrade.

`tools/run-lubrication-client-probe.ps1` requires 15 offscreen draws across four orientations and empty/half/full levels plus Oil Can meshes, checks GL culling state, and produces a separate screenshot of three client-world reservoirs and the held can. `run/screenshots/lubrication-renderer-probe.png` must be inspected after execution. These are distinct evidence: offscreen GL calls do not establish visual framing, pipe placement or multiplayer behavior.

PowerShell parsing succeeded for both new scripts during implementation. No Gradle task or runtime/client campaign was executed by the implementation agent. Full compilation, actual JUnit results, runtime markers, screenshot review, authentic multiplayer, shader-on compatibility and comparable gameplay performance measurements remain pending until the root's coordinated runs.

## Explicit remaining IE upgrade gap

Modern `toolupgrade_drill_lube.json` requires four iron plates, a fluid pipe and 1,000 mB lubricant. Modern IE `ToolUpgrade.DRILL_LUBE` applies `UpgradeEffect.OILED`. Pinned IE 0.7.9 has only `drillWaterproof`, `drillSpeed`, `drillDamage` and `drillCapacity`; `drillWaterproof` applies a different `waterproof` flag. No equivalent OILED upgrade exists in the inspected JAR. Producing the waterproof meta from the modern recipe would misrepresent the feature. A proper legacy wear adapter and a container-preserving recipe are a separate remaining compatibility task.
