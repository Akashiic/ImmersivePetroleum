# G4B2 Evidence - Well / WellPipe infrastructure

Decision: **PASS** for `0.1.0-alpha.5`
Date: 2026-09-11

## Exact semantic sources
Frozen TwistedGate Immersive Petroleum 1.21.1:
- `WellTileEntity.java`;
- `WellPipeTileEntity.java`;
- `WellBlock.java`;
- `WellPipeBlock.java`;
- `DerrickLogic.transferGridDataToWell`;
- `PipeConfig` and Derrick settings screen (69x69 grid).

Target runtime source:
- Forge 1.7.10 `GameRegistry`, `BlockContainer`, `TileEntity`, NBT classes;
- target world height 0..255.

## G4B2A - pure Well state
Approved behaviors:
- PIPE_WORTH=6, base target=384, self-destruct=6000;
- ordered duplicate taps retained;
- max 4,761 taps derived from the modern 69x69 grid;
- physical pipe Ys unique and bounded to 0..255;
- topology locked once drilling begins;
- versioned schema v1 with fail-closed validation;
- future/corrupt TileEntity Well state is quarantined and preserved raw on save.

## G4B2B - Forge world infrastructure
Registry policy:
- `immersivepetroleum:well` and `immersivepetroleum:well_pipe` registered as blocks with `ItemBlock=null`;
- TileEntity ids: `immersivepetroleum:well` and `immersivepetroleum:well_pipe`;
- no inventory item or loot for either hidden infrastructure block;
- Well is unbreakable; WellPipe hardness/resistance mirror current-generation intent;
- broken pipe uses metadata bit 0 and is five times easier for a player to break.

Dedicated campaign: `tools/run-well-infrastructure-campaign.ps1`.
Three independent JVM boots are mandatory:
1. `write`: verify block registries/no items, place Well + 3 pipes, persist topology/progress;
2. `verify`: reload exact topology, break middle intact pipe, require length rollback 3->2 and disconnected upper segment;
3. `verify-mutated`: reload mutation, then self-destruct; require bedrock restoration and remaining pipes marked broken.

Accepted marker:
`WELL_INFRASTRUCTURE_CAMPAIGN_PASS`

Accepted runtime execution region SHA-256 (evidence only, not a deterministic invariant):
`39df90652c34800895eaf7c4d2e38ad65cd9111361fd8462c97c1a885525158a`

Anvil region hashes are not promoted to semantic invariants because chunk timestamps/metadata may vary between otherwise equivalent runs. The gate is decided by explicit probe markers and state assertions.

## Rejected evidence / repairs
The first G4B2A test campaign was rejected: `addPhysicalPipeY()` had not actually received its intended 0..255 guard because an earlier text-replacement script reported success without matching the method body. The adversarial test `physicalPipeYsAreUniqueAndBoundedTo1710Height` failed, exposing the false-positive patch.

Repair: exact source assertions were used to patch both physical-Y bounds and the tapped-column limit. The full suite then passed.

The first TileEntity NBT unit run was also rejected as runtime evidence: pure JUnit had not executed FML lifecycle registration, so vanilla `TileEntity.writeToNBT()` correctly reported the Well class as unmapped. The test fixture now registers an isolated TileEntity mapping in `@BeforeClass`; production mapping remains exclusively `GameRegistry.registerTileEntity` during preInit.

## Release boundary
This gate does not claim a playable Pumpjack. G4B2C still requires real Pumpjack TileEntity/multiblock formation, break rollback, energy/fluid ports, redstone/active sync, and restart/chunk invariants. G4B3 remains the premium client renderer/Angelica gate.

## Final alpha.5 regression closure
- complete clean JUnit suite: **100 tests / 0 failures / 0 errors**;
- Well state dedicated probe: PASS (ordered duplicate taps, NBT round-trip, malformed schema rejection);
- Well infrastructure 3-JVM campaign: PASS (write -> restart/mutate -> restart/self-destruct);
- Pumpjack kernel regression: PASS;
- fluid registry normal + foreign-default collision regression: PASS, temporary fixture removed;
- deterministic reservoir genesis regression: PASS with canonical anchor/capacity/shard identity unchanged;
- five-boot reservoir persistence/corruption/recovery regression: PASS with canonical valid/corrupt hashes unchanged;
- final pre-tag `clean check build --no-daemon`: PASS; Java class major 52; zero collision-fixture entries; Well core risk scan clean.
