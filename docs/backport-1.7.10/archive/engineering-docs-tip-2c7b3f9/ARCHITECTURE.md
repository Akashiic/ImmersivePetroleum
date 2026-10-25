# Immersive Petroleum 1.7.10 — Architecture

## Architectural stance
The project is a separate `ImmersivePetroleum` addon compiled against the current Forbidden Series Immersive Engineering artifact. Modern source defines intended behavior; 1.12.2 is the migration bridge; Forge 1.7.10 APIs define the actual implementation.

```text
Modern 1.21.1 semantics + assets reference
             |
       1.12.2 bridge
             |
      Portability Facades
             |
+------------+-------------+
| Reservoir  | Multiblock  |
| Fluids     | Energy      |
| Recipes    | Rendering   |
+------------+-------------+
             |
 Forbidden IE 1.7.10 + Forge 1614
```

## Module boundaries
1. `api.reservoir` — immutable type definitions and deterministic reservoir domain model.
2. `common.reservoir` — generation, lookup, extraction transactions and cache lifecycle.
3. `common.storage` — versioned WorldSavedData/region persistence; no renderer dependencies.
4. `common.multiblock` — formation/orientation/master-part lifecycle adapters over IE 1.7.10.
5. `common.processing` — Pumpjack, Derrick, Distillation Tower, Coker and machine transactions.
6. `common.fluid` — crude oil/lubricant and registry adapters.
7. `common.compat` — optional integrations, isolated from core classloading.
8. `client.render` — static mesh + dynamic armature pipeline.
9. `client.gui` — GUI only; server remains authoritative.
## Reservoir design
The modern polygon/pressure concept is retained, but implementation is redesigned for 1.7.10 safety:
- deterministic seed = world seed + dimension + stable algorithm version;
- server-authoritative generation only;
- iterative flood-fill/outline extraction, not recursive traversal;
- explicit maximum scan area and corruption guards;
- spatial lookup by fixed-size region key;
- cache is disposable; persisted data is authoritative;
- NBT schema starts versioned at v1 with migration hooks;
- all capacity/amount arithmetic uses `long` internally;
- extraction exposes SIMULATE then EXECUTE semantics internally even though Forge 1.7.10 has no modern `FluidAction` enum;
- no chunk force-load solely to answer reservoir queries.

## Multiblock architecture
Petroleum multiblocks use IE 1.7.10 formation semantics rather than importing modern IE block-entity machinery. A Petroleum base part mirrors the proven `formed/pos/offset/mirrored/master()` lifecycle while keeping Petroleum state in its own classes.

Formation is transactional:
1. validate every required block without mutation;
2. resolve orientation/mirroring;
3. allocate master state;
4. convert members;
5. if any conversion fails, roll back changed members;
6. mark/sync only after commit.

Breaking any member resolves the master exactly once, invalidates the structure, restores constituent blocks where applicable, and prevents duplicate machine drops.
## Rendering architecture
Pumpjack establishes the rendering contract because its animation lineage is directly comparable between 1.12.2 and 1.21.1.

```text
Static body -> baked/cached geometry -> ordinary multiblock/static render path
Dynamic armature -> hierarchical parts -> TESR -> interpolation from server state
```

The dynamic hierarchy keeps explicit pivots for crank, counterweights, walking beam, connectors and polished rod. Animation is derived from one phase parameter and linked kinematics, not independent cosmetic oscillators.

Rules:
- no GL state leakage: every matrix/blend/cull/light mutation is balanced;
- renderer reads synchronized state but never owns machine logic;
- bounding box covers the complete visible machine;
- distance culling/LOD is configurable and evidence-driven;
- geometry allocations are forbidden from steady-state per-frame paths;
- Angelica ON is a primary target; Angelica OFF remains a regression path where practical;
- GTNHLib may accelerate/model-cache the premium path, but gameplay core must not depend on client rendering APIs;
- Hodgepodge is compatibility foundation, not a rendering API;
- UniMixins is reserved for proven API gaps and requires a separate approval record.

## Failure containment
Every machine family and every optional integration has a config kill-switch. No subsystem can require deleting world data to disable it. Unknown NBT versions fail closed with diagnostics rather than silently rewriting data.
