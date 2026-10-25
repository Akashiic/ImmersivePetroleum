# Flarestack — qualification checkpoint 2026-09-14

Branch: `feature/flarestack-qualification-20260914T2215`.
Qualified source digest: `6a9378559704130a11b505d1de63fc5ab10e9ec3bb1308d201d1430b1c617cdd`.
Evidence root: `run/flare-resumption-20260914T2225/final-qualification.json`.

## Gates accepted

- source check: 589 tests in 96 suites, zero failures/errors/skips and zero Checkstyle errors;
- dedicated server: three fresh boots on the same source digest;
- client: Angelica client probe on the same source digest;
- configs: `server.properties`, `eula.txt`, `options.txt` and `config/splash.properties` restored byte-for-byte;
- saved region and client screenshot verified by SHA-256.

Server coverage includes the survival recipe, two-cell ownership, native IE fluid-pipe admission, hammer inversion, every analog signal level, damage/fire-immunity callback behavior, canceled packed publication, duplicate suppression, packed restart, exact external drain, future state preservation, runtime-envelope preservation and chunk-boundary deferral without forced loads.

Client coverage includes idle and active TESR draws, item renderer, IE overlay, Angelica GL-state restoration, real `FlareFireParticle` insertion and fire-loop lifecycle. The screenshot was visually reviewed as a functional foundation; it is not final audiovisual art.

## Defects reproduced and closed

`flare-envelope-red-v2-20260914T2225` demonstrated two production defects before correction: schema-1 state accepted an unknown top-level field, and the TileEntity envelope did not preserve unknown runtime fields independently from `flareState`. The final implementation rejects unknown state fields, keeps `fluidTag` opaque, separates `invalidEnvelope` from `invalidState`, requires canonical runtime booleans and preserves invalid runtime payloads without exposing fluid capabilities.

The first final source attempt was rejected for an infrastructure `PermissionError` while the receipt writer replaced `status.json` on Windows. Its source was unchanged and it is not counted as a product failure or PASS. `guarded_task.py` was separately hardened to use per-process temp files and bounded exponential retries; a 499-write stress run passed before the accepted source gate.

## Scope limits

This checkpoint is a development-lab qualification, not a release. It does not prove Crucible/Java 21 pack compatibility, a copied production world, authenticated multiplayer, arbitrary third-party redstone blocks, dishonest callbacks, host-crash atomicity, shaders, dense-entity performance, soak behavior or final audio/visual polish. The 1.7.10 fire duration remains the documented one-second legacy API adaptation rather than an exact modern 15-tick representation.

The accepted region SHA-256 is `df2895022f4bf544cacb44ef55f22a6571825ba14a01496abded2e94253bd6ea`. The accepted client image SHA-256 is `c3f7af4e4666b913fe5b763ecb3b7a97f0e8524980d84b571d290ef5f198f761`.
