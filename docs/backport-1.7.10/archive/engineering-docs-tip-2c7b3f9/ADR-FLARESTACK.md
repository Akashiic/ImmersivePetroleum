# Flarestack — analog disposal with a single persistent owner

Status: development-lab qualification PASS on 2026-09-14. Source, three dedicated boots and the Angelica client were exercised on one source digest; pack/Crucible/multiplayer/performance/final-polish gates remain open. See `FLARESTACK-QUALIFICATION-2026-09-14.md`.

## Primary oracle and survival behavior

Frozen modern IP revision `e6cb01df32d4adfd096d49c02bb91e60fef56a15`: `FlarestackTileEntity.java`, `FlarestackBlock.java`, `FlarestackHandler.java`, `FlareFire.java`, generated `tags/fluid/burnable_in_flarestack.json` and `recipe/flarestack.json`, and `IPDamageSources.java`/the flarestack damage-type JSON. Legacy signatures and native redstone/entity-query behavior were checked with javap against `build/rfg/recompiled_minecraft-1.7.10.jar` and the pinned IE jar.

The lower cell owns a 250 mB tank. The upper cell has no tile or fluid capability. DOWN, UNKNOWN and an absent side expose fill/drain; other faces do not. The admission whitelist defaults to lubricant, diesel, diesel_sulfur, gasoline, naphtha, benzol, petroleum_gas, kerosene, plantoil, creosote and ethanol. These are Forge global fluid identities; existing registrations are reused. `FlarestackFuels.configure` publishes an immutable validated snapshot atomically and permits additional mod fluids. No new maximum number of fuels is imposed. Removing an admission entry does not silently discard existing fuel; as upstream, admitted stored fuel can finish burning. Unknown saved fluid registrations preserve the payload under quarantine.

The normal signal zero is idle; inversion makes zero dispose at full rate. Disposal uses the frozen float expression `(int)(250 * (strength / 15F))`, producing `0,16,33,50,66,83,100,116,133,150,166,183,200,216,233,250` mB/t for the 16 strengths. Each tick debits exactly the smaller of this request and the stored quantity. There are no output fluids, RF or duplicated deferred disposal jobs. Last-drained remains available while idle, matching modern. Operational disable retains tank/inversion and clears activity; registry content stays available.

Upstream has no modal GUI or bucket interaction. The backport retains pipe-driven use, supplies IE overlay/click information, a translated item tooltip and hammer inversion from either physical cell. Legacy IE lacks the modern screwdriver and fluid placer. The documented survival adaptations are IE hammer for inversion and IE fluid pump in the modern recipe's fluid-placer position: `IFI / CAC / IPI`, four plateIron, flint and steel, two steel mechanical components (IE itemMaterial metadata12), one fluid pump and one fluid pipe. No high-tier or creative-only material is required.

## Damage, appearance and audio

Active disposal every tenth world tick affects non-fire-immune entities in the modern box `[x-1,y-1,z-1] .. [x+2,y+2,z+2]`, with damage `6 * (disposed / 250F)`. The consumption is already committed/marked dirty before entity damage callbacks run; reentrant ticks and fluid ports cannot repeat it. The custom damage source preserves the modern armor-applicable damage behavior. Modern ignition is 15 ticks; the public legacy `Entity.setFire(int seconds)` can express one second (20 ticks), used here without reflection/coremod access. Upper-cell contact uses the legacy inFire source for the modern hotFloor one-point pilot hazard, even while idle. Vanilla1.7.10 has no goat or advancement system, so the modern goat-kill advancement is not claimed as implemented.

The original code-native model has a twelve-sided burner cup, annular lip, braced lower tube, vent collar and separate pilot assembly. It uses the installed Minecraft iron icon with original colors; no modern mesh, texture, flame sprites or audio is copied. The static mesh is built once. TESR/item draws restore matrix/current/enable state; bounds include the two-cell model. Client particles use one half-block rotating billboard every two active ticks, lifetime60, rising speed based on analog disposal, a gray-smoke transition at age24 and deterministic shared pseudo-wind. Idle pilot cadence/position match the modern five-tick behavior. Texture indices refer to installed vanilla flame/smoke atlas cells. The wind interpolation uses radians and the shortest angle path; this intentionally does not reproduce the modern raw-degree/radian interpolation quirk. Vanilla particle settings are respected.

The loop references the installed Minecraft `fire.fire` event at volume1/pitch.75; this is an audio adaptation, not the modern recording and not a claimed acoustic match. It redistributes no sound file. One tickable sound per audible tile uses a weak owner and stops on inactivity, deletion, world change or distance over16 blocks. Actual audio continuity, visual quality and renderer compatibility still require the client gate.

## Transactions and persistence

Server-side ports check live tile identity, complete ownership, configuration and quarantine. Fill/drain run under a lifecycle guard before fluid callbacks/identity reads, copy fluid NBT and return detached FluidStacks. Exact NBT primitive types, bounded quantities and consistent active/fluid fields are required. Future or malformed state is preserved raw and cannot expose fluid capabilities. Description packets contain only server-produced bounded state; no new client-to-server messages or Netty handlers exist.

Normal player break of either cell first publishes exactly one packed item containing the tank, inversion and raw invalid data when applicable. EntityJoinWorldEvent cancellation retains both cells and tank. A successful publication sets/persists the ownership latch before removal; repeated calls do not duplicate it. Publication exceptions retain an uncertain flag and stop automatic retries. Creative removal and `doTileDrops=false` deliberately suppress the packed drop. This preservation of tank contents improves on modern's ordinary empty block loot.

Placement stages both cells and revalidates ownership before committing packed data; failed pre-publication placement restores the replaceable cells, and a rollback failure is surfaced. Notifications occur after commitment. A notification failure cannot refund the held item after observers may have seen/harvested the machine. A singleton item-placement latch rejects recursive placement of the same held item during this window.

These boundaries do not make Minecraft item/world files an atomic database. Forced external deletion, explosions, dishonest callbacks that mutate arbitrary world state and a host crash between independent saves are outside the canceled-player-break certification. The normal destruction path does not force-load chunks or pretend an uncertain item publication can safely be retried.

## Work cost and chunk boundary

Disposal itself is constant scalar work. Idle server ticks allocate no disposal objects. The native analog query can inspect a neighbor's neighbors through `getIndirectPowerLevelTo -> getBlockPowerInput`; its horizontal dependency is Manhattan radius2. Thirteen loaded-position checks precede the query, postponing disposal at an unloaded power boundary until it loads naturally. There is no chunk ticket, asynchronous world access, world generation job or functional fuel/network limit. Third-party block power implementations may perform their own arbitrary work; the guard covers the verified native dependency.

The native entity AABB query explicitly checks chunk existence before obtaining chunks. Its list allocation and entity iteration happen only on active tenth ticks and scale with entities actually present; no FPS/TPS or worst-case dense-entity constant-cost claim is made. Each client fire particle allocates one entity every two active ticks; wind primitives are computed once per shared world tick and mesh geometry never rebuilds per frame. Changed descriptions are sent, while identical idle status is quiet. Performance improvements over the modern build have not been measured.

## Reviewable gates

`FlarestackStateTest` has ten tests: every analog level/inversion, cumulative partial conservation, disabled/no-signal retention, active-to-idle semantics, simulation/negative/overflow behavior, fluid-tag isolation, tick-by-tick roundtrip, strict corruption rejection and atomic immutable whitelist configuration.

`tools/run-flarestack-campaign.ps1` uses a fresh world, three actual boots, exclusive campaign mutex, loopback server binding, process-tree timeout cleanup, complete configuration restoration, mode-specific required markers and a saved-region SHA-256. Written modes:

1. `write`: real survival recipe, two cells/one tile, native IE fluid pipe admission, whitelist/sides/simulation, distant-player refusal, upper-cell hammer and retained250 mB/inversion.
2. `verify-break`: actual reload, disabled-config retention, all16 native redstone-wire strengths, custom entity callbacks demonstrating exact6 damage/fire immunity/reentry refusal, canceled upper-cell packed drop, retry and no duplicate.
3. `verify-reform`: actual packed-item reload, detached tank information, exact external100 mB drain, future-schema raw preservation on master break, fresh chunk-boundary deferral/no load and resumption after explicit fixture loading.

Markers: `FLARESTACK_SURVIVAL_PASS`, `FLARESTACK_DISPOSAL_PASS`, `FLARESTACK_RECOVERY_PASS`; every mode additionally requires `FLARESTACK_PROBE_PASS mode=... master=100079,80,100000`. Only completed cleanup publishes `FLARESTACK_CAMPAIGN_PASS`. The PowerShell runner parsed with zero parser errors; no Gradle/campaign was executed in this subtask.
