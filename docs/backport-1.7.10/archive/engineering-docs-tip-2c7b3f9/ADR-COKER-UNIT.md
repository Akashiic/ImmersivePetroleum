# ADR — Coker Unit, two batch chambers

Status: implementation complete, integration build and runtime/visual gates pending.
Date: 2026-09-12

## Source identities

Semantics come from frozen Immersive Petroleum 1.21.1 commit `e6cb01df32d4adfd096d49c02bb91e60fef56a15`, particularly `common/blocks/multiblocks/logic/coker/CokingChamber.java`, `CokerUnitLogic.java`, `CokerUnitMultiblock.java`, `common/gui/CokerUnitContainer.java`, `api/crafting/CokerUnitRecipe.java`, datagen `IPRecipes.cokerRecipes` and `FluidHelper.copyFluid`.

The source `cokerunit.nbt` SHA-256 is `2804ac412f5a5bc1987b8ea5a6bf4a868823b0dd45acbfa36e33ff1401e16aa5`. The reproducible generator refuses a changed hash, dimensions, materials, slab orientations, counts or previously absent block-entity payloads. It maps all 612 occupied positions of the 9×23×5 template. The master is `(4,0,2)`, a fluid pipe; the trigger is `(4,1,4)`, concrete. All eight horizontal/mirror transforms are supported.

Target API verification uses `build/rfg/recompiled_minecraft-1.7.10.jar` and the actual IE 0.7.9 deobfuscated dependency. IE storage and storage slab steel metadata is 7, concrete 4, concrete tile 5, treated wood 0; the bottom IE storage slab additionally requires `TileEntityIESlab.slabType == 0`. Grating uses the project's existing steel-grating compatibility block at top metadata 8. Covered IE pipes are rejected before mutation because IE's break callback would drop the cover. Color/side configuration of uncovered pipes and the original slab NBT are preserved verbatim.

## Process semantics

| Property | Frozen value |
| --- | --- |
| Shared energy | 24,000 RF |
| Water input / residue output buffers | 16,000 mB each |
| Chamber A / B capacity | 64 recipe units, 8,000 mB each |
| Default unit | 2 bitumen → 2 petcoke + 27 mB sulfurized diesel; washes with 125 mB water |
| Recipe declaration | 30 ticks / 15,360 RF |
| Actual chamber processing | `time × ingredient count` = 60 ticks at 512 RF/t, 30,720 RF per unit |
| Residue transfer | Up to 25 mB per chamber per tick, with buffer backpressure |
| Flooding | 125 mB every 2 ticks, then transitions on the following two-tick check |
| Discharge | One two-item unit every 5 ticks; washing fluid voided at 25 mB/t |
| External fluid offer | Up to 250 mB/t, subject to receiver simulation/acceptance |

The exact five phases are **STANDBY → PROCESSING → DRAIN_RESIDUE → FLOODING → DUMPING**. There is no phase called COOLING in the frozen source. Admission prefers chamber A, then B, and consumes at most one two-item unit per tick. Buffer water must already contain at least 125 mB to admit input, but is consumed during flooding. Raw and processed units share each chamber's 64-unit budget. A blocked chamber retains its recipe, inventory, progress and fluids.

Redstone disables feeding/chamber advancement; container processing and fluid export continue, matching `CokerUnitLogic`. Disabling the machine in config pauses the runtime while retaining registered blocks and saves. Particle/gate state is synchronized independently from container values. The five GUI slots retain the modern item input, filled water container, empty return, empty residue container and filled return roles. Vanilla containers and `IFluidContainerItem` use private copies for planning; return-slot compatibility and capacity are checked before committing the owned inventory/buffer state.

The modern exporter simulates a plain fluid stack and applies its pressure marker only to an accepted execute stack above IE's unpressurized threshold. This is preserved. Consequently a plain IE 0.7.9 pipe can accept 50 mB from the 250 mB offer; the campaign measures that actual pipe/barrel transfer. The adapter resolves the effective Forge global fluid by bare name, respecting the project's fluid-collision policy.

## Authority, persistence and transactions

Only the canonical master owns process state. Port tiles validate orientation and ownership before delegation. Runtime mutations happen on the server tick; there are no custom Coker packets, executors or chunk tickets. The five-slot vanilla container additionally verifies its original player and interaction distance/world. Inventory and RF/fluid operations are blocked during outgoing callbacks, quarantine and teardown. Simulated drains/fills do not mutate state.

`CokerState` contains two independent chambers, bounded primitive buffers and explicit outgoing reservations. The item unit or fluid amount is reserved before invoking an external receiver. A confirmed rejection restores the reservation; a partial accepted fluid result refunds only the confirmed remainder. A thrown callback or impossible amount seals the machine and keeps the unresolved reservation in NBT. It cannot silently resume or retry after restart. The runtime guards reentry while publication is in progress.

Save schema 1 strictly validates tag types, bounds, recipe identity, phase/material invariants, inventory slot uniqueness, item NBT and idempotency flags. Unknown/malformed machine envelopes, missing original pipe/slab data, or process payloads on dummy tiles remain opaque and are written back without interpretation. The frozen upstream loader looks up a recipe but fails to assign the holder; the backport explicitly restores recipe identity, so work resumes after restart. It also persists flooding timers that upstream did not always mark dirty. These are documented reliability corrections, not new recipes or changed rates.

Formation captures every original block/meta/TileEntity NBT before changing the world and rechecks the captured tile NBT immediately before replacing that part. Rollback attempts every changed cell independently. Normal teardown publishes inventory stacks and raw/processed chamber items with confirmed delivery before producing a forensic capsule of remaining fluids, energy and uncertain operations. Cancelled item/capsule publication prevents player removal; repeated teardown does not reissue a confirmed capsule. Publishing a capsule seals the source. The capsule is a data record, with no automatic resource rehydration API. Already-paid processing energy is not converted back to items or fuel. With `doTileDrops=false`, teardown of a machine holding resources is rejected rather than silently discarding its recorded state.

World/receiver callbacks are not database transactions. Another mod can remove a TileEntity, mutate the world and throw after an external effect. The reservation/quarantine policy prevents blind retries and retains available forensic evidence; it does not claim atomic recovery from arbitrary third-party corruption or a process crash between independent Minecraft save files.

## Original presentation and bounded work

The original TESR is a procedural twin-drum structure with steel gantry, service decks, ladder, ports and independent discharge gates. Static quads are generated once; a frame renders one static mesh plus two translated gates. It uses runtime IE atlas sprites and copies no upstream textures/models. Ten smoke particles per dumping chamber per tick preserve the frozen emission count. The GUI is an original drawn panel with separate raw/processed/fluid meters and stage/tooltips for both chambers.

Structure integrity currently checks all 612 occupied entries with constant-time index lookup per active master tick. This is bounded and avoids the previous quadratic entry lookup pattern, but no measured CPU/FPS gain is claimed. The renderer/client layout still need a real client gate, including Angelica and visual inspection; headless tests cannot certify appearance.

## Verification

JUnit covers exact energy/time, admission across both chambers, all five phase rates, water/residue backpressure, pause/no-energy preservation, NBT roundtrip after every tick, cancelled and thrown item publication, reentry, malformed state rejection, all eight structure transforms and opaque TileEntity state preservation.

`tools/run-coker-campaign.ps1` uses four boots in a fresh UUID world. It retains logs/worlds, serializes campaigns through the shared mutex, runs hidden child processes with a bounded timeout, and restores exact config bytes/environment values. Its required markers exercise:

1. Covered-pipe rejection without extra drops, all 612 formed parts, GUI admission/shift transfer, 256 bitumen admitted into two full 64-unit chambers and saved mid-processing.
2. Restart and completion to 256 petcoke, 16,000 mB consumed water and 3,456 mB residue, including an actual cancelled petcoke spawn/reentry attempt and a real 50 mB IE pipe/barrel transfer.
3. Another restart, cancellation of a seven-item inventory drop, confirmed retry, original pipe NBT restoration, one recovery capsule and clean reformation.
4. Eight orientation/mirror formations and restorations, future-schema opaque roundtrip, cancelled capsule through a dummy part and idempotent publication.

The opt-in client property `immersivepetroleum.cokerRendererProbe=smoke` creates a fresh UUID world and screenshots, renders 16 orientation/state combinations, checks GL error/cull restoration, and captures the five-slot GUI. Run it after integrating the hooks listed in `COKER-INTEGRATION-LOCALE.txt`. Passing results must be recorded after execution; implementation and parser checks alone are not a runtime PASS.
# Callback and lifecycle acceptance gates

Container transformations accept exactly one result item for one consumed input. Fluid identities and quantities are copied before later callbacks. Stack-limit queries receive detached copies, whose equality is checked after the callback; all five live inventory references and NBT values, the fluid budgets, configuration, and the master's world identity are revalidated before committing. A callback that mutates an input reference retained by another mod quarantines the machine without committing tank changes or publishing the transformed item. Runtime ports reject disabled, invalid, replaced, and detached tiles. Detached client renderer snapshots retain access only to presentation phase values.

The opt-in four-boot campaign requires `COKER_CONTAINER_CALLBACK_PASS` for inflated drain/fill results, a mutating item-stack-limit callback, retained inventory reference mutation, and ordinary fill/drain controls. `COKER_LIFECYCLE_ADMISSION_PASS` covers disabled admission and obsolete or invalid tile references. These are executable gates, not a claim that the campaign has already passed.
