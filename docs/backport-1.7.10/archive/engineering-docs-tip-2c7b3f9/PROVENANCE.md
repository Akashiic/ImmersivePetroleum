# Provenance / Source Map

## Frozen upstream revisions
- TwistedGate Immersive Petroleum `1.21.1`: `e6cb01df32d4adfd096d49c02bb91e60fef56a15`
- TwistedGate Immersive Petroleum `1.12.2`: `670050389c777e47e8beda18bf41cb6e819b66d4`
- Flaxbeard legacy `master`: `dce4c3b8d2b59d30357a006cf1a5fd1640e61a30`

## Runtime dependency
- Forbidden Series IE artifact: `ImmersiveEngineering-garden-cloche-test-2.jar`
- SHA-256: `51cf081e5a7c9e92dc9ede65021ba2befbdd17971a070d7f26f8c83839c4ac2e`

## Additional frozen engineering references
- Immersive Engineering `1.21.1` scheduler/API reference: `75a27f03e4243544243567e8d5c38d336f4f10f4`.
- Petroleum Distillation Tower template NBT SHA-256: `f1a33208203e6daeead34e16e306b34856fbd6c11613cb8f3ed4245d0e500442`.
- The Distillation Java structure table is generated from that NBT and validated for exact size, palette counts, entry count and duplicate positions before emission.

## Generational responsibility
### 1.21.1
Authoritative reference for current feature semantics and current subsystem decomposition. Observed feature families include Reservoir polygons/pressure, Pumpjack, Derrick, Distillation Tower, Coker Unit, Oil Tank, Seismic Survey, Gas Generator, Auto Lubricator, Motorboat and Projector.

### 1.12.2
Primary portability bridge. It exposes Pumpjack through legacy-style `ModelBase/ModelRenderer` + TESR transforms and contains explicit OBJ/MTL assets for the Distillation Tower, reducing semantic distance to Forge 1.7.10.

### Legacy master
Historical regression source. It is used to identify behavior that existed before later rewrites and to avoid accidentally treating a recent design choice as eternal Petroleum semantics.

## No blind-copy rule
Every imported idea is classified as semantic port, algorithm adaptation, API compatibility rewrite, asset reference or original implementation. Modern NeoForge classes are not copied into 1.7.10 merely because names match.
