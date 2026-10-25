# G6 Derrick Evidence - 2026-09-12

Status: **ACCEPTED for the dedicated-server/runtime subgates, client renderer foundation and fixture GUI layout. Complete premium delivery remains pending.**

This checkpoint accepts the implemented Derrick's formation, default drilling operation, persistence, server container admission, bounded pressure output, tested recovery paths, shaders-off client renderer foundation and inspected GUI fixture layout. It does not approve the complete modern feature set, final visual fidelity, production-world upgrade or a performance claim.

The evidence below belongs to the current working-tree implementation. The descriptive `alpha10` log filenames do not establish a release version, commit or JAR identity. Final package identity must be recorded separately in its build audit.

The final Derrick campaign includes the later invalid-Well and covered-pipe reproductions. Acceptance remains limited to the tested paths and fixture conditions recorded below.

## Build and test evidence

[Current clean build log](../run/derrick-alpha10-build.log) records completed `checkstyleMain`, `checkstyleTest`, `test`, `check`, `reobfJar` and `build`, ending with `BUILD SUCCESSFUL in 2m 2s` and `26 actionable tasks: 25 executed, 1 up-to-date`.

The subsequent [probe correction build](../run/derrick-alpha10-probe-build.log) passed `check build` in 1m 6s after making the remote fixture's chunk preparation explicit. It retains the 245-test result. The release's post-tag clean build is recorded separately in `BUILD-AUDIT.md` with the final artifact identity.

Direct aggregation of all `TEST-*.xml` under [build/test-results/test](../build/test-results/test) yielded:

| Measurement | Confirmed result |
|---|---:|
| JUnit suites | 40 |
| Tests | 245 |
| Failures | 0 |
| Errors | 0 |
| Skipped | 0 |
| Derrick package suites | 12 |
| Derrick package tests | 85 |
| Main Checkstyle errors | 0 |
| Test Checkstyle errors | 0 |

The 245-test totals were recalculated from the current XML reports after this clean build. The two Checkstyle counts were independently read from `build/reports/checkstyle/main.xml` and `test.xml`. The build includes the later audit repairs described below, but those repairs' new runtime reproductions remain in validation.

The four passing tests in [DerrickPressureTapAdapterTest](../build/test-results/test/TEST-flaxbeard.immersivepetroleum.common.machine.derrick.DerrickPressureTapAdapterTest.xml) independently cover zero pressure, zero field strength, infinite reservoirs and positive-pressure extraction stopping at the modern threshold. The finite-record campaign checks total extraction plus remaining amount, then requires another 100 calls to extract zero after pressure has ended. These tests execute the adapter against persisted-record objects; they are not a claim of long-duration gameplay validation.

## Concrete foundation normal/collision campaign

The [foundation driver result](../run/derrick-alpha10-foundation.log) records `DERRICK_FOUNDATION_CAMPAIGN_PASS` for campaign `20260912T163950Z-8db643178bf74a82a0d59dbb6640a3d5`. Both dedicated boots completed and emitted the expected marker:

| Case | Confirmed marker | Evidence |
|---|---|---|
| Normal registry | `DERRICK_FOUNDATION_PROBE_PASS concreteOwner=immersivepetroleum:concrete ownDefault=true blocks=59` | [normal log](../run/derrick-foundation-campaign/20260912T163950Z-8db643178bf74a82a0d59dbb6640a3d5/normal.log) |
| Existing concrete-name collision | `DERRICK_FOUNDATION_PROBE_PASS concreteOwner=immersivepetroleum:concrete ownDefault=false blocks=59` | [collision log](../run/derrick-foundation-campaign/20260912T163950Z-8db643178bf74a82a0d59dbb6640a3d5/collision.log) |

The normal boot ended with `BUILD SUCCESSFUL in 1m 54s`; the collision boot ended with `BUILD SUCCESSFUL in 1m 19s`. The [campaign summary](../run/derrick-foundation-campaign/20260912T163950Z-8db643178bf74a82a0d59dbb6640a3d5/campaign-summary.txt) identifies the separate fresh normal and collision worlds. This approves registration/material compatibility under those two fixtures, including a valid Petroleum concrete candidate while another registration is the effective default. It does not establish a native concrete production recipe or complete survival acquisition.

## Dedicated campaign

Accepted campaign directory:

`run/derrick-multiblock-campaign/20260912T164847Z-02674858209c41b2aafbb3b4506bd125`

The [campaign summary](../run/derrick-multiblock-campaign/20260912T164847Z-02674858209c41b2aafbb3b4506bd125/campaign-summary.txt) and [driver output](../run/derrick-alpha10-campaign.log) both contain `DERRICK_MULTIBLOCK_CAMPAIGN_PASS`. Each of the four boot logs contains its exact mode marker and a completed Gradle invocation. No `Caught exception from immersivepetroleum` or FML incorrect-state marker occurs in those accepted logs.

The runner created a fresh UUID-named scratch world with seed `1234567890123456789`, then reused it across boots. The main machine was at `100079,80,100000`, facing NORTH, unmirrored. No production world was used. The script preserves its original `server.properties`, EULA file and `JAVA_TOOL_OPTIONS`, uses the shared runtime-probe mutex and keeps previous probe worlds/logs.

| Boot | Accepted behavior | Evidence |
|---|---|---|
| `write` | Exact 59-part formation; incomplete structure rejected without mutation; original pipe NBT captured; physical step consumes 512 RF and 125 mB concrete; redstone pause; GUI admission and transfer checks; save | [write log](../run/derrick-multiblock-campaign/20260912T164847Z-02674858209c41b2aafbb3b4506bd125/probe-write.log) |
| `verify-break` | Restart verifies energy, tank, pipe budget and original NBT; physical and virtual drilling completes; pressure delivers/spills with observed conservation; canceled inventory publication retains all parts/items; successful break drops exactly seven stored pipe items; no duplicate on repeat | [break log](../run/derrick-multiblock-campaign/20260912T164847Z-02674858209c41b2aafbb3b4506bd125/probe-verify-break.log) |
| `verify-reform` | Restart verifies restored components and completed Well; reformation; unknown schema retained in raw recovery capsule; cancellation blocks dummy removal; malformed external pressure acknowledgement quarantines; Pumpjack reuses the same completed Well | [reform log](../run/derrick-multiblock-campaign/20260912T164847Z-02674858209c41b2aafbb3b4506bd125/probe-verify-reform.log) |
| `orientation-matrix` | All four horizontal facings with both mirror states form 59 owned parts; energy/input-side admission checked; pressure port is push-only; breaking restores components without ghost Derrick TileEntities | [orientation log](../run/derrick-multiblock-campaign/20260912T164847Z-02674858209c41b2aafbb3b4506bd125/probe-orientation-matrix.log) |

The source template is the frozen modern 5x8x5 `derrick.nbt`, SHA-256 `0732e434cbee57714eb7e8c85df3740d14ac0ab394e4db90fa7fc9341514c961`. The source-derived template and its transforms are also covered by the existing structure tests.

[Regeneration evidence](../run/derrick-alpha10-structure-regeneration.log) independently regenerated `DerrickStructure.java` into a scratch output and compared its full text with the working source: `DERRICK_STRUCTURE_REGENERATION_PASS`. The generator uses the development-only dependencies pinned in `tools/requirements-generators.txt`; they are not mod dependencies or embedded JAR contents.

The accepted replacement `write` boot also records `DERRICK_COVERED_PIPE_REJECTION_PASS unchanged=true extraDrops=0`. Its `verify-reform` boot records `DERRICK_CORRUPT_WELL_INPUT_PASS accepted=0 quarantined=true wellRestored=true` before the pressure and Pumpjack handoff checks.

### Observed runtime quantities

The accepted drilling marker reports two physical steps, 382 virtual steps, 64 pipe items, 250 mB concrete, 47,750 mB water and 4,213 manual update calls during the continuation after restart. The first physical step had already been committed by the `write` boot. The first-step persistence checks require 3,584 RF remaining from 4,096 RF, 63 pipe items, five buffered pipe units and 125 mB concrete.

The connected pressure test withdrew 837 mB: 500 mB reached the IE barrel and 337 mB was spilled. The disconnected test observed another 837 mB withdrawal and no barrel credit. Neither pressure test consumed drilling energy. The connected spill is expected for this fixture: the frozen IE 0.7.9 pipe accepts 50 mB per unpressurized call, and the Derrick pressure kernel permits ten output attempts. The probe first simulates that actual pipe and requires the simulation not to change the barrel. It then checks delivered amount and spill status against the measured reservoir debit.

The malformed endpoint fixture deliberately reports an impossible accepted amount. The accepted log records an initial 836 mB reservoir withdrawal, quarantine and zero subsequent withdrawal. This proves further operation stopped. It does not claim the first uncertain transfer was reversed or recovered.

The inventory-cancellation fixture intercepts only the seven-pipe item publication in this world and area. The player-removal path must return false with seven items still in the master and all 59 parts still formed. After unregistering the listener, the same path succeeds, and exactly seven items appear once. The future-schema fixture similarly cancels a recovery capsule while a healthy dummy is being removed from a quarantined master. It requires all parts to remain intact, then verifies one capsule retaining the exact schema-999 payload and opaque future field after successful disassembly.

The capsule is a diagnostic NBT record. This checkpoint does not implement automatic restoration/import of that record. Conservation assertions for inventory publication do not imply that ordinary disassembly refunds stored RF or unused tank fluid.

### Pumpjack handoff limit

The Pumpjack test reuses the actual Well completed through the Derrick's production drilling adapter. It checks two successful Pumpjack updates, 30 mB reservoir debit matched by 30 mB barrel credit, and 2,048 RF consumed.

Before installing Pumpjack, the fixture reduces the reservoir to half capacity through its public extraction API. The marker explicitly records `pressurePreparedByApi=true`. This tests eligibility, reuse and resource accounting at the transition. It does not measure the natural time needed for the Derrick to release all pressure.

### Server GUI limit

The GUI marker comes from a Forge FakePlayer and the real server `ContainerDerrick`. It checks near/far admission, rejection of an unknown GUI ID, rejection of out-of-range shift-click, conservation of four pipe items inserted and removed, and rejection of stone in the machine slot.

This is server-side container evidence. It does not certify a remote multiplayer session, packet delivery under latency, simultaneous users or the client's visual layout. No custom grid-editing packet is part of this checkpoint.

## Client renderer foundation and layout

The separately accepted [client campaign result](../run/derrick-alpha10-client-campaign.log) contains `DERRICK_CLIENT_CAMPAIGN_PASS`. Its [stdout log](../run/derrick-client-20260912T165937Z.stdout.log) records:

- `DERRICK_RENDERER_PROBE_PASS draws=21 angelica=true cullRestored=true`;
- `DERRICK_GUI_LAYOUT_PROBE_PASS`;
- `BUILD SUCCESSFUL in 2m 34s`.

The [stderr log](../run/derrick-client-20260912T165937Z.stderr.log) is retained alongside it. This is a real OpenGL client run with Angelica, with shaderpacks off. The renderer probe checks both active states across all eight facing/mirror combinations, then five additional off-screen draws. It requires no GL error left by those draws and restoration of `GL_CULL_FACE`. The screenshot separately captures the client-world master installed for normal TESR dispatch.

The delivery review inspected both saved PNGs: [Derrick structure](../run/screenshots/derrick-renderer-probe.png) and [GUI layout](../run/screenshots/derrick-gui-probe.png). The structure is fully in frame, and the panel is legible without overlapping labels. These observations approve the renderer foundation and this fixture's layout.

The GUI screenshot intentionally uses a client-only layout fixture with 12,000 RF, 4,000 mB water and progress 192/384. Its standby status comes from the fixture TileEntity. It is not a screenshot of those quantities synchronizing from an operating server machine, and it does not establish remote multiplayer authentication or network correctness. The separate server-container gate above owns the tested admission/transfer behavior.

## Rejected run and repairs

The first campaign, `20260912T161158Z-376ba5a0751145b3bde9b865d0a76e2e`, is **REJECTED as a complete passing artifact**. Its `write` boot passed, but [verify-break](../run/derrick-multiblock-campaign/20260912T161158Z-376ba5a0751145b3bde9b865d0a76e2e/probe-verify-break.log) failed during pressure dispatch with `source_protocol_error: tap metadata failed at index 0: IllegalArgumentException`.

The adapter had passed a canonical namespaced reservoir fluid ID into a kernel that expects the actual Forge registry name. The correction resolves the existing `ReservoirFluidBinding` before dispatch. The accepted replacement campaign exercises the complete real reservoir-to-IE-output path.

A separate code review found that pressure-limited flow includes a minimum 15 mB floor even when computed pressure is zero. Using that flow directly would allow continued free extraction below the pressure threshold. The frozen upstream `api/reservoir/Reservoir.java` explicitly checks positive pressure before extraction. `DerrickPressureTapAdapter` now rejects zero pressure, empty and infinite reservoirs, and the four adapter tests above pass.

Review also rejected the diagnostic assumption that an ordinary IE pipe must receive all pressure output. Its actual 50 mB admission bound is now measured by the probe; delivered fluid and intentional spill are accounted for separately. That correction changes the acceptance assertion, not the machine's gameplay flow limit.

### Later audit repairs and runtime reproductions

**External fluid admission and invalid Well lookup.** A `fill` call from another mod could encounter a Well block with a missing/invalid TileEntity and allow a lookup exception to escape before material admission. The lookup now has a narrow exception boundary: a lookup failure quarantines the Derrick and returns zero before accepting fluid; a Well with invalid persisted state is also rejected. The later tank commit and synchronization are deliberately outside this catch, so an exception after a possible mutation is not misrepresented as a retryable zero-acceptance result. The added `verifyCorruptWellInput` reproduction checks input rejection, quarantine and unchanged resource state. Its accepted runtime marker is `DERRICK_CORRUPT_WELL_INPUT_PASS accepted=0 quarantined=true wellRestored=true`.

**Covered IE pipes during multiblock formation.** Auditing the IE 0.7.9 block implementation established that replacing a pipe invokes `breakBlock`, which drops `scaffoldCovering` even when the formation write uses flags 2. Capturing that same cover in original NBT and restoring it on disassembly would allow repeated duplication. Derrick, Pumpjack and Distillation Tower now reject a pipe whose `scaffoldCovering` is non-null during matching/capture and recheck admission immediately before replacement. The player must remove the covering before formation. Uncovered pipes retain support for original colour and side configuration.

The added runtime reproductions install a covered original pipe, attempt formation, and require rejection without changing the pipe/block state or generating an extra dropped item. Cleanup removes only the injected fixture cover, then the existing valid formation path continues. All three final campaigns passed these reproductions and their four-boot lifecycle/orientation regressions.

An intermediate campaign `20260912T164307Z-c93dc17bcb524e80b6b07a851a27a914` passed write/break but was rejected at the first verification after restart. The diagnostic had implicitly relied on material matching to load its remote chunks. The production admission guard now correctly refuses unloaded chunks. The diagnostic was corrected to explicitly load its four bounded fixture chunks before assertions; the production guard remains unchanged. The replacement campaign cited above passed all four boots. Its Well corruption test rejects input before mutation and its covered-pipe test reports zero extra drops.

### Regression of earlier machines

| Machine | Final four-boot evidence | Saved region SHA-256 |
|---|---|---|
| Pumpjack | [campaign summary](../run/pumpjack-multiblock-campaign/20260912T165204Z-1cab336c391d496e99010be9dca22d88/campaign-summary.txt) | `cb3edbb71e715935f342240e12b8ccdba54feaf0e9aca3d8314bb1b7fcd78d6b` |
| Distillation Tower | [campaign summary](../run/distillation-multiblock-campaign/20260912T165533Z-88ed64e9a5894d1cbe12ce531ed5b510/campaign-summary.txt) | `4de7b0d326bcbf0c54d780fb958ed30eba274e7f5142ed278f7ff9f682ffbbe9` |

Their write logs require respectively `PUMPJACK_COVERED_PIPE_REJECT_PASS unchanged=true extraDrops=0` and `DISTILLATION_COVERED_PIPE_REJECT_PASS unchanged=true extraDrops=0`. Each then passes write, verify-break, verify-reform and all eight orientations with normal uncovered pipes. These are independent scratch worlds, not production-world migration evidence. Their new shared runner preserves prior worlds/logs and restores the original configuration.

[Source freeze evidence](../run/alpha10-source-freeze.log) verifies that all 138 source/resource/test files retain the hashes captured before the final three-machine sequence. The transient concrete collision fixture is absent from this snapshot and from final production packaging.

## Diagnostic identities

| Artifact | SHA-256 |
|---|---|
| Clean build log | `691e530d640e2e76e719e545d6d57a009f4e579e31c9f46811a04dd01979447a` |
| Probe correction build log | `f985eb7d33a7962a6055d53d20b47b668b06c0535796b85ae6bfb42d40c93a51` |
| Write log | `edf0cb9586945f7ab6793345a26a1039d17d44e0fbfe346a33bd77cb56f99dea` |
| Break log | `df5ed4c907fc7bf337b636fdf5c90d6237fca6b623e36428d18058f32d3a0b5b` |
| Reform log | `32d04b73212fb5c1185b6b8826bdecb24329f9eacf63d17700a3856f8765aaea` |
| Orientation log | `e0692b8cca4fcdd132309eadd4a7da649e02c6a29c4a535bac5d4cb491f85824` |
| Campaign summary | `b775e1693938451bfba05b8b1d76e95bbc2e709d2d343c46078677e80c97ca27` |
| Saved `region/r.195.195.mca` | `cbb1e04ee7de6e2e3fd2f5bdc24fec17c4b1a3c413478a0592d0b8e12a134a38` |

The region hash was independently recalculated and matches the summary. It identifies this saved diagnostic world; it is not a cross-run golden hash or a release JAR hash.

These hashes identify the accepted source-level diagnostic evidence. The delivered JAR has its own hash and build audit; a matching log hash does not establish a release binary's identity.

The logs still contain development-environment warnings/errors about missing binary/signature metadata, a GTNHLib client-target mixin on the server, and legacy FML scanning `module-info.class` from the JOML dependency. Those observations are preserved; the campaign does not establish that the complete environment is warning-free. The explicit malformed-output quarantine is an expected test event, not an unreported successful transfer.

## Gates still open

- Complete survival acquisition: **PENDING**; concrete is registered but has no native production recipe in this checkpoint. Diagnostic fluid supplies do not establish a survival journey.
- Active shaderpacks and final visual parity: **PENDING**; the accepted client run covers the shaders-off renderer foundation and inspected fixture layout.
- Modern 69x69 grid editor and its server-authorized edit protocol: **PENDING**; the default central-tap operation is the accepted path.
- Final original art, texture/material fidelity, sound presentation and active shaderpack certification: **PENDING**.
- Remote multiplayer authentication/UX, simultaneous inventory users and hostile packet testing: **PENDING**.
- Comparable CPU/GPU/allocation samples, frame-time data, many-machine scaling and loaded-world performance: **PENDING**. The 4,213 update calls are a bounded correctness campaign, not an FPS or timing benchmark.
- Complete pack compatibility and upgrade of a copied production world: **PENDING**. Passing the dedicated fixture does not approve production deployment.

The lifecycle decisions and implementation boundaries are recorded in [ADR-010](ADR-010-DERRICK-RUNTIME.md). Final delivery approval requires the remaining applicable gates; this file approves only the measured subgates above.
