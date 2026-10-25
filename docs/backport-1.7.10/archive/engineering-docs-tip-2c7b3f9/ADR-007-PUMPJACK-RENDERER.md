# ADR-007 - Pumpjack renderer foundation

Status: ACCEPTED for G4B3A / alpha.7
Date: 2026-09-11

## Decision
The first production Pumpjack renderer is a clean-room procedural TESR owned by the canonical Pumpjack master. It uses no copied Immersive Petroleum textures, models or Blender assets.

Client code is isolated behind FML `@SidedProxy`; dedicated-server code never references LWJGL, Tessellator, TextureMap or the client renderer.

The renderer uses the 1.7.10 block atlas and exact Forbidden IE material icons. Static and moving geometry are emitted through one Tessellator draw per visible master.
## Kinematics
The visual cadence is source-derived, not guessed: frozen 1.12.2 and 1.21.1 both evaluate animation at `1.5 * activeTicks / 25`, equivalent to 0.06 rad/tick.

Geometry is clean-room. A rigid four-bar solver derives crank, pitman, beam and horse-head positions from one phase value. Tests cover 100,000 phases for rigid lengths and 16,384 samples for branch continuity.

## Render-dispatch rule
Only a formed master is render-eligible. Non-master parts return zero render distance and a local 1x1x1 AABB, preventing 31 redundant TESR calls per machine.

The master retains a deliberately conservative whole-machine render envelope because Angelica 2.2.8 has known culling-sensitive paths; tightening this box provides negligible value at the current geometry cost.
## Performance decision
Current renderer budget is approximately 696 vertices / 174 quads per visible Pumpjack frame: 480 static vertices and 216 dynamic vertices.

Given this low cost, display-list/VBO caching is intentionally deferred. Angelica already emulates fixed-function state and GL_QUADS; adding a second caching layer now would increase compatibility risk for little measurable benefit.

## Angelica validation
The accepted client gate uses Angelica 2.2.8-dev, GTNHLib 0.11.41-dev and UniMixins 0.3.1-dev in the MCP development runtime. The tested GPU was Intel UHD Graphics / OpenGL 4.6 core profile with Angelica FFP emulation enabled.

The probe executes 32 orientation/phase draws plus five visible frames. Every draw requires `glGetError()==GL_NO_ERROR`, and GL_CULL_FACE must be restored exactly.

Active third-party shaderpack validation and final production art fidelity are explicitly deferred to G4B3B; G4B3A must not be interpreted as final art approval.