# Immersive Petroleum 0.1.0-alpha.10 — Build Audit

Decision: **ACCEPTED alpha checkpoint for the documented subgates. Full premium/production qualification remains open.**

- Commit: `dc6587d2bbaf727acee241b6560813be26b89e44`
- Tag: `0.1.0-alpha.10`
- Git tree: `6363db8659c4fcfb57b030b7fce49343f8c9f882`
- Branch: `feature/derrick-v1`; clean working tree after commit/tag.
- Post-tag `clean check build --no-daemon`: PASS, 1m 59s, 26 actionable tasks.
- JUnit: 245 tests in 40 suites; 0 failures, errors or skipped tests.
- Main/test Checkstyle: 0 issues.
- Production JAR: `immersivepetroleum-0.1.0-alpha.10.jar`, 452,282 bytes.
- SHA-256: `271359f01e011aba5ee03121da085c51e0c9587143cd94d36e8c0c630ae9b20a`
- All 228 compiled classes: major version 52, Java 8.
- Embedded third-party classes: 0. Collision fixture entries: 0.
- `mcmod.info` and compiled `ImmersivePetroleum.VERSION`: both `0.1.0-alpha.10`.
- Post-tag build-log SHA-256: `c53d050cb6af2a56f46e3e8d7606440d5cc27c97de5771299b9573a1730f738e`.

## Accepted runtime evidence

The dedicated sequence passed 12 boots across Derrick, Pumpjack and Distillation Tower, plus two concrete registration/collision boots. Independent review rechecked the markers, 138 source-file hashes and all three saved-region hashes. The Derrick checks include physical/virtual resource accounting, real IE fluid output/spill, canceled inventory drops, future-NBT recovery, invalid-Well input quarantine and same-Well Pumpjack handoff. All three structures reject covered pipes without extra drops and retain valid formation, restart, break, reformation and eight orientations.

The final client run passed `DERRICK_RENDERER_PROBE_PASS draws=21 angelica=true cullRestored=true` and `DERRICK_GUI_LAYOUT_PROBE_PASS`; both PNGs were inspected. Shaderpacks were off. The GUI screenshot uses synthetic client layout values; server inventory admission/transfer has separate FakePlayer evidence.

Runtime campaigns used the RFG development environment. The final reobfuscated production JAR was built from the tagged source and independently checked as an archive. Launching this exact release JAR in the complete production modpack, copied-world migration and remote multiplayer remain pending; development-runtime success does not replace those gates.

## Package contents and limits

[Release notes](RELEASE-ALPHA10.md), [G6 evidence](G6-EVIDENCE.md), [operation guide](DERRICK-ALPHA10-OPERACAO.md) and [delivery plan](DELIVERY-PLAN.md) describe behavior and remaining work. `evidence/` preserves accepted logs, rejected reproductions, screenshots, final test reports and the source snapshot. The source ZIP is a Git archive of this commit; dependencies and Git history are available separately in the engineering workspace.

Survival concrete acquisition, directional grid editing, remaining modern features, final art/audio, active shaders, multiplayer and measured performance remain unapproved. No FPS, allocation-rate or many-machine throughput improvement is claimed.

`SHA256SUMS.txt` identifies every packaged file except the manifest itself. It provides integrity checks, not a digital signature. The per-world region hashes identify the retained diagnostic worlds in the engineering workspace; complete world copies are not included in this package.
