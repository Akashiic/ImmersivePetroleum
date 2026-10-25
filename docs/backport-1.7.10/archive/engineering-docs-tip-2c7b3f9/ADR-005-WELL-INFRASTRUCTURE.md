# ADR-005 - Well / WellPipe infrastructure

Status: QUALIFIED IN LAB on 2026-09-14; release/Crucible/pack acceptance remains pending.
Date: 2026-09-11

## Decision
The 1.7.10 extraction stack preserves the modern separation between Well state and Pumpjack/Derrick machine state.

The Well owns drilling topology/progress. WellPipe blocks are lightweight vertical connectors and do not duplicate Well state.

Frozen modern semantics:
- one IE pipe item contributes 6 virtual pipe units;
- base virtual drilling length is 384 units;
- maximum Derrick grid is 69x69 (4,761 cells);
- tapped X/Z columns preserve order and intentional duplicates;
- physical pipe positions are unique Y coordinates;
- self-destruct timer is 6,000 ticks using upstream `timer-- <= 0` behavior;
- Well topology becomes immutable once drilling material/progress exists.

## 1.7.10 world representation
- registry `immersivepetroleum:well`: hidden, unbreakable, no ItemBlock, no drops;
- registry `immersivepetroleum:well_pipe`: hidden, no ItemBlock, no drops;
- WellPipe metadata bit 0 represents `broken`;
- physical Y range is explicitly 0..255 for the target 1.7.10 world height;
- Well/WellPipe currently use vanilla bedrock/stone fallback textures respectively; no upstream asset is redistributed.

## Persistence contract
`WellStateCodec` schema v1 fails closed on:
- unknown schema;
- more than 4,761 tapped columns;
- physical Y outside 0..255 or duplicate physical Y;
- invalid pipe buffer/progress;
- completion flag inconsistent with target depth;
- additional pipe count outside the modern 69x69 grid bound (0..4,761).

`TileEntityWell` quarantines invalid/future state. It preserves the raw `wellState` compound when re-saving rather than silently replacing data it cannot understand.

## Physical lifecycle
Breaking an intact WellPipe before the virtual phase removes that Y from the Well and rolls drilling length back by one. A missing vertical segment terminates connection lookup.

If an incomplete Well loses its controlling machine, self-destruct eventually:
1. marks its still-known physical pipes as broken;
2. restores the Well anchor to vanilla bedrock.

## Release boundary
G4B2A/B approve Well state, save format, hidden block registries, vertical connectivity and physical rollback/self-destruct. They do not approve Pumpjack multiblock formation, energy/output ports, redstone/network synchronization or client rendering. Those remain G4B2C/G4B3.
