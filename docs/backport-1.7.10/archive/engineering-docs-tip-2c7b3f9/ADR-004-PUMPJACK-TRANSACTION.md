# ADR-004 - Pumpjack transaction semantics

Status: ACCEPTED for G4B1 / alpha.4
Date: 2026-09-10

## Decision
The 1.7.10 Pumpjack follows the frozen 1.21.1 extraction semantics rather than resurrecting the 1.12.2 loop unchanged.

Selected modern defaults:
- energy cost: 1024 Flux per active tick;
- finite extraction speed: 15 mB per tapped reservoir per tick;
- any pressurized finite tapped reservoir blocks the Pumpjack;
- the Derrick owns the pressurized extraction phase;
- finite output is offered EAST then WEST using the remainder;
- an infinite reservoir offers its full configured flow independently to each output port;
- infinite output retries a port up to 10 times, matching the current IE-pipe workaround.

## Transaction boundary
G4B1 is deliberately independent of TileEntity, multiblock and renderer code. The kernel consumes four abstractions only: energy account, ordered source taps, east output and west output.

For finite reservoirs, extraction is a reversible reservation:
1. simulate source and output capacity;
2. reserve energy;
3. reserve up to the finite extraction limit from the reservoir;
4. execute EAST then WEST output;
5. restore every reserved mB that was definitely not accepted.

If a source or output EXECUTE path throws or returns an impossible value after it may have produced a side effect, that mutation becomes uncertain. An impossible source return is never used as a trusted restore quantity, and an uncertain output offer is never restored. This intentionally prefers bounded loss over duplication.

Energy is also reversible because it is machine-owned CoFH `EnergyStorage`. When no fluid moved and no source/output mutation is uncertain, the reserved energy is restored exactly. If any fluid moved or an EXECUTE mutation is uncertain, the energy cost remains consumed. `Result.hasUncertainMutation()` exposes this condition so the future TileEntity can quarantine rather than blindly retry.

## Why this differs slightly from upstream implementation
Current upstream performs simulate -> execute -> reservoir debit. Under normal single-threaded handlers this is valid. The 1.7.10 backport uses reservations because third-party `IFluidHandler` implementations may re-enter or change behavior between calls. The externally visible successful-path semantics remain the same while failure paths are fail-closed.

## Runtime adapters
- `ReservoirRecordPumpjackTap`: persisted reservoir state -> source tap;
- `CoFHEnergyAccount`: exact reversible adapter over target IE's CoFH EnergyStorage;
- `ForgeFluidOutputPort`: canonical modern fluid id -> effective Forge global default -> IFluidHandler fill.
