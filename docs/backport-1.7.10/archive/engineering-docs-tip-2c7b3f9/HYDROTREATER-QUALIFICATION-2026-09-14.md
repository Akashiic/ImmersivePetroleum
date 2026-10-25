# Hydrotreater — qualification checkpoint 2026-09-14

Branch: `feature/hydrotreater-qualification-20260914T2025`.
Base checkpoint: `c197971e3375ebe639f2c745f293dbb466faa04c`.
Final source digest: `083b9409e6d6441aecbd82059b6ca21733a58cf2510445eb4296bd3c340d3d62`.
Evidence root: `run/hydro-resumption-20260914T2030`.

## Persistence defects reproduced before approval

`HydrotreaterEnvelopeTest` first demonstrated that the TileEntity runtime envelope and its intermediate `machineState` compound accepted unknown fields even though the process/recipe codecs were already strict. That negative gate is preserved as `hydro-envelope-red-20260914T2030`; source remained unchanged and the expected two cases failed.

The first four-boot attempt was also rejected. The write boot passed, but restart failed `persisted process energy/progress drift`. Inspection of the exact pinned IE bytecode proved `TileEntityIEBase.readFromNBT` forwards the complete disk NBT to `readCustomNBT`. Vanilla 1.7.10 `TileEntity.writeToNBT` adds `id`, `x`, `y`, `z`; the new runtime whitelist had not allowed those legitimate fields, so the saved master entered quarantine/default state after restart.

The final whitelist therefore distinguishes vanilla/IE ownership fields from unknown future fields. It accepts `id/x/y/z` plus IE multiblock `formed/pos/offset/mirrored` and the exact Hydrotreater runtime fields. The intermediate `machineState` also has an exact key set. Unknown fields are preserved through the existing full `invalidEnvelope`, not normalized away.

## Final source and dedicated-server gates

`hydro-disk-envelope-source-20260914T2030` completed with exit code 0 and unchanged source. Final XML totals: **579 tests / 94 suites / 0 failures / 0 errors / 0 skipped**. Checkstyle main/test: zero findings.

`hydro-disk-envelope-native-20260914T2030` then completed all four server boots on the same digest. Campaign: `run/hydrotreater-multiblock-campaign/20260914T234722Z-ba311a2455194f5281cc63bd0fb3959a`.

The write boot proves stale-master/input/energy/output rejection, read-only GUI authority, redstone admission rules and a 50/100-tick paid process checkpoint at 4,000 RF. The restart boot completes that same process and confirms total 8,000 RF, 1,000 mB sulfur diesel + 500 mB water consumed, 1,000 mB diesel and five sulfur items delivered, then restores all 32 parts.

The recovery boot preserves exact rejected raw NBT, emits one diagnostic capsule after cancellation, retains a 1,000 mB unresolved fluid reservation and performs zero automatic retries. The orientation boot covers eight orientations, 32 parts, all three modern recipes, a persisted 1,000 mB reservation and master/dummy/external structural breaks.

No final server log contains `Caught exception from immersivepetroleum` or `The state engine was in incorrect state`. The final region SHA-256 is `6ceea3573b8d055f00ae2f258b95ea03ec574ffeb7a40138affe6f4f5a99ebde`.

## Client / Angelica gate

`hydro-disk-envelope-client-20260914T2030` completed with exit code 0 and unchanged source on the same digest. The renderer executes 21 orientation/activity validation draws while checking cull, blend, lighting, depth and texture restoration. Evidence filenames are UUID-unique and never delete prior captures.

The renderer screenshot SHA-256 is `a433f7df14b89645eb4cf7f4b255a118dcd2fd26abecf175f7f688f06e3882c7`; the GUI screenshot SHA-256 is `243c46708515d63857764c87e18ab0bd9f2b2d69caaf641403da67d53e860dae`. Visual inspection found the complete pressure-drum model visible and the GUI's three tanks, RF and progress legible without obvious clipping.

The source/server/client receipts all bind to `083b9409e6d6441aecbd82059b6ca21733a58cf2510445eb4296bd3c340d3d62`. Lab `server.properties`, `eula.txt` and `options.txt` returned byte-for-byte to their inherited hashes. Consolidated machine-readable evidence is `run/hydro-resumption-20260914T2030/final-qualification.json`.

This is development-lab qualification, not approval of Crucible/Java 21, production pack/world, authenticated multiplayer, arbitrary protection plugins, active shaders, soak or final FPS/TPS/art/audio. Review was performed by the same assistant; no independent reviewer is claimed.
