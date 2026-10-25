# G5C Evidence - Distillation Tower renderer foundation

Decision: **PASS for G5C1 / alpha.9**
Date: 2026-09-12

## Scope accepted
This gate accepts the clean-room Distillation Tower TESR foundation, master-only dispatch, conservative whole-machine culling envelope, Angelica 2.2.8 compatibility and deterministic visual evidence.

It does **not** claim final production art, copied modern Petroleum assets, third-party shaderpack certification, GUI/NEI/CraftTweaker presentation or final LOD policy.

## Renderer design evidence
- no copied Immersive Petroleum model or texture is distributed;
- target IE material icons are reused from the runtime block atlas;
- static industrial geometry includes shell, structural bands, decks, rails, ladder, riser, takeoffs and instrumentation;
- active state adds a lightweight heat/emissive-style layer;
- only the formed canonical master has non-zero TESR render distance.
## Real client / Angelica gate
Scratch client stack: Forge 1614, IE 0.7.9 Forbidden, Angelica 2.2.8-dev, GTNHLib 0.11.41-dev and UniMixins 0.3.1-dev.

The probe enters an integrated flat world with Angelica GLSM and CPU culling active. It audits 16 off-screen combinations (4 facings x 2 mirror states x inactive/active) plus five active draws and requires zero post-render GL errors with culling state restored.

Accepted marker shape:
`DISTILLATION_RENDERER_PROBE_PASS draws=21 angelica=true cullRestored=true`.

The screenshot path is made deterministic by installing one formed master into the scratch client world, forcing a render update and waiting additional client ticks before capture. Transient manual-draw screenshots that sometimes missed the tower are explicitly rejected as evidence.
## Alpha.9 final validation
After the source and metadata bump to `0.1.0-alpha.9`:

- `gradlew clean check build --no-daemon`: PASS, 26 tasks;
- JUnit: **159 tests / 0 failures / 0 errors**, including **43 Distillation tests**;
- Checkstyle main/test: **0 errors**;
- real client loaded `immersivepetroleum@0.1.0-alpha.9` with Angelica 2.2.8 and emitted the accepted 21-draw marker;
- deterministic in-world screenshot SHA-256: `3372120e93be112ed4cd6fa6201e3a1b75d7536acb2d7c0a605c8b698aaae3f8`;
- accepted alpha.9 client log SHA-256: `57825046e871598e78dff14f685a2f15022a85fcdf79ed178d5a9ab5503b2387`;
- `DISTILLATION_MULTIBLOCK_CAMPAIGN_PASS` across write, verify-break, verify-reform and 8-orientation matrix boots;
- accepted alpha.9 runtime campaign region SHA-256: `8e82e14e42d30554a75dd35f64ab9ba80e4c585ef2185b3126068d1efdbd0f17`;
- dedicated-server `DISTILLATION_FOUNDATION_PROBE_PASS blocks=1 items=1 template=137`, proving registry/material invariants and client/server classloading isolation.

The screenshot and client log are archived outside the Git work tree under `evidence/g5c-alpha9-renderer`.