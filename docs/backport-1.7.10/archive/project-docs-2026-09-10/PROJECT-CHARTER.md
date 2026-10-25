# Immersive Petroleum 1.7.10 Premium Backport — Project Charter

Status: ACTIVE / G0 FOUNDATION
Date: 2026-09-09
Owner role: Chief Engineer + Auditor + Approver

## Mission
Build a premium, high-fidelity 1.7.10 reimplementation/backport of Immersive Petroleum for the Forbidden Series runtime, preserving the industrial identity and modern feature set while using architecture appropriate to Forge 1.7.10 rather than blindly transplanting NeoForge code.

The target is not "make it run". The target is a production-grade addon with modern-looking multiblocks, deterministic simulation, save-safe world data, correct fluids/energy, robust multiplayer synchronization, Angelica-aware rendering, and explicit performance budgets.

## Canonical runtime target
- Minecraft 1.7.10
- Forge 10.13.4.1614
- Java 8 bytecode
- Immersive Engineering: `ImmersiveEngineering-garden-cloche-test-2.jar`
- IE SHA-256: `51cf081e5a7c9e92dc9ede65021ba2befbdd17971a070d7f26f8c83839c4ac2e`
- GTNHLib 0.11.41
- Hodgepodge 2.7.189
- UniMixins 0.3.1
- Angelica 2.2.8

## Source-of-truth hierarchy
1. Actual Forbidden Series runtime binaries and observed behavior.
2. Our current IE 1.7.10 backport source and built artifact.
3. TwistedGate Immersive Petroleum 1.21.1 for current semantics/features.
4. TwistedGate Immersive Petroleum 1.12.2 as migration bridge.
5. Flaxbeard legacy source for historical behavior and regression archaeology.
6. Exact-version Forge/IE/GTNHLib source and documentation.
7. Runtime logs/profiling and reproducible tests.
8. Inference only when explicitly labeled and backed by a validation plan.

## Non-negotiable constraints
- Never modify the production modpack JARs during development.
- Keep Petroleum a separate addon; do not pollute IE core without a proven API deficiency.
- Preserve `ImmersiveEngineering` registries and existing world compatibility.
- Every new block/item/TileEntity receives stable IDs/names and a migration policy before release.
- Dedicated-server classloading is a mandatory gate; client renderer classes never leak server-side.
- Reservoir generation must be deterministic, bounded, persistent and dimension-aware.
- Fluid and energy mutations must be transactional enough to prevent duplication/loss on partial failure.
- Multiblock break/reform/chunk-unload behavior must be idempotent.
- Rendering state must be balanced and tested with Angelica enabled; no hidden OptiFine dependency.
- No per-tick log spam, unbounded allocations, unbounded scans or synchronous disk I/O in tick paths.
- Optional integrations must fail soft and be isolated behind adapters.
- Every major feature family has a config kill-switch.

## Asset/provenance rule
The current CurseForge distribution is marked All Rights Reserved and the cloned repositories do not expose a root license file. Upstream code/assets are therefore evidence/reference material until redistribution rights are resolved. Public packaging of copied models/textures is blocked by a dedicated license gate. Clean-room/recreated assets remain an allowed implementation path.
## Definition of Done for a feature
A feature is APPROVED only when all applicable checks pass:
- provenance and target semantics recorded;
- clean build and reobfuscated artifact succeed;
- client and dedicated server load;
- baseline IE world loads without remaps;
- new-world creation succeeds;
- multiblock form/break/reform tests pass;
- chunk unload/reload and restart persistence pass;
- energy/fluid conservation tests pass;
- network synchronization cannot trust invalid client state;
- NEI/manual integration does not crash;
- Angelica ON/OFF smoke tests pass where rendering applies;
- performance budget is measured or analytically bounded;
- failure-path tests show no dupe, voiding or ghost multiblocks;
- configuration defaults and migration notes exist;
- auditor records PASS/FAIL with evidence.

## Approval philosophy
Compilation is evidence of syntax, not correctness. A subsystem with unresolved save corruption, duplication, server classloading, rendering-state leakage or unbounded tick cost is REJECTED even when visually functional. Failed gates return to the smallest responsible layer; unrelated rewrites are forbidden.
