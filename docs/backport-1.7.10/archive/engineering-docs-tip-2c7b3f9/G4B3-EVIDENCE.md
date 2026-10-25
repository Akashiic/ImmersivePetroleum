# G4B3 Evidence - Pumpjack renderer foundation

Decision: **PASS for G4B3A / alpha.7**
Date: 2026-09-11

## Source and design evidence
- visual cadence cross-checked against frozen Immersive Petroleum 1.12.2 and 1.21.1;
- renderer geometry is clean-room and ships no copied upstream Petroleum art;
- dedicated-server classloading remains isolated through `@SidedProxy`;
- only the canonical formed master is render-eligible;
- conservative whole-machine AABB is retained for culling safety.
## Automated evidence
- `clean check build --no-daemon`: PASS, 26 tasks;
- JUnit: **116 tests / 0 failures / 0 errors**;
- Checkstyle XPath audit: **0 real errors** in main and test;
- kinematics: 100,000 rigid-length samples + 16,384 continuity samples;
- render envelope: 4 facings x 2 mirror states across moving poses;
- render budget: ~696 vertices / 174 quads per visible Pumpjack frame;
- master-only dispatch test prevents TESR work on the 31 non-master parts.
## Real client / Angelica gate
Scratch client stack: Forge 1614, IE 0.7.9 Forbidden, Angelica 2.2.8-dev, GTNHLib 0.11.41-dev and UniMixins 0.3.1-dev.

The alpha.7 probe reached an integrated world with Angelica GLSM and CPU culling active, then emitted:
`PUMPJACK_RENDERER_PROBE_PASS draws=37 angelica=true cullRestored=true`.

The 37 draws are 32 off-screen orientation/phase cases plus five visible frames. Post-draw OpenGL error state is zero and GL_CULL_FACE is restored.

Accepted alpha.7 screenshot SHA-256: `a5f1986022a611ed41f3679911aafbb7f37ff3e675303b333648d836bfd24346`.
Accepted client log SHA-256: `db31def827292411ca2037cd6861e29a28e5a71de381c71cec2b362740336e0c`.
## Regression closure before alpha.7 freeze
All earlier runtime gates were repeated on the renderer candidate and passed:
- G4B2C Pumpjack multiblock/restart/orientation campaign;
- G4B1 transaction-kernel campaign;
- G4B2B Well/WellPipe three-boot campaign;
- G4A fluid registry normal + foreign-default collision campaign;
- G3B deterministic genesis campaign;
- G3A persistence/corruption/recovery campaign.

## Scope boundary
G4B3A approves the safe clean-room renderer foundation and Angelica integration. It does **not** claim final production art, copied modern IP assets, active shaderpack certification, or final LOD policy. Those remain G4B3B / later compatibility work.
## Final alpha.7 runtime closure
- post-version Pumpjack multiblock campaign: PASS across write/break/reform/orientation boots;
- post-version Pumpjack kernel campaign: PASS;
- accepted alpha.7 multiblock campaign region hash for this run: `a507ed05c3ae52931248fd0e216152786e7f578b71a146a2852ddd64c41861cf`;
- artifact hash is recorded only after the Git tag is created and the post-tag clean build completes.