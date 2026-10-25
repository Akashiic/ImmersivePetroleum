# Native IE drill lubrication adapter

Status: implementation and verification in progress. Not a release approval.

Frozen modern IP contributes `toolupgrade_drill_lube.json` to modern IE. The OILED effect in the frozen IE `DieselToolItem.consumeDurability` avoids head wear for three of four random outcomes while retaining the head callback and one unit of fuel consumption. The pinned IE 0.7.9 artifact has no OILED flag. Its waterproof upgrade has different behavior and is not a substitute.

The backport supplies `toolupgrade_drill_lube` through native `IUpgrade`, type `DRILL`, and stores its own boolean in the drill's normal computed upgrade compound. Native workbench installation, removal, tool storage and persistence continue to own that state. Four iron plates, one fluid pipe and a 1000 mB lubricant bucket produce the upgrade. The normal bucket remainder is retained.

A narrowly targeted FML transformer runs after the native deobfuscation transformer (sorting 1001; the local Forge source places deobfuscation at1000). It changes exactly one `IDrillHead.damageHead` call in `ItemDrill.onBlockDestroyed` / its SRG name. It passes the existing head, head stack and wear amount, plus the native drill stack and acting entity, to the oil hook. It does not change tool effectiveness, hardness checks, creative exemptions, the `afterBlockbreak` callback, stored head writeback or fuel debit. There is no patch to World, Entity, networking or the generic TileEntity class.

The transformer verifies the native owner, invocation opcode, method descriptor, instance signature and unique call count. Unknown wear layouts fail explicitly instead of advertising an ineffective upgrade. Repeated transformation is idempotent. It does not resolve Minecraft classes while transforming. Stack depth is recomputed; the injection adds no control-flow branches. The GTNHGradle `coreModClass` property is relative to the existing mod group.

Focused tests use the actual pinned IE JAR bytes and also cover mapped development names, missing and displaced calls, repeated transformation and unrelated classes. `DrillOilProbe` invokes the real loaded IE method with128 deterministic seeds and checks both random outcomes, unchanged fuel debit, native workbench acceptance, NBT roundtrip and upgrade removal. This probe is tied to the scratch-world lubrication campaign. Passing bytecode tests alone does not prove a transformed runtime or compatibility with another mod's drill transformer; packaged runtime and the full modpack remain separate gates.

Source evidence: local `build/rfg/minecraft-src/java/cpw/mods/fml/relauncher/CoreModManager.java`, pinned IE disassembly in `run/drill-premium-adapter.javap.txt`, frozen IE 1.21.1 `DieselToolItem`, and [GTNHGradle properties](https://github.com/GTNewHorizons/GTNHGradle/blob/master/src/main/java/com/gtnewhorizons/gtnhgradle/PropertiesConfiguration.java).
