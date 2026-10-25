# ADR-006 - Pumpjack multiblock/runtime integration

Status: ACCEPTED for G4B2C / alpha.6
Date: 2026-09-11

## Decision
The 1.7.10 Pumpjack is a real IE multiblock adapter using the frozen 1.21.1 3x4x6 template and the target IE 0.7.9 material registry.

Canonical positions:
- master / Well connection: `(1,0,0)`;
- trigger: `(1,1,4)`;
- energy input: `(2,1,5)`, UP face;
- redstone input: `(0,1,5)`;
- west/east formed fluid ports: `(0,0,2)` / `(2,0,2)`;
- external output neighbors: local x `-1` / `3`.

Formation is transactional: all 32 blocks are validated and snapshotted before mutation. Original TileEntity NBT is captured so surviving components can be restored exactly on disassembly.
## Runtime ownership
Only the canonical master ticks machine logic and owns the 16,000 RF CoFH `EnergyStorage`. Formed parts resolve the master through the IE 0.7.9 `offset` contract.

The Pumpjack calls the already-audited G4B1 transaction kernel. Any result carrying `hasUncertainMutation()` quarantines the machine rather than retrying blindly.

## Hot-path rule
The first implementation resolved every Well tap through `ReservoirResolver.resolveOrCreate()` every tick. This was REJECTED during B2C review because resolver discovery executes the bounded reservoir component scanner.

The accepted design caches `ReservoirRecordPumpjackTap` objects on the master. `TileEntityWell` exposes a transient `topologyRevision`; the cache is rebuilt only when the Well instance or revision changes. The revision is not persisted: a restart naturally rebuilds the cache once.

Dedicated runtime evidence requires two consecutive valid ticks to move 30 mB total while `tapCacheBuildCount` remains exactly 1.
## Lifecycle / unload decision
Forge 1.7.10 chunk unload calls `TileEntity.onChunkUnload()` and removes the TileEntity from ticking; it does not call `invalidate()` for normal unload. `invalidate()` remains tied to actual TileEntity replacement/removal or refresh after block/meta change, so formed-part invalidation is a valid disassembly trigger.

Breaking one formed part restores the other 31 original components and leaves the broken position absent. Original TileEntity NBT is reapplied to restored components. Formation rollback similarly restores every committed snapshot in reverse order.

## Rendering boundary
B2C intentionally renders the formed machine as the internal placeholder block. Premium geometry, dynamic armature, full-machine bounds and Angelica validation remain exclusively G4B3.