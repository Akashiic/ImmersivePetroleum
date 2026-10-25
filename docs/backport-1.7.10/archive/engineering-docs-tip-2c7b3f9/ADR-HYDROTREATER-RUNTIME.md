# Hydrotreater on Forge 1.7.10

Status: development-lab qualified on 2026-09-14. Source check, four-boot dedicated-server campaign and Angelica client renderer/GUI passed on one final digest. This is not Crucible/pack/multiplayer/release approval.

The frozen 1.21.1 oracle is `HydroTreaterLogic`, `HydroTreaterProcess`, `HydroTreaterMultiblock`, the three generated default HPR recipes and `hydrotreater.nbt` at commit `e6cb01df32d4adfd096d49c02bb91e60fef56a15`. The generator emits the 3×3×4, 32-part template with SHA-256 `62995ce6b508faedb3de8bc304d750f537d13af83c980144e8c50b16ae8e13d5`. Legacy mappings are ten steel scaffolds, fifteen iron sheetmetal, two light engineering, four heavy engineering and one redstone engineering block.

## Process and ports

The master has three separate 12,000 mB tanks, 8,000 RF storage and one process. Input A is at `(1,0,3)` on the back face; input B is `(2,2,1)` on top; fluid output is `(0,1,2)` on top; energy input is `(2,2,3)` on top. The item output is `(0,0,2)` and points outward to the left of the frozen orientation. All four cardinal facings and both mirror states share the generated transform.

Primary/secondary input filtering follows the explicit recipe book. Tagged inputs carrying nonempty custom NBT are rejected rather than having their identity silently stripped by this name-based process kernel. Output pulls are restricted to the actual fluid output face. The automatic outlet tries at most 1,000 mB per tick. No production path forces chunks to load.

Redstone disables admission by default, while an already queued process may finish, matching the frozen processor ordering. Shift+hammer at the redstone part inverts control as a legacy replacement for the modern screwdriver. The configuration kill switch pauses processing and automatic transport and refuses input capabilities. A missing or quarantined loaded part prevents processing; an unavailable chunk pauses without loading it.

The defaults consume exactly the frozen recipe inputs and RF:

| Recipe | Inputs | Outputs | RF / ticks |
|---|---|---|---|
| Sulfur recovery | 1,000 sulfur diesel + 500 water | 1,000 diesel + 5 sulfur dust | 8,000 / 100 |
| Lubricant cracking | 2,000 lubricant + 500 water | 2,000 sulfur diesel + 2 paraffin wax | 256,000 / 400 |
| Naphtha cracking | 1,500 naphtha + 500 water | 2,000 petroleum gas | 192,000 / 300 |

The pinned IE 0.7.9 artifact has no native sulfur dust item. Runtime resolves an existing `dustSulfur` ore entry first and otherwise uses the registered Petroleum fallback. Recipe identity remains tied to the frozen source. Optional PneumaticCraft plastic integration is not part of these three defaults and is not declared implemented by this adapter.

## Conservation, persistence and teardown

`HydrotreaterState` performs processing without world callbacks. The runtime reserves and removes output before invoking an external fluid handler, inventory or entity-spawn callback. It restores only a known rejection accepted by the adapter's bounds and identity checks. Exceptions or invalid acknowledgements quarantine the machine and preserve the unresolved reservation. No unresolved reservation is automatically retried after restart. Reentrant public input, output and player-break calls are refused while a dispatch is active.

Item byproducts attempt the real adjacent `IInventory` via pinned IE insertion utilities. The confirmed remainder is spawned into the world as in the modern process; canceled spawns retain the pending item. Teardown must publish pending byproducts or cancel the player break. A partial external inventory mutation followed by an exception retains its entire unresolved reservation and stops the machine; blindly restoring it would duplicate the material already accepted externally.

Typed runtime NBT encloses the strict process state and separate fluid/item reservations. The complete rejected envelope is preserved verbatim under `invalidEnvelope`. Recovery capsules are diagnostic records, do not automatically restore resources, and are emitted only once after confirmed publication. Cancellation keeps formed parts intact for normal player breaking. Formation revalidates every original cell and rejects foreign tiles/inventories; teardown restores owned parts independently and retains failed restoration information. Fluids and stored RF are lost when a healthy multiblock is dismantled, consistent with the source's multiblock lifecycle.

The master marks data dirty immediately and coalesces description updates to ten ticks during steady operation, with immediate active-state transitions and quarantine notifications. The GUI receives live values separately through vanilla container properties. This is an analytical bound, not a measured performance claim.

## UI, rendering and evidence

GUI ID 1 uses a read-only menu with no machine inventory slots, as upstream. It shows three tanks, energy, progress and activity. Vanilla container synchronization splits wide counters and fluid IDs into 16-bit words. The menu validates owner, live master, same world and distance. No custom GUI mutation packet exists.

The original TESR constructs a horizontal pressure drum, reinforcement rings, heating cabinet, four service connections and active indicators from code using existing IE sprites. It contains no copied upstream model or texture. Only the master renders, with culling and matrix state restored. Its client smoke fixture covers off-screen orientation/activity calls and a separate world-inserted visible TileEntity plus GUI screenshot; these remain pending until run and inspected. Neither the screenshot fixture nor FakePlayer GUI probe proves an authenticated remote multiplayer session.

The four-boot dedicated runner is `tools/run-hydrotreater-multiblock-campaign.ps1`, property `immersivepetroleum.hydrotreaterMultiblockProbe`. It preserves a new UUID world and per-boot logs. Gates cover incomplete/foreign-inventory rejection, 32-part formation, mid-process restart, exact RF/fluids, a real IE barrel and chest, queued completion under redstone, teardown/reform, future-schema raw recovery, canceled capsule publication, a malicious fluid acknowledgement with persisted reservation, all eight orientations, and all three recipes.

The client runner is `tools/run-hydrotreater-client-probe.ps1`, property `immersivepetroleum.hydrotreaterRendererProbe=smoke`; required markers are renderer and GUI layout PASS. Shared hooks: internal block/TE `hydrotreater_multiblock`/`immersivepetroleum:hydrotreater`, `MultiblockHydrotreater.INSTANCE`, GUI 1, `enableHydrotreater`, recovery item, server probe and client renderer/probe registration. Final assets/audio, optional integrations, active shader packs, real multiplayer, copied production worlds and measured performance remain separate release gates.
