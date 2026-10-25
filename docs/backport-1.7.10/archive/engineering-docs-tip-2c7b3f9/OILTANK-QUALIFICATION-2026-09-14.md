# Oil Tank — qualification checkpoint 2026-09-14

Branch: `feature/oiltank-qualification-20260914T1925`.
Base checkpoint: `56ea3a560870e6e263852715ee9d1ab3eb22de98`.
Final source digest: `e94930c4a86bcf155be05c462cae62c708671b4a6add0e6027b5ef080d78b7d9`.
Evidence root: `run/oiltank-resumption-20260914T1930`.

## Negative reproduction and persistence contract

A schema-1 OilTank state containing a previously unknown top-level field was accepted and normalized by `OilTankState.read/write`, which could discard future data. `OilTankEnvelopeTest` reproduced this before the patch: three tests, two failures; a nested unknown field inside `fluidTag` remained accepted as intended.

The state codec now validates only the OilTank envelope key set. Unknown top-level schema-1 fields fail closed so `TileEntityOilTank` preserves the original full runtime NBT in `invalidEnvelope` and quarantines operation. Fluid payload compounds (`fluidTag` and `pendingTag`) remain opaque and unrestricted by this envelope whitelist.

The negative run is preserved under `run/guarded-tasks/oiltank-envelope-red-v2-20260914T1930`. The final source check contains the new regression tests and does not weaken existing malformed-save assertions.

## Final source gate

`oiltank-final-source-20260914T1930`: `cleanTest check --no-daemon`, exit 0, source unchanged.
Final XML totals: **575 tests / 93 suites / 0 failures / 0 errors / 0 skipped**. Checkstyle main/test: zero findings.

## Four-boot dedicated-server gate

`oiltank-final-native-20260914T1930` completed with exit 0 and unchanged source digest. Campaign: `run/oiltank-multiblock-campaign/20260914T231532Z-420e311a7b8740b995ed94b10772d744`.

The write boot confirmed the 1,024,000 mB bounded tank, 10,000 mB equalization cap, 432 mB automatic output unit, redstone semantics, fixed and variable containers, inventory-full/distance rejection, reentrant-drain refusal and held-result validation. The break boot restored all 84 parts and confirmed idempotence with a persisted total of 40,000 mB.

The reform boot exercised cancellation/recovery with exact raw NBT, one diagnostic capsule, a persisted 432 mB unresolved output reservation and no automatic retry. The orientation boot covered eight orientations, six ports, persisted reservation state and structural break from master/dummy/external removal paths.

No final server log contains `Caught exception from immersivepetroleum` or `The state engine was in incorrect state`. The final region hash is `50d0805b1e614c84dd0634f720a341fad0548df3f95201b749a9c85204a41a01`.

## Client / Angelica gate

`oiltank-final-client-20260914T1930` completed with exit 0 on the same digest. The renderer executed 21 validation draws with Angelica loaded while checking restoration of cull, blend, depth, lighting and texture state.

The screenshot uses a unique UUID filename and SHA-256 `e59ee2f0f9fd6c3fc0803fa22c93877ce3575811862d47ed6652d1d80fe3a7fe`. Visual inspection confirmed a complete vessel with service deck, handrails, gauge and colored ports visible, with no obvious clipping. This is still a presentation foundation, not final shader/art/performance approval.

## Evidence integrity and limits

The final source/server/client receipts all report source digest `e94930c4a86bcf155be05c462cae62c708671b4a6add0e6027b5ef080d78b7d9`, source unchanged and exit code 0. `server.properties`, `eula.txt` and `options.txt` returned byte-for-byte to the hashes inherited from the previous checkpoint. The original Immersive Engineering dependency was not modified.

The consolidated machine-readable record is `run/oiltank-resumption-20260914T1930/final-qualification.json`; final JUnit and Checkstyle XML copies are retained beside it.

This checkpoint is development-lab qualification only. It does not approve Crucible/Java 21, the production modpack/world, authenticated multiplayer, arbitrary protection plugins, active shader packs, soak tests, final FPS/TPS benchmarks or final visual/audio polish. Review was performed by the same assistant with adversarial tests; no independent external reviewer is claimed.
