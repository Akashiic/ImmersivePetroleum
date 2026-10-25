# Oil Tank: modern storage on Forge 1.7.10

Status: development-lab qualified on 2026-09-14. Source check, four-boot dedicated-server campaign and Angelica client smoke passed on the same digest. This is not Crucible/pack/multiplayer/release approval.

The oracle is frozen Immersive Petroleum 1.21.1 commit `e6cb01df32d4adfd096d49c02bb91e60fef56a15`, specifically `OilTankLogic.java`, `OilTankMultiblock.java` and `oiltank.nbt`. The generated 5×4×6 template has 84 parts: 62 iron sheetmetal, 18 steel fences, two steel scaffold blocks and two top slabs. Its NBT SHA-256 is `efd4193321b7ce43f7f3259a4a7b7a70891d49fd19e43bad41eb6f2f51c2b548`.

## Behavior

- One non-gaseous fluid, including its NBT identity, with capacity 1,024,000 mB. Public snapshots and container operations copy mutable fluid tags.
- Six directional ports at the frozen coordinates. Top is input; bottom is output; A/D default input and B/C default output. A–D toggle with the IE hammer. The frozen manual says the bottom also accepts input, but `registerCapabilities` binds the bottom to its output-only handler; the implementation follows the executable oracle.
- Opposite configurations on A/C or B/D permit equalization with an adjacent Oil Tank. A transfer moves half the difference, rounded down and capped at 10,000 mB per invocation. Both neighboring masters may tick during one world tick, matching the upstream method's scheduling. This is independent of redstone.
- Automatic output requires redstone by default and offers at most 432 mB per output port per tick. When equalization moved fluid, only the bottom outputs during that master's tick. Sided external draining remains independent of the automatic-output redstone gate.
- Shift+hammer at either redstone point inverts control. This adapts the modern screwdriver interaction to the pinned legacy IE tool set.
- Comparators use the actual three-layer `LayeredComparatorOutput` formula and a whole-tank output. The modern manual's quarter-height example does not describe the implementation's three layers. The two labeled redstone cells expose whole-tank fill for usable legacy UX; other material layers expose layer fill.
- Registered fixed containers and `IFluidContainerItem` are supported on every part. Variable containers mutate an item copy, validate the resulting volume, reserve inventory space and publish the held inventory only after committing fluid. Full inventory and excessive distance reject the operation. The concrete bucket doubles as a 1,000 mB water carrier and retains partial contents.

## Safety and lifecycle

Formation snapshots all 84 positions, revalidates each before replacement and rolls back attempted writes, including mutate-then-throw callbacks. Publication is an external-effects boundary: no rollback after neighbor notifications. Only loaded chunks may be inspected by production code. None of the required original materials owns a tile; an unexpected tile/inventory is rejected intact before formation.

Only the canonical, validated master owns fluid. Equalization is an internal transfer with no external callback. External output simulates, reserves and debits before execution, and restores only a rejected amount acknowledged by a valid result. An exception or impossible acknowledgement leaves the potentially delivered amount reserved and quarantined. Reentrant filling, draining, output and player breaking are refused during dispatch. A reservation survives restart and is never automatically retried.

Typed, versioned persistence rejects malformed volumes, port masks, flags, identities and reservations. Unknown or gaseous registered fluids fail closed on load. An invalid complete envelope is preserved verbatim under `invalidEnvelope`; a non-operational recovery capsule carries it on teardown. Capsules are diagnostic records and cannot mint fluid or automatically recreate inventory. Canceling capsule publication cancels player breaking while the structure is intact. An uncertain spawn is not retried automatically.

Disassembly restores only owned parts, preserves ownership until each successful restoration and continues other restores if one callback throws. Failed restoration data is retained in a capsule. Explicit disassembly is idempotent. Healthy liquid contents are discarded when the tank itself is dismantled, as with the upstream multiblock; the normal campaign drains them through the real bottom port before dismantling. Cross-chunk externally forced deletion remains limited by the Forge lifecycle: it can remove a cell despite a failed preflight, but the loaded master is quarantined and production never forces the missing chunk to load.

## Original presentation and evidence gates

The TESR builds a riveted cylindrical vessel, reinforcement bands, service deck, handrails, ladder, six colored collars and a fill gauge from code. It uses sprites already present in the pinned IE atlas; no upstream OBJ/PNG is copied. The modern standard scaffold slab uses the existing legacy steel-slab compatibility block. The renderer only runs for the master and restores culling and matrix state. Final visual review, active shader packs and measured client/server performance are not yet approved.

`OilTankStateTest` covers volume identity and bounds, tags, default ports/redstone, many equalization distributions, comparators, partial external acknowledgements, reentrancy, thrown/invalid acknowledgements, reservation restart and corrupt saves. `OilTankStructureTest` independently pins the template digest/counts and all eight orientation transforms.

`tools/run-oiltank-multiblock-campaign.ps1` runs write, restart/break, restart/reform and orientation boots in a fresh UUID world, retaining logs and a region hash. Runtime gates cover incomplete and foreign-inventory rejection, 84-part ownership, real adjacent-tank equalization, a real IE barrel output, fixed/variable buckets, saved totals/configuration, teardown/reform, canceled recovery publication, exact raw-NBT capsules, uncertain-output restart and eight orientations/six port faces.

`tools/run-oiltank-client-probe.ps1` drives `OilTankRendererProbe`. Its 21 validation calls draw off-screen; the screenshot is a separate TileEntity installed in the client world and rendered by the normal TESR path. This proves only the stated GL smoke and visible fixture when actually run and inspected. It does not prove multiplayer authority, survival progression, final assets, FPS or an active shader pack.

Shared integration hooks: `PetroleumConfig.enableOilTank`, internal `PetroleumBlocks.OIL_TANK_MULTIBLOCK`, tile ID `immersivepetroleum:oil_tank`, `MultiblockOilTank.INSTANCE`, `PetroleumItems.OIL_TANK_RECOVERY`/`oil_tank_recovery`, server probe and client TESR/probe registration. Player text keys are `chat.immersivepetroleum.oilTank.configured`, `chat.immersivepetroleum.oilTank.contents`, `tile.immersivepetroleum.oilTankMultiblock.name`, `item.immersivepetroleum.oilTankRecovery.name` and `.desc`.
