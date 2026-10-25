# Portable Gas Generator — frozen 1.21.1 semantics on Forge 1.7.10

Status: implementation and laboratory qualification PASS on 2026-09-14; release/pack/Crucible/multiplayer gates remain separate. See `GAS-GENERATOR-QUALIFICATION-2026-09-14.md`.

Oracle: local upstream ImmersivePetroleum-1.21.1 revision `e6cb01df32d4adfd096d49c02bb91e60fef56a15`, `GasGeneratorTileEntity.java`, `GasGeneratorBlock.java`, `FuelHandler.java`, `IPServerConfig.Generation`, `recipe/gas_generator.json`. Legacy contracts verified by javap against the pinned `libs/ImmersiveEngineering-garden-cloche-test-2.jar` and Minecraft `build/rfg/recompiled_minecraft-1.7.10.jar`.

## Player behavior and energy accounting

The machine stores 8,000 mB of a configured fuel. One debit purchases 20 generation ticks: naphtha costs 9 mB; gasoline/benzol cost 6 mB; all three yield 256 RF per tick (5,120 RF per batch). A high redstone signal suspends generation. A full buffer preserves remaining paid ticks. Like modern, a full buffer can first reserve a new batch, then wait. Capacity and output use IE's `capacitorLV_storage` and `capacitorLV_output` values. Fluid fill/drain is available from UP/UNKNOWN; energy receive/extract from facing/UNKNOWN. The front can also push RF to an adjacent receiver. One copper LV or electrum MV cable is accepted; HV/structural cables are refused. Hammer rotation invalidates both catenary directions without discarding the cable.

No modal GUI exists upstream. The implementation provides IE's block overlay, translated click status, a readable item tooltip and a status lamp. The original code-native model includes a steel frame, fuel tank, cooling fins, engine casing and electrical terminal. Its mesh is built once, bounded by the block, and uses the installed Minecraft iron icon with original colors; no modern model/texture was copied. Render matrix/current/enable state is restored. Client smoke follows the upstream 4-tick cadence.

The engine loop references the installed IE `immersiveengineering:dieselGenerator` sound (confirmed in the dependency sounds.json), at upstream volume .3 and pitch 1.25. No audio file is redistributed or extracted into this mod. One tickable sound per audible machine stops on inactivity, removal, world change or distance over eight blocks. Weak references avoid retaining unloaded tiles/worlds. Audible quality and actual mixer behavior still need the client gate.

Survival recipe: seven `plateIron`, one legacy IE dynamo (`blockMetalDevice` metadata9), one LV capacitor (metadata1), using frozen pattern PPP / PGC / PPP. A real IE jerrycan is used by the dedicated acquisition probe. Sneak pickup checks a free inventory slot before ownership transfer. Normal player break publishes one packed item before removal; a canceled EntityJoinWorldEvent retains the machine. Publication is idempotent; uncertain publication quarantines the source. Fluid, energy and already-paid batch ticks survive packing. Preserving the partial batch improves on the modern item drop, which only records tank and power and can lose remaining paid work.

## Transaction and persistence boundaries

All gameplay is server authoritative, with live tile identity, world and player-distance checks. Fuel identities use current Forge global names so default-fluid collisions remain interoperable. `GasGeneratorFuels` offers atomic immutable registration/config snapshots. State NBT has schema1, exact primitive types, valid booleans, capacity/batch constraints, matching fluid NBT and explicit unresolved output reservations. Invalid state is retained raw and disabled. A changed IE capacity below saved contents causes preservation/quarantine rather than silent truncation. Disabled operational config retains registered content, fluids, energy and paid work.

External RF/wire publication simulates under a reentry guard, debits/reserves admitted RF, marks the tile dirty, then invokes execute. A valid partial acknowledgement refunds only the rejected remainder. A throw or impossible acknowledgement keeps the reserved debit and quarantine; reload never retries it. Fluid-container callbacks receive copies under the tile guard; held identity/NBT/count and live ownership are rechecked before exact state commit. Packed ownership flags are saved separately from the portable data.

These checks do not make arbitrary third-party callbacks transactional with Minecraft's filesystem. Forced external deletion, explosions and a host crash during item/world persistence are outside the certified canceled-player-break gate. No guarantee is made for dishonest endpoints that produce effects during simulation. Such third-party code can independently duplicate arbitrary Minecraft resources; our execute path nevertheless never retries an uncertain debit.

## Native wire solver and chunk safety

The IE network solver/cache is retained. Its ApiUtils.toIIC checks blockExists, but ConnectorLV.isEnergyOutput then queries the adjacent tile without checking that neighbour's chunk. The native solver invokes this method while rebuilding, so a connector on a chunk boundary can load the adjacent chunk. Before cold-cache rebuild, our preflight walks the existing direct-connection graph in slices of32 vertices, checking loaded connectors' output neighbours. It postpones rebuild while those neighbours are unavailable. There is no new maximum network size, hop count or number of destinations. The native solver itself stops at1,200 discovered output destinations; this is an IE limitation, not a new Petroleum limit.

A final same-tick graph/chunk verification rejects topology changes between preflight slices. Native cache invalidation remains responsible for cable edits. Before each delivery the path and endpoint are revalidated, including after the external simulation. The IE indirect cache lacks a dimension key; a tile therefore only reuses the exact native cache object it previously verified/built and replaces unverified entries at the same coordinates. This favors correctness when dimensions share coordinates, with possible extra rebuilds in that unusual case.

Wire loss uses native AbstractConnection.getPreciseLossRate and floor rounding, with transferred-rate bookkeeping and passthrough notification. Unlike the old connector's ignored execute return, our bridge observes the real acknowledgement and quarantines ambiguity. Generation output across wire/front/extract is limited to the LV output budget per world tick. Network search and final validation remain proportional to real graph size; native cold-cache rebuild is synchronous. No performance or constant-time claim is made without measurements. The preflight's32 vertices do not bound arbitrary third-party degree/callback cost. World reads stay on the server thread; no workers or chunk tickets are introduced.

## Integration and gates

Parent integration hooks:

- preInit: `PetroleumGasGeneratorContent.registerAll()`.
- init after IE: `PetroleumGasGeneratorContent.registerRecipes()`.
- client init: `GasGeneratorClient.register()`.
- server diagnostic entry: `GasGeneratorProbe.runIfRequested(server)`.
- operational switch: `PetroleumConfig.enableGasGenerator`.
- optional config list: call `GasGeneratorFuels.configure(String[])` with `name,mB_per_second,RF_per_tick`; defaults naphtha9/256, gasoline6/256, benzol6/256. Namespace immersivepetroleum: is normalized to the Forge global name.
- merge EN/PT from GAS-GENERATOR-LANG-HOOKS.txt.

Ten domain tests cover the three frozen fuels, batch pause/full buffer, portable/reload conservation, fluid-NBT identity, reentry, partial acknowledgements, uncertain delivery, malformed NBT and write-ahead checkpoints. The dedicated three-boot runner is `tools/run-gas-generator-campaign.ps1`; property `immersivepetroleum.gasGeneratorProbe`; modes write / verify-break / verify-reform. Detailed markers are GAS_GENERATOR_SURVIVAL_PASS, GAS_GENERATOR_PACK_PASS and GAS_GENERATOR_WIRE_PASS, plus mode-specific GAS_GENERATOR_PROBE_PASS and final campaign marker. The wire fixture intentionally puts a real IE LV connector at the end of an isolated chunk, checks zero chunk loads/zero RF debit, explicitly loads its neighbour, and checks native-wire delivery resumes. Visual/audio and complete mod-stack validation remain parent-controlled gates.
