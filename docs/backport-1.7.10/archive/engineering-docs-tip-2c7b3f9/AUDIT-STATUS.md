# Audit Status - 2026-09-12

| Gate | Decision | Evidence / blocker |
|---|---|---|
| G0 Evidence freeze | PASS | 161/161 mod files hashed; 3 upstream revisions frozen; production untouched |
| G1 Skeleton build | PASS | clean build + check + reobf; Java class major 52 |
| G2 Dedicated server | PASS subgate | server reached `Done`, saved/unloaded cleanly |
| G2 Client | PASS subgate | alpha.7 scratch client reached integrated world; client/server modded connection established |
| G2 Real-world upgrade | BLOCKED | no copied production world has been subjected to this addon yet |
| G3A Reservoir domain / field / scanner | PASS | 250k Python + JUnit campaigns; 268,435,456-column footprint campaign; bounded canonical scanner |
| G3A Forge persistence | PASS | final 5-boot automated campaign: same-session reopen, restart, mutate, restart, corruption fail-closed, recovery |
| G3B Type registry / genesis | PASS | alpha.2 frozen at 598ee10; 45/45 tests plus genesis and G3A regression campaigns |
| G4A Fluid registry / binding | PASS | 10 modern fluids; normal + collision + idempotence dedicated campaign; no release fixture |
| G4B1 Pumpjack transaction kernel | PASS | 76 tests; 250k randomized conservation; dedicated Forge/CoFH runtime probe; clean energy rollback plus source/output uncertainty quarantine |
| G4B2A Well domain / persistence | PASS | schema-v1 fail-closed/quarantine state; modern 69x69 bounds; dedicated probe; 100-test clean suite |
| G4B2B Well/WellPipe infrastructure | PASS | hidden no-item blocks + TileEntities; 3-JVM world campaign; restart rollback/disconnect; bedrock self-destruct |
| G4B2C Pumpjack multiblock state | PASS | 106-test suite; 4-boot multiblock campaign; two-tick tap-cache proof; 8-orientation form/break matrix; restart/disassembly/reformation |
| G4B3A Pumpjack renderer foundation | PASS | 116-test clean suite; master-only TESR dispatch; real Angelica 2.2.8 client + 37-draw GL probe + screenshot evidence |
| G4B3B Final visual fidelity | PLANNED | production art/shaderpack certification remains outside alpha.7 |
| G5A Distillation transaction/foundation | PASS | 40 Distillation tests inside 156-test clean suite; 250k randomized recipe campaign; frozen 137-block NBT-derived template; dedicated foundation probe |
| G5B Distillation multiblock runtime | PASS | two consecutive isolated 4-boot campaigns; process/save, restart/break, restart/reform and 8-orientation matrix; fail-closed schema-v1 state |
| G5C1 Distillation renderer foundation | PASS | clean-room master-only TESR; Angelica 2.2.8 real-client 21-draw GL gate; cull restoration; deterministic in-world screenshot; dedicated-server isolation |
| G5C2 Distillation final UX/art | PLANNED | final original art/material polish, active shaderpack certification, GUI/NEI/CraftTweaker and measured LOD policy |
| G6A Derrick domain / binding | PASS subgate | 245 tests in 40 suites, zero failures/errors/skips; 85 Derrick tests; four pressure-adapter regressions cover zero pressure, zero field, infinite source and stopping threshold; [G6 evidence](G6-EVIDENCE.md) |
| G6B Derrick dedicated runtime | PASS subgate | final isolated campaign `20260912T164847Z-02674858209c41b2aafbb3b4506bd125`: four boots, 59-part form/restart/break/reform, eight orientations, 2 physical + 382 virtual steps, real pressure output/spill and same-Well Pumpjack handoff |
| G6C Derrick server container | PASS subgate | Forge FakePlayer + real Container: distance and GUI-ID admission, four-pipe shift-click conservation and invalid-item rejection; remote multiplayer remains unverified; layout is a separate G6E fixture |
| G6D Derrick tested failure / recovery paths | PASS subgate | canceled seven-pipe publication keeps inventory and 59 parts; canceled master capsule prevents dummy removal; schema-999 raw payload retained in one capsule; malformed pressure endpoint stops subsequent withdrawal; invalid Well rejects fluid before mutation |
| Alpha.10 covered-pipe regression | PASS subgate | Derrick/Pumpjack/Distillation reject IE scaffold coverings without NBT changes or extra drops; all three final four-boot lifecycle/orientation campaigns passed |
| G6E Derrick client renderer / layout foundation | PASS subgate | real Angelica client, shaderpacks off: 21 validated draws, GL culling restored; renderer and GUI PNGs inspected; complete structure in frame and legible layout; synthetic GUI values do not prove multiplayer synchronization |
| G6F Derrick premium completion | PLANNED | modern grid editor/edit protocol, final art/materials/sound, active shaderpack certification, measured performance and remote multiplayer remain pending |
| Runtime campaign isolation | PASS | all campaign scripts share `Global\ImmersivePetroleumRuntimeProbe`; concurrent launch is rejected before Gradle/Java child creation |
| Asset redistribution | BLOCKED | current distribution marked All Rights Reserved; no root repo license discovered |

## Rejected evidence
The first modpack hash snapshot omitted eight filenames containing `[` / `]` because PowerShell wildcard semantics were used. That run was rejected. The collector was corrected to `Get-FileHash -LiteralPath`; only the 161/161 snapshot is admissible.

The first corruption campaign was also rejected as a passing artifact: Forge 1.7.10 `MapStorage.loadData` instantiates `WorldSavedData` before GZIP decode. On decompression failure it can return an empty object shell instead of null. Our first store therefore misclassified the corrupt shard as `FOUND` and the probe failed later with `record missing`.

The first Derrick campaign `20260912T161158Z-376ba5a0751145b3bde9b865d0a76e2e` was rejected after pressure dispatch failed with `source_protocol_error` in `verify-break`. Its canonical fluid ID was not yet converted to the Forge registry name. The corrected adapter resolves `ReservoirFluidBinding`; the replacement four-boot campaign above passed. Review separately found and repaired extraction continuing through the 15 mB minimum-flow floor at zero pressure. Four direct adapter tests confirm the corrected threshold behavior. The diagnostic pipe-output expectation was also corrected to account for IE's observed 50 mB/call bound and explicit spilling. Details and exact logs are recorded in [G6 evidence](G6-EVIDENCE.md).

## G3A adversarial repairs
Repair 1: `ReservoirRegionData` now has an explicit initialization state. A raw constructor instance is only a reflection shell; only `createNew()` or successful entry into `readFromNBT()` initializes it. Existing file + uninitialized shell is `UNREADABLE`. The corrupt-file hash remained unchanged through the failure, proving the store did not overwrite it.

Repair 2: a pre-commit review found that using only `readFromNBTWasInvoked` would falsely reject a newly created shard after it had been saved and reopened within the same JVM. That design was rejected before commit. The final model uses `initializedForUse`, and the write probe explicitly saves then reopens the shard in the same server process before declaring PASS.

Final campaign source-of-truth: `evidence/g3a-reservoir-final`. The accepted valid shard SHA-256 is `9e9d4b16e2a6600d7ec9b1256c0c917ce60eeb0cdcf1ae402c8d4a2198ec76f5`; the intentional-corruption payload hash was `a186a1cea95d58343c5b056b18fef1c750a1612ef955e08bf6b426a75d3ef141`.

## Non-blocking observations
- Forge's legacy online version check emits malformed-JSON noise in the dev runtime.
- First-run server metadata JSON files may emit normal file-not-found warnings.
- `runServer`/Gradle can exit 0 even when FML reports a mod exception; therefore runtime probes are judged from explicit PASS markers and FML error content, never Gradle exit code alone.

## Approval rule
No future row can be promoted from BLOCKED/FAIL to PASS by visual inspection alone when persistence, conservation, networking or server classloading is applicable.

G6 subgate acceptance is partial project progress. Its handoff fixture prepares zero pressure via the public reservoir API (`pressurePreparedByApi=true`); it does not certify natural depletion duration. Its server GUI and client layout fixtures are separate, and the dedicated update loop is not a performance benchmark. Active shaderpacks, remote multiplayer, the modern grid editor, final presentation and production-world homologation remain separate gates.

Independent alpha.10 review (2026-09-12) rechecked all 12 final multiblock boots plus the two concrete-registry boots, all 245 JUnit results, 138 source hashes with zero divergences, and the three saved-region hashes. The invalid-Well and covered-pipe reproductions passed. No remaining concrete blocker was found within those dedicated/runtime subgates. This review does not extend approval to the outstanding survival, presentation, multiplayer, performance or production-world gates.
