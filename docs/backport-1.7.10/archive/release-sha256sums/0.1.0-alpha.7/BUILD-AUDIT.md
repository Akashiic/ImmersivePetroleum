# Immersive Petroleum 1.7.10 - alpha.7 Build Audit

Freeze: `64d7932` / tag `0.1.0-alpha.7`
Target: Minecraft 1.7.10 / Forge 10.13.4.1614 / Java 8 bytecode
IE dependency: Forbidden `ImmersiveEngineering-garden-cloche-test-2.jar`

## Artifact
- `immersivepetroleum-0.1.0-alpha.7.jar`
- bytes: 197396
- SHA-256: `41dcf282ae79d4db32cb57395a10670653ee41edc1282c8359ca9d10ec0523f7`
- class major version: 52
- embedded Angelica/GTNHLib/UniMixins classes: 0
- collision fixture entries: 0
## Gates
- clean `check build`: PASS, 26 tasks
- JUnit: 116 tests / 0 failures / 0 errors
- Checkstyle: 0 real errors
- Pumpjack kernel: PASS
- Pumpjack multiblock write/restart/break/reform/orientation: PASS
- Well/WellPipe: PASS
- fluid registry normal + collision: PASS
- reservoir genesis: PASS
- persistence/corruption/recovery: PASS

## Renderer
Angelica 2.2.8 + GTNHLib 0.11.41 + UniMixins 0.3.1 dev client reached an integrated world on Intel UHD / OpenGL 4.6.
Accepted marker: `PUMPJACK_RENDERER_PROBE_PASS draws=37 angelica=true cullRestored=true`.
G4B3A approves the clean-room renderer foundation; final production art and active shaderpack certification remain G4B3B.
