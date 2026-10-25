# Immersive Petroleum 0.1.0-alpha.9 - Build Audit

- Git commit: `cff03f9`
- Git tag: `0.1.0-alpha.9`
- Gate: G5C1 Distillation Tower renderer foundation
- Post-tag clean build: PASS (`clean check build`, 26 tasks)
- JUnit: 159 tests / 0 failures / 0 errors
- Distillation tests: 43
- Checkstyle main/test: 0 errors
- Java bytecode: class major 52 (Java 8)
- Final JAR SHA-256: `23e2b61f7f2b4f75a77bc732b50592354d6603edfde25b3d9bf211e98e315871`
- JAR size: 296923 bytes
- Embedded Angelica/GTNHLib/UniMixins classes: 0
- Fluid collision fixture entries: 0

## Runtime gates

- `DISTILLATION_RENDERER_PROBE_PASS draws=21 angelica=true cullRestored=true`
- `DISTILLATION_MULTIBLOCK_CAMPAIGN_PASS` (write / verify-break / verify-reform / 8-orientation matrix)
- Distillation runtime region SHA-256: `8e82e14e42d30554a75dd35f64ab9ba80e4c585ef2185b3126068d1efdbd0f17`
- `DISTILLATION_FOUNDATION_PROBE_PASS blocks=1 items=1 template=137`
- Alpha.9 screenshot SHA-256: `3372120e93be112ed4cd6fa6201e3a1b75d7536acb2d7c0a605c8b698aaae3f8`
- Alpha.9 client log SHA-256: `57825046e871598e78dff14f685a2f15022a85fcdf79ed178d5a9ab5503b2387`

## Scope boundary

This checkpoint approves the clean-room Distillation Tower renderer foundation and its Angelica integration. Final original art/material polish, active third-party shaderpack certification, GUI/NEI/CraftTweaker integration and measured LOD policy remain later gates.
