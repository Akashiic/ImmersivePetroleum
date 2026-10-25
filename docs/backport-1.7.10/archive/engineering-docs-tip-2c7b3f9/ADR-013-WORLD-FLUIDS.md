# Petroleum fluids in the 1.7.10 world

Status: integrated source; two-boot runtime campaign pending. This is not visual or modpack certification.

## Reference and contract

The oracle is the frozen upstream 1.21.1 checkout at `e6cb01df32d4adfd096d49c02bb91e60fef56a15`, particularly `common/IPContent.java`, `common/fluids/IPFluid.java`, `CrudeOilFluid.java`, `NapalmFluid.java` and the chemthrower registrations. The target implementation is the project's patched Forge source under `build/rfg/minecraft-src/java`, not a different MCP mapping.

All ten registry fluid names now have a Petroleum-owned world block and fixed 1000 mB bucket, with the modern `<fluid>_fluid_block` and `<fluid>_bucket` suffixes. These blocks bind the Petroleum candidate without replacing another mod's global default. Industrial stacks and containers use the current Forge default by fluid name. Buckets return a vanilla empty bucket; no furnace burn time is invented (the frozen bucket factory defaults to zero).

Forge `BlockFluidClassic` supplies downward flow and eight quanta without infinite source regeneration. Only a live source cell can be drained. Simulation preserves it, repeated drain returns nothing, failed removal returns no fluid, and chunk availability is checked before world access. Placement rejects solid blocks, tile entities and an existing full source. Flow also refuses tile-bearing blocks. The flow search and entity-current vector are deferred at unavailable chunk boundaries; this intentionally pauses local flow until terrain is available instead of loading terrain as a fluid side effect.

Vanilla empty-bucket interaction is extended through the Forge event at LOWEST priority and respects earlier cancellation/results. Denied Petroleum collection is cancelled to prevent vanilla `Material.water` fallback from producing a water bucket. The handler checks held identity, distance, edit authority, source identity and output space. Dispenser behavior wraps the previously active empty-bucket behavior and delegates every non-Petroleum target; all ten full buckets have placement behavior. A full dispenser with stacked empty buckets keeps the source until an output slot is free.

## Effects and explicit legacy adaptations

Contact effects use the installed IE potion IDs: crude oil 100 ticks/amplifier1; both diesels40/1; gasoline, naphtha and kerosene120/2; napalm140/2; lubricant slippery100/1. Benzol and petroleum gas have no contact potion in this oracle. Chemthrower effects and flammability follow their own modern registration list; the composed mechanical lubricant effect belongs to the lubrication integration.

The block uses legacy `Material.water`, as the older Petroleum fluid implementation did, and therefore retains the 1.7.10 water movement/extinguishing model. A per-entity, per-tick contact record applies additional crude/napalm drag once across overlapping cells. Weak entity keys and weak world references do not retain unloaded worlds. This is an explicit adaptation, not a claim of identical NeoForge movement. In particular the target `World.handleMaterialAcceleration` normalizes the accumulated current and hardcodes0.014; the modern motion scales0.007/0.0105 remain declared metadata and are not advertised as implemented current strength. No global World coremod is added solely to imitate that coefficient.

Source review also found an oracle wiring distinction: crude's source factory uses its custom20-tick/.4 slowdown class while the flowing factory is generic; napalm registers its custom block but uses the generic fluid factory, leaving `NapalmFluid`'s10-tick/.7 overrides unwired. The backport deliberately applies the named classes'20/.4 and10/.7 behavior coherently to their source and flowing cells. This is a documented correction/adaptation of declared intent, not a transcription of the frozen factory's observed runtime.

Napalm adjacent to vanilla fire turns into fire and schedules its adjacent napalm cells using the world's persisted native tick queue. Propagation is not recursive and does not use the modern global duplicate-prone list. Like the oracle's explicit conversion, ignition itself is not conditioned on `doFireTick`; subsequent vanilla fire behavior still follows that rule. Rendering currently references vanilla water atlas sprites with original per-fluid colors. Original final fluid art and visual equivalence remain separate open gates.

## Verification

`tools/run-world-fluid-campaign.ps1` owns a fresh world and two dedicated boots. `PetroleumWorldFluidProbe` checks all ten bucket/default identities, vanilla ray-traced collection, denied/full/distant/cancelled collection, placement over an inventory, dispenser placement/collection/full inventory, contact effects and overlap drag, downward flow, no source regeneration, unloaded-boundary behavior, a four-cell napalm ignition chain, then real persistence and exactly-once drain of ten saved sources.

The campaign requires explicit detail/PASS markers and hashes its saved region. A development source filter, when used, is recorded and cannot be represented as a full-source release gate. It does not establish FPS, shader compatibility, multiplayer protection-plugin behavior, or atomicity against arbitrary mods mutating the same world/inventory during a native callback.
