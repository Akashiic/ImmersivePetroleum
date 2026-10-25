# G4B1 Evidence - Pumpjack transaction kernel

Decision: **PASS** for `0.1.0-alpha.4`
Date: 2026-09-10

## Exact semantic sources
Frozen TwistedGate Immersive Petroleum 1.21.1:
- `common/blocks/multiblocks/logic/PumpjackLogic.java`;
- `common/cfg/IPServerConfig.java`;
- `common/util/FluidHelper.java`.

Bridge/regression source:
- TwistedGate 1.12.2 `TileEntityPumpjack.java`.

Target runtime source:
- Forbidden IE 1.7.10 `TileEntityMultiblockPart`;
- bundled CoFH `EnergyStorage`;
- Forge 1.7.10 `IFluidHandler` and `FluidRegistry`.

## Approved semantics
- 1024 Flux/t active cost;
- 15 mB/t per finite tapped reservoir;
- finite pressure blocks Pumpjack operation;
- multiple taps pay energy once per machine tick;
- finite EAST -> WEST remainder routing;
- infinite full-flow offer is independent per output port;
- up to 10 output attempts per infinite port;
- finite source reservation restores all definitely unaccepted fluid;
- no source restoration after uncertain source/output EXECUTE side effects;
- impossible source EXECUTE returns are never used as trusted rollback quantities;
- `Result.hasUncertainMutation()` exposes quarantine-worthy failures to G4B2;
- energy reservation restores exactly when no transfer/uncertain side effect occurred.

## Automated evidence
Complete JUnit suite after G4B1 hardening: **76 tests / 0 failures / 0 errors**.

Pumpjack-specific coverage includes:
- disabled/no source/no energy/pressurized/no fluid/output blocked states;
- normal finite split and two finite taps;
- output underfill rollback;
- output disappearing between preflight and execution;
- partial energy commit rollback and energy rollback failure;
- output simulation/execute protocol violations;
- exception after sink side effect;
- invalid pressure/fluid identities;
- infinite independent ports and iterative 2500 mB flow;
- 250,000 randomized finite conservation ticks.

`run-pumpjack-kernel-campaign.ps1` starts a real Forge 1614 dedicated server and requires the explicit Pumpjack PASS marker, clean FML state and zero process exit code.

Dedicated runtime probe uses real:
`ReservoirRecord -> ReservoirRecordPumpjackTap -> PumpjackTransactionEngine -> CoFHEnergyAccount / ForgeFluidOutputPort -> EnergyStorage / IFluidHandler`.

Accepted probe cases:
- finite 15 mB: EAST 7 + WEST 8, source -15, energy -1024;
- underfill: simulated 15, executed 4, source restores 11;
- output vanishes after preflight: source and energy both restored exactly;
- pressure: no output/source/energy mutation;
- infinite 2500 mB: three execute calls, source does not deplete.

Accepted marker:
`PUMPJACK_KERNEL_PROBE_PASS finite=15 underfill=4 energyRollback=restored pressure=blocked infinite=2500`

## Rejected designs
1. Directly reviving the 1.12.2 Pumpjack extraction loop was rejected because current 1.21.1 separates pressurized extraction into Derrick/Well infrastructure.
2. Charging energy permanently before a zero-side-effect failed output was rejected during pre-freeze audit; energy now rolls back exactly in that case.
3. Blindly restoring a reservation after an output EXECUTE exception was rejected because the sink may already have accepted fluid; uncertain quantities remain debited to prevent duplication.
4. Restoring a source-reported impossible EXECUTE amount was rejected because a lying source may not have debited that quantity; invalid/throwing source mutations are quarantined without untrusted restore.

G4B1 does **not** approve Well/WellPipe, TileEntity/multiblock formation, networking or rendering. Those begin at G4B2/G4B3.

## Final alpha.4 regression closure
- Pumpjack dedicated kernel campaign: PASS after source/output/energy uncertainty hardening.
- G4A fluid registry normal+collision campaign: PASS; fixture removed after adversarial run.
- G3B deterministic genesis campaign: PASS; anchor/capacity/shard hash unchanged.
- G3A five-boot persistence/corruption/recovery campaign: PASS; canonical valid/corrupt hashes unchanged.
- Final clean `check build --no-daemon`: PASS; 76 tests, 0 failures, 0 errors; Java class major 52; zero collision-fixture entries in candidate JAR.
- Accepted external evidence snapshot: `evidence/g4b1-pumpjack-final`.
