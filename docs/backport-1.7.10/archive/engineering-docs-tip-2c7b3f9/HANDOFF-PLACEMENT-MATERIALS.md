# Handoff: native placement transaction and remaining paraffin materials

Root update after freeze: the complete source check passed (401 tests, 64 suites, zero failures/errors/skips; zero Checkstyle findings), including compilation of this helper and these probes. See `HANDOFF-VALIDATION.md`. The native placement runtime scenarios below have still not been executed.

Status at source freeze on 2026-09-12: the placement correction and diagnostic cases below are written. **This subagent did not run Gradle, a dedicated-server campaign, or a client campaign after these edits. No new placement PASS is claimed.** Root must compile and rerun the affected families. The former runtime approvals are reopened for this placement path. Candles, ersatz leather, and the chemistry adaptations below were researched only; no material implementation was started.

## P1 reproduction and native Forge evidence

The real entry point is `net.minecraftforge.common.ForgeHooks.onPlaceItemIntoWorld`, in `build/rfg/minecraft-src/java/net/minecraftforge/common/ForgeHooks.java`, lines 491-582 in the currently generated source. It enables capture, calls `Item.onItemUse`, saves the returned item state, restores the pre-use stack size/NBT, and only then posts PlaceEvent/MultiPlaceEvent. On cancellation it restores captured blocks and keeps the pre-use stack. It clears the shared snapshot list before/after this dispatch.

Previously Auto Lubricator removed the current held slot inside `placePair`, before that outer cancelable event. Gas Generator and Flarestack returned through vanilla ItemBlock placement but notified arbitrary observers before the outer event and before item consumption. A observer could harvest a packed machine; a subsequent cancel then restored the original held machine. Merely testing `placePair` or `placeBlockAt` directly did not exercise this Forge wrapper.

Also, this pinned Forge17 `BlockSnapshot.restore` checks metadata at `(x & 15, y, z & 15)` and does not reliably validate the absolute replacement. Its generic rollback is inappropriate for these owned tiles. This source-level finding was previously reported to root for Projector and Molotov.

## Written production changes

- `common/placement/OwnedItemPlacement.java`: shared owned native placement transaction. Rejects a pre-populated external snapshot list, an existing restoring scope, or reentry by world/player. Captures only its own one/two cells, detaches its own snapshots, posts the normal Forge PlaceEvent/MultiPlaceEvent inside `onItemUse`, and leaves the outer ForgeHooks list empty so it cannot post a second event or rewind owned blocks after publication. Protection sees the original held stack. Rechecks loaded original cells, permissions, held reference plus deep stack snapshot, exact block/meta/tile ownership, and full pending tile NBT around the event. Only then decrements the original stack reference; does not clear/overwrite the player's held slot. Publishes updates after this commit frontier. Cancel first marks created owners non-publishing, then restores only cells still owned by exact block/meta/tile identity, with absolute coordinates; third-party replacements remain. Rollback failure is surfaced, with aborted owners frozen rather than resource-active.
- `common/items/ItemBlockAutoLubricator.java`: pair builder, pending lower/upper TEs, packed restore, guarded commit/abort. `onItemUse` is the survival route.
- `common/gasgenerator/ItemBlockGasGenerator.java` and `common/flarestack/ItemBlockFlarestack.java`: now implement their own `onItemUse` using the helper. Their direct `placeBlockAt` compatibility API retains caller-owned item consumption; it must not be used as evidence for the survival transaction.
- `common/tile/TileEntityAutoLubricator.java`: pending placement prevents ticks, fluid/container access, player break and external-break escrow. Commit enables the owner; abort disables publication. Optional persisted `placementPending` fails closed if a callback saves an undecided placement; old saves without the field remain compatible.
- `common/gasgenerator/TileEntityGasGenerator.java`: pending placement participates in `isBusy`, blocks work, fluid/energy extraction, packing, break and cable attachment; persisted pending flag.
- `common/flarestack/TileEntityFlarestack.java`: keeps its placing latch until native approval and item commit; persisted pending flag. `common/flarestack/BlockFlarestack.java` does not apply the upper pilot collision hazard while placement is pending.

No shared registry/config/proxy changes are required. Existing recipes, IDs, TEs and renderer bindings remain the hooks. Persistence of an undecided placement is intentionally inert; this is not a distributed hard-crash transaction across region and player saves, and no automatic recovery of such an interrupted snapshot is claimed.

## Written diagnostics and pending execution

`common/placement/OwnedPlacementProbe.java` is called from the **write** stage of LubricationProbe, GasGeneratorProbe and FlarestackProbe, using a real packed fluid-bearing machine from that family's fixture. All three original placement helpers now enter real `ForgeHooks.onPlaceItemIntoWorld`, then emulate the caller's cleanup of a returned zero-sized held reference.

The new shared fixture is at `120064,220,120064`, in explicitly loaded bounded chunks. It first asserts its air/support region, preserves the probe player's position and held stack, and checks an existing nonempty outer capture is not stolen by direct item use. Six cases then cover:

1. Native cancellation: original stack reference and full NBT retained; all owned cells restored; no EntityItem or Auto Lubricator escrow.
2. Native cancellation with callbacks attempting player break, fluid extraction from both cells, machine update and another real ForgeHooks placement: no resources/publication or nested placement.
3. Native cancellation after replacing the held slot with a distinct diamond stack: preserves that replacement and does not overwrite it with the old item.
4. Protection callback replacing the base with a diamond block: operation rejects while preserving the third-party block and restoring only other owned cells.
5. Accepted placement with full packed NBT comparison, then ordinary break: exactly one matching packed EntityItem and no remaining machine cells.
6. Accepted placement whose `IWorldAccess.markBlockForUpdate` observer breaks it during publication: observer must see one native event and an already-consumed stack; outer ForgeHooks must not refund it; exactly one matching packed EntityItem.

Marker only after all cases pass: `OWNED_ITEM_PLACEMENT_PASS item=... cases=6 nativeForgeHooks=true packed=true`. Listeners are public static classes for Forge17's generated event invoker and unregister in finally. This marker **has not been observed yet**. Neither the source edit nor hypothetical simulation is a passing test.

Next validation: root's full compile/check, then rerun `tools/run-lubrication-campaign.ps1`, `tools/run-gas-generator-campaign.ps1` (verify actual driver spelling in tools), and `tools/run-flarestack-campaign.ps1`. Require the new marker for every family and the existing restart/break/reform gates. Root separately found a native Crusher fixture collision in LubricationProbe at its earlier Y=80 area and is correcting that harness; these placement edits preserve the root-owned Crusher code. Live multiplayer protection plugins, client visuals and hard-crash ordering remain separate gates.

## Paused paraffin materials: verified oracle and proposed continuation

Frozen IP upstream: `../../upstream/ImmersivePetroleum-1.21.1`, commit `e6cb01df32d4adfd096d49c02bb91e60fef56a15` (verify repository identity again before release).

- Modern generated `candle.json`: string above paraffin wax yields one vanilla candle. Minecraft 1.7.10 has no vanilla candle. Parent approved an original, uncolored IP candle only: one to four in a block, light 3 per candle, ignite/extinguish, support and correct drops. Do not expand vanilla cake integration, waterlogging or sixteen dye variants to claim the IP recipe. Those modern vanilla integrations must be documented as adaptations outside this family.
- Complete modern CandleBlock and AbstractCandleBlock were read from the existing decompiled 1.21.1 source archive `C:/Users/User/.gradle/caches/neoformruntime/intermediate_results/decompile_fc3fbf9f843fb09f456ed86f0fad2c1d13616362_output.jar`. Modern placement checks center support below; removing support later does not automatically remove the candle. Counts 1-4 and light 3 each; empty hand extinguishes a lit candle; flint/steel and fire charge ignite; no fuel depletion. Proposed legacy representation: count bits plus lit bit in block metadata, no ticking TE, original code-native cuboids/wicks and vanilla flame/smoke/sound references. Use the corrected native placement transaction for placement/stacking where applicable, not raw ItemBlock callbacks. Confirm API/protection semantics for metadata stacking and ignition independently.
- Official cross-check: https://www.minecraft.net/ja-jp/article/taking-inventory--candle and https://www.minecraft.net/da-dk/article/caves---cliffs--part-i-out-today-java . These support count/light/ignite/extinguish and retention after support removal. They do not establish Forge17 implementation behavior.
- `ersatz_leather.json`: eight hemp fabric around one paraffin wax yields eight IE ersatz leather. Pinned IE17 has no ersatz leather item. Its `IEContent.itemMaterial` is ItemIEBase: meta4 is fabric; other existing metas must not be aliased to a new leather. Add an original IP ersatz_leather item and register vanilla leather plus the proxy under `leather`. Forge17's vanilla recipes use hardcoded leather, so ore registration alone is insufficient evidence of usefulness.
- Demonstrable recipes to adapt explicitly through ore recipes: vanilla books, item frames and four leather armor patterns; native IE conveyor recipe output is eight `IEContent.blockMetalDevice` with `BlockMetalDevices.META_conveyorBelt` (meta11), pattern `LLL`/`IRI`, leather/iron ingot/redstone. This was verified from pinned IE bytecode. Prefer explicit audited recipes, not broad mutation of every external recipe. Test the actual crafting manager results with the proxy. Root already owns `PetroleumItems.PARAFFIN_WAX` and its ore registration; do not duplicate it.
- Suggested ownership/hooks: new `common/compat/materials` and `client/materials`, standalone aggregator registration/recipes/client render methods for root to integrate. **No such classes/assets were created.** Original code-native rendering avoids copying upstream assets.

## Chemistry proposal: do not silently claim omitted outputs

Modern `refinery/phenol.json` actually outputs **10 mB IE creosote**, from 5 benzol + 5 petroleum gas, with redstone catalyst and energy 240. The filename is not an output-fluid specification. Modern `refinery/acetaldehyde.json` outputs 15 mB IE acetaldehyde from 15 petroleum gas, with a constantan plate catalyst and energy 120.

Modern IE RefineryRecipe/RefineryLogic were read: catalysts are checked in the catalyst slot, but not consumed as recipe input. Pinned IE17 `DieselHandler.addRefineryRecipe(input0,input1,output)` has no catalyst slot or per-recipe energy parameter. Directly registering the phenol JSON as an ordinary native IE17 recipe would silently omit its catalyst requirement; do not present that as parity. Pinned IE17 also has no acetaldehyde or phenolic resin outputs/uses.

A bounded, useful continuation would require an explicitly documented catalyst-aware adapter/recipe representation and a real consumption/publication protocol. For acetaldehyde, adding only an unused fluid is insufficient: modern IE subsequently combines acetaldehyde12 + creosote8 into phenolic resin8 (energy240), and uses a resin bucket with eight sawdust for eight fiberboard. Decide the intended IP-versus-modern-IE compatibility scope with parent before building this chain. No code, recipe registration, or PASS exists for either chemistry adaptation.

## Molotov continuity boundary

The preceding Molotov/Gasoline Bottle family was source-frozen before this placement work; its implementation, probes and drivers are described in `docs/ADR-MOLOTOV.md`. Root owns its integrated build/runtime results. The independent agent read only MolotovFirePlacement and the native BlockSnapshot issue; that limited review **does not approve** item launch, external fill, publication escrow, or real portal behavior. Preserve this distinction in the transfer; do not promote written probes or a partial source audit to runtime evidence.
