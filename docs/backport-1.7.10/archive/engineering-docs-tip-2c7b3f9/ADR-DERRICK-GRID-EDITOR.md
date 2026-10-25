# ADR - Derrick directional grid editor

Status: QUALIFIED in the development laboratory on 2026-09-14; remote multiplayer/Crucible/pack gates remain open.
Date: 2026-09-12

Target mappings are verified against this project's `build/rfg/recompiled_minecraft-1.7.10.jar`. Its inventory release hook is `mouseMovedOrUp`; the differently mapped Unimined cache is not authoritative for this build.

## Frozen behavior

The source of semantics is `upstream/ImmersivePetroleum-1.21.1`, commit `e6cb01df32d4adfd096d49c02bb91e60fef56a15`: `PipeConfig.onGridClick`, `PipeConfig.Grid.drawLine`, `IPContainerScreen_DerrickSettingsScreen`, `MessageDerrick.process`, and `DerrickLogic.transferGridDataToWell`.

The grid is 69 by 69, centered on the world X/Z coordinates of the Derrick. Selecting a destination constructs the same rounded center-to-destination line. Center and destination are fixed perforations; at most two internal pipe cells can be toggled to perforations. Every occupied cell adds one drilling unit, including perforated cells. Topology traversal remains row-major, without deduplicating reservoir components. Clicking a fixed cell creates a fresh line and clears optional perforations. The original vertical default has no additional units; the explicit vertical reset uses the existing empty-grid representation. No alpha.10 NBT schema changes are needed.

The original editor sampled terrain and used a dynamic texture. This implementation uses an original static drafting board and draws only the occupied route cells. It performs no terrain sampling, chunk loading, texture allocation or per-frame model construction. Compass directions and world-coordinate tooltips establish orientation independently of the machine's facing/mirror. Final visual approval remains a client gate.

## Authority and network flow

1. The server-created `ContainerDerrick` owns a random nonzero 64-bit session token and a monotonically increasing session revision. The live container instance, its original player, dimension/world and normal interaction distance authorize access.
2. Vanilla window properties synchronize the token in four 16-bit pieces, revision in two pieces, eligibility, endpoint, optional perforations and result. A final property commits the full snapshot on the client. Existing properties 0 through 5 are unchanged.
3. The GUI edits a private immutable draft. Save sends a fixed **20-byte** SimpleImpl message: protocol version, window ID, token, revision, endpoint and two optional perforations. The packet contains no world coordinates, NBT, dimensions or variable-sized arrays.
4. Netty only decodes/range-checks and inserts an intent into a synchronized mailbox. The mailbox stores at most 128 player entries and coalesces a sender's pending intent. The END server tick drains at most 32 intents. World/container access and mutations occur there, never in the packet handler.
5. The live container revalidates player identity, open window, token, revision, distance/world and edit eligibility. Valid attempts have a five-tick interval; repeated identical reply snapshots are also throttled. An old revision cannot overwrite a plan changed by another viewer. Closing/reopening creates a different token, preventing window-ID reuse from authorizing delayed packets.
6. The server reconstructs the canonical grid and rejects disconnected, duplicate, fixed-cell or off-route perforations. TileEntity configuration publishes the validated Well topology before the grid view. The Well must have zero buffered pipe units and zero drilled length, and must not be completed or self-destructing. After drilling starts the editor remains visible but read-only.

`DerrickNetwork.register()` is integrated during mod initialization. `clearServer()` clears pending references at server stop. The tick additionally rejects a player whose world object does not belong to the current server. No automatic retries occur on network timeout; the GUI preserves the draft and offers reset to the server snapshot.

This intentionally hardens the frozen modern message handler, which accepted client grid NBT without the full container/session and topology-lock policy. The established alpha.10 Well lock remains authoritative.

## Verification and limits

`DerrickGridEditorTest` checks all 4,761 endpoint choices, immutable clicks, the two-perforation limit, exact directional cost/tap positions and invalid descriptors. `DerrickGridMessageTest` checks exact wire length, malformed length/version/ranges, signed-short snapshot fragments and atomic client commit. These tests do not prove real Netty dispatch or graphical behavior.

`DerrickGridServerProbe.verify` is called by the scratch-world Derrick campaign in `write`, after the normal GUI admission test and before pipe insertion. It drives the production ByteBuf codec and container application path with a real Forge world/Well and fake player. It checks accepted directional cost (seven additional units/four taps), wrong window/token, stale replay, off-route perforation, rate limiting, range/open-container rejection, pipe-budget locking and grid persistence. It restores the exact pre-probe machine/Well NBT in `finally`, leaving the baseline vertical campaign unchanged. Marker:

`DERRICK_GRID_SERVER_PROBE_PASS wire=20 taps=4 additionalPipes=7 stale=true token=true range=true locked=true`

The probe directly invokes the same container method drained by the mailbox. Real remote multiplayer packet transit, GUI mouse interaction and visual layout still require client validation. No FPS or latency improvement is claimed without measurements.
## Qualification checkpoint â€” 2026-09-14

The final digest, server/client gates, survival acquisition and the corrected PT-BR tooltip are recorded in `DERRICK-GRID-QUALIFICATION-2026-09-14.md`. The final source passed 572 tests/92 suites, four dedicated boots and the Angelica client editor/renderer campaign. Real remote SimpleImpl transit remains explicitly outside this approval.
