# ADR-011 — Seismic Survey and portable results

Status: QUALIFIED IN LAB on 2026-09-14; release/Crucible/pack/multiplayer acceptance remains pending.
Source: frozen Petroleum 1.21.1 e6cb01df32d4adfd096d49c02bb91e60fef56a15.

## Source semantics

Reviewed SeismicSurveyTileEntity, SeismicSurveyBlock, SurveyResultItem, SurveyScan, ReservoirInfo, MessageSurveyResultDetails and the generated seismic_survey_tool recipe. The instrument occupies three vertical cells. It accepts one IE buckshot, fires with an empty hand, keeps an empty shell and applies ten ticks of recoil. A local reservoir produces an amount/fluid/percentage/expected-flow observation; a location outside an eligible reservoir produces a 65×65 scan, radius 32, with distance-blended noise and normalization. The backport uses the canonical existing reservoir identity and genesis rules.

The exact target IE JAR exposes buckshot as itemBullet meta 4 and emptyShell as meta 1. Its itemMaterial metadata 7, 10 and 11 are gunpartBarrel, gunpartHammer and componentIron; registration asserts the names. The modern SBH/SBS/MLM shaped recipe is retained with the corresponding IE 0.7.9 scaffolding and light-engineering blocks. It requires three scaffolding, two barrels, one hammer component, two iron components and one light-engineering block.

## Execution and conservation

Discovery is incremental on the server thread: at most 256 field-sample calls and a separate bounded loop-work allowance per scanner step. Completed geometry enters the same ReservoirResolver materialization path used by existing machines. Map rasterization and connected-component marking process at most 256 cells per step. Per world, SurveyTickBudget permits at most sixteen job steps each server tick, bounding aggregate sample calls at 4,096. This is a work-count ceiling, not a measured time or allocation guarantee. Primitive sets/queues have the same 65,536-column component bound; region NBT and biome authority remain the canonical resolver's synchronous completion operations.

No survey code requests a terrain chunk, chunk ticket or worker. Eligibility is resolved per connected scan component, rather than running complete reservoir discovery at every pixel. Distinct local components that connect outside the map can resolve to the same canonical record. This may repeat bounded discovery but never creates a different identity.

One shot consumes one buckshot before creating its saved pending UUID. The instrument retains the spent shell and the completed report until the player collects them. Inventory publication consumes source ownership only after confirmed insertion; an exception quarantines uncertain publication. Pending jobs restart discovery after unloading/reloading using the same paid-shot UUID and noise seed. The spent shell is not converted back into free ammunition. Packing and replacing at a different X/Z/dimension cancels pending research while retaining the shell, preventing remote scans of an old location.

Player break publishes one packed item before removal. Cancellation retains all three cells and paid state. Successful publication is idempotent and disables further machine work on a source tile retained by another cancellation. Uncertain publication blocks automatic retry. Creative break and doTileDrops=false deliberately discard the machine, as vanilla policies request. External forced deletion/explosion callbacks do not provide the same cancellable player preflight and are not certified by that test.

Three-cell placement validates air and edit rights before committing. Notification is a postcommit external-effects boundary: exceptions and final ownership changes are logged, but the consumed placement is not refunded after callbacks may have emitted drops.

## Report and client authority

Report schema 1 validates exact numeric types, dimensions/origin, UUID, bounded fluid names, unsigned reservoir amounts, exact 4,225-byte map and binary 4,225-byte eligibility plane. Future/corrupt machine payloads remain preserved and quarantined. Packed source-publication flags are persisted separately from portable process data.

Reports are observations, never bearer capabilities: their coordinates and NBT do not authorize reservoir mutation or server queries. Opening a report sends no C2S payload. Forged client-local observations cannot generate deposits, scan the server or extract resources. The server creates the item from its paid job; the client validates the bounded snapshot before opening.

The original notebook GUI provides north-up map sampling, world coordinates under the pointer, measured-deposit overlay and reservoir detail card. Modern's reverse storage axes are mapped into explicit north-up coordinates. Modern's details request is replaced by the eligibility snapshot already computed by the paid server job. The UI clearly states that data is an observation rather than live pressure. Dynamic texture creation/upload occurs on open or overlay toggle, with deletion on close. The original code-generated instrument mesh uses two TESR draws, master-only bounds and recoil transformation. One vanilla explosion sound and sixteen smoke particles provide a bounded firing cue; this is not the final premium sound/art qualification.

## Integration and acceptance

- preInit: PetroleumSurveyContent.registerAll().
- init: PetroleumSurveyContent.registerRecipes().
- initClient: SeismicSurveyClient.register().
- serverStarted: SeismicSurveyProbe.runIfRequested(server).
- Merge the EN/PT lines in SEISMIC-LANG-HOOKS.txt.
- PetroleumConfig.enableSeismicSurvey pauses new paid work and pending execution while keeping registered IDs and stored data.

JUnit covers canonical scanner parity on holes, disconnected islands, integer edges, limits and multiple noise seeds; exact sample budgets; strict report NBT; pending/ready state and quarantine roundtrips. The dedicated three-boot campaign uses the real recipe, FakePlayer held-item authority, buckshot/shell accounting, full inventory retention, paid job restart, canceled packed publication/retry/idempotency, top-part dismantling, packed same-site resume and a 65×65 no-terrain-load scan. Manual diagnostic steps advance the server tick epoch so the aggregate budget is not bypassed.

The final laboratory qualification passed on source digest c29eb8b52986913a76f0cf4d7df96b58c21e4f7403cd98c5f312828f4a0f154b: 565 tests/90 suites, the three-boot server campaign and the Angelica client campaign. Notebook readability, world/item rendering, overlay/detail views and resource reload were visually inspected. See SEISMIC-SURVEY-QUALIFICATION-2026-09-14.md. Crucible/Java 21, pack/world copies, authenticated multiplayer, arbitrary shaders, soak and benchmark gates remain separate.
