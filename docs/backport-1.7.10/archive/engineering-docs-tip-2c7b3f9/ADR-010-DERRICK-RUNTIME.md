# ADR-010 - Derrick runtime and operational interface

Status: ACCEPTED for alpha.10 foundation/runtime/container/render subgates; premium completion remains pending
Date: 2026-09-12

## Source and target

Modern behavior comes from the frozen Immersive Petroleum 1.21.1 source e6cb01df32d4adfd096d49c02bb91e60fef56a15. The 59-part 5x8x5 structure comes from derrick.nbt SHA-256 0732e434cbee57714eb7e8c85df3740d14ac0ab394e4db90fa7fc9341514c961. Execution uses Forge 1614, Java 8 bytecode and the exact IE 0.7.9 Forbidden dependency.

The default well has a central tap and 384 drilling units. One IE fluid pipe item provides six units. A drilling tick uses 512 RF; a committed physical step uses 125 mB concrete and a virtual step uses 125 mB water. Pressure output follows the modern spilling policy when the receiving port does not accept all fluid. Redstone pauses drilling; it does not remove pressure from a completed well.

## Lifecycle and safety

The canonical master owns energy, pipe inventory and drilling buffer. Well owns persisted topology/progress. Members carry formation identity and original block-entity NBT. Only loaded parts may be accessed; the machine never requests a chunk ticket. Original block entities are restored on disassembly. Formation snapshots are rolled back only before neighbor callbacks publish the result. After publication, callbacks may already have performed visible actions; a blind rollback could duplicate their drops.

IE fluid pipes with a `scaffoldCovering` are rejected before formation. IE's block-removal callback drops that cover even during a flags-2 replacement; retaining it in an original-state snapshot would duplicate the item when the pipe was restored. Derrick, Pumpjack and Distillation Tower therefore apply the covering restriction during matching/capture and again immediately before replacement. The covering must be removed first. Original colour and side configuration on uncovered pipes remain supported. Runtime reproductions for rejection with unchanged original state and no extra drops have been added and are in validation.

Malformed/future machine state stops operation and preserves its raw NBT. A non-placeable recovery record preserves quarantined payloads when a structure is dismantled; it is diagnostic data and has no automatic resource restoration API. Canceled item publication must not clear the source inventory. Uncertain external publication must not be retried as if no side effect occurred.

External fluid input resolves the Well before admission. A Well lookup exception is contained at that pre-commit boundary: quarantine and zero accepted fluid. A Well already marked invalid rejects input. Tank mutation and subsequent synchronization remain outside this catch, since reporting zero after a possible committed mutation could invite duplicate retries by the caller. The newly added corrupt-Well input reproduction is in runtime validation.

Core schema v1 is embedded in a runtime schema v1 envelope with energy, pipe item and timer. Unlike the transient modern timer, this backport persists the drilling timer so repeated reloads cannot accelerate drilling or reduce its energy cost. This is a deliberate lifecycle improvement, not literal persistence parity.

Forge 1.7.10 has no generator sea-level API equivalent to modern World.getSeaLevel. The default Overworld threshold is explicitly 63. Custom generator sea levels are not certified by this decision. Drilling refuses unknown block entities rather than destroying their inventories through breakBlock callbacks.

## UI, rendering and configuration

The initial container exposes pipe insertion, tank/energy/depth and machine status using vanilla inventory transactions and bounded container properties. The server validates the live machine and player distance/world. No custom client-to-server grid packet is introduced in this checkpoint. Directional grid editing remains an explicit follow-up, requiring container ownership and payload bounds.

The original renderer builds its steel frame, braces, service deck, ladder and carriage geometry once. It performs no per-frame geometry allocation; the carriage transform follows active drilling state. Master-only dispatch and conservative whole-machine bounds are mandatory. This renderer is a foundation, not final texture/material or shaderpack certification.

The accepted shaders-off client probe checks 21 off-screen renderer calls in a real Angelica/OpenGL context. The world screenshot is a separate client-world TileEntity installed for normal TESR dispatch. The GUI screenshot uses synthetic layout values, not a synchronized operating server machine. Those checks approve renderer foundation/layout only; they do not establish measured performance, active shaderpack compatibility or remote multiplayer behavior.

Operational configuration can pause Pumpjack, Distillation and Derrick work without unregistering IDs or deleting saved data. Renderer/cache/shader settings are not changed by these switches.

## Acceptance requirements

- Full build/check with malformed NBT regression tests.
- Dedicated formation/restart/break/reform and all eight facing/mirror combinations.
- Real physical+virtual drilling with exact pipe, fluid and energy accounting.
- Real pressure output and source debit; malformed endpoint stops future extraction.
- Completed Well reused by Pumpjack (pressure is accelerated by fixture setup; natural depletion duration is not claimed).
- Canceled inventory drop retains state; raw quarantine survives saving and disassembly.
- Covered-pipe formation is rejected without extra drops in Derrick, Pumpjack and Distillation Tower.
- Corrupt/missing Well lookup during external fluid input rejects before resource admission.
- Angelica real-context render probe and saved screenshot inspection.

The concrete foundation campaign `20260912T163950Z-8db643178bf74a82a0d59dbb6640a3d5` passed normal and collision registrations: both recognize all 59 template entries, while `ownDefault` is respectively true and false. The clean build passed with 245 tests and zero main/test Checkstyle errors. The final Derrick campaign `20260912T164847Z-02674858209c41b2aafbb3b4506bd125` passed the covered-pipe and invalid-Well reproductions plus all four lifecycle/orientation boots. Independent Pumpjack and Distillation four-boot campaigns also passed the covered-pipe repair and normal formation/persistence paths. See G6-EVIDENCE for precise identities and fixture limits.

Record actual results and remaining limits in G6-EVIDENCE.md; this ADR alone does not approve a release. Modern grid editing, final art/sound, natural pressure-release duration, concrete survival acquisition and remote multiplayer remain separate work.
