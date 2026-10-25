# Motorboat semantic contract and Forge 1.7.10 architecture

Status: development-lab qualification PASS on 2026-09-15; Crucible/pack/multiplayer/final audiovisual acceptance remain pending.

## Frozen references

Modern oracle: Immersive Petroleum 1.21.1 revision `e6cb01df32d4adfd096d49c02bb91e60fef56a15`, `common/entity/MotorboatEntity.java`, `common/items/MotorboatItem.java`, `common/IPContent.java`, `common/cfg/IPServerConfig.java`, and generated `recipe/speedboat.json` plus the five `recipe/upgrade_*.json` files. The explicit legacy physics bridge is IP 1.12.2 revision `670050389c777e47e8beda18bf41cb6e819b66d4`, `common/entity/EntitySpeedboat.java`. API names come from the project's `build/rfg/recompiled_minecraft-1.7.10.jar` and pinned IE `ImmersiveEngineering-garden-cloche-test-2-deobf.jar`, inspected with `javap`.

## Observable modern contracts

| Contract | Oracle behavior |
|---|---|
| Upgrade inventory | Three slots, no duplicate upgrade type, engineer's workbench |
| Five upgrades | Reinforced hull, icebreaker, extra tank, rudders, paddles |
| Fuel | Gasoline 1 mB/tick; naphtha and benzol 2 mB/tick; consumed while forward or reverse input is active |
| Capacity | 8000 mB, 16000 mB with tank upgrade |
| Motor drive | Forward acceleration .05, reverse -.01; boost forward ×1.6 and fuel ×3 when enough fuel remains |
| Steering | 1.1 × horizontal speed; rudders ×1.5, boost input ×.5, reverse-only ×2 |
| Emergency paddles | With insufficient fuel: forward .04, reverse -.005, turning-only .005 and ±1 yaw momentum |
| Reinforced hull | Boats in lava, ignores fire damage; non-player destruction threshold increases from >40 to >240 damage counter |
| Icebreaker | Only ordinary ice in expanded hull bounds and front dot product >.3 becomes water; non-player living collision in front dot>.5 receives 4 damage and .75 horizontal push when driven by a player |
| Passengers | Two; unpiloted boats may automatically collect small non-player living entities except water animals |
| Submersion | Eject passengers after 60 submerged ticks |
| Item lifecycle | Place within five-block raycast/collision clearance; destruction returns the boat with fuel and all installed upgrades |
| Audio | IE diesel-generator loop; .3 idle/.5 moving volume, .5 idle/.7 moving/.9 boost pitch; no emergency motor loop |
| Rendering | Hull, motor/rotating propeller, rudders, reinforced panels, icebreaker, extra tank and emergency paddle animation |

## Adaptation decisions

The modern `MessageConsumeBoatFuel` trusts a client-provided amount. The backport deliberately replaces this with a bounded input-only protocol. Only the authenticated driver may submit input flags; position, velocity, fuel quantity and upgrades are never accepted from that packet. One server tick performs one consumption and drive calculation. Stale controls expire. Client rendering interpolates server state and has no authority to debit fuel.

The 1.7.10 entity model has one native riding link. A dedicated `EntityMotorboatSeat` represents the second passenger, linked to its boat by persistent UUID and constrained to one seat. Both entity types are registered with local IDs 60 and 61. Ownership resolution must use loaded entities only; no chunk tickets, synchronous terrain generation or unbounded world search belongs to the vehicle.

Removing the tank upgrade while holding more than 8000 mB retains the exact existing quantity, up to the schema's 16000 mB bound. This excess is consumable but rejects further filling until below the reduced capacity. It does not produce containers or discard fuel. This avoids an atomicity trap in IE's legacy workbench storage setter, which runs after a slot extraction.

The state codec preserves unknown or malformed payloads, quarantines them and blocks deployment or resource exchange. A failed external publication may be retried only after a definite rejection; an exception freezes the source as uncertain. Item and entity transitions validate source identity and immutable snapshots around callbacks.

Modern engine equations are separated from world collision and fluid sampling. The 1.12.2 source makes the buoyancy constants explicit: gravity -.03999999910593033, water friction .9, submerged .45, flowing-submerged vertical acceleration -.0007, and buoyancy ×.06153846016296973 followed by vertical ×.75. Water-entry repositioning and legacy block collision sampling require dedicated runtime gates. This document makes no performance or gameplay-equivalence claim before those gates run.

## Integration hooks

Family classes remain under `common.motorboat` and `client.motorboat`, or have `Motorboat` in their filenames. Planned coordinator hooks are `MotorboatContent.preInit()`, `MotorboatContent.init()`, `MotorboatNetwork.clearServer()`, `MotorboatClient.init()` and `MotorboatServerProbe.runIfRequested(server)`. The shared configuration supplies `enableMotorboat`; fuel configuration is parsed into an immutable admission table. The item implements the actual IE 0.7.9 `IUpgradeableTool`/`IInternalStorageItem` interfaces with three workbench slots, so no custom GUI ID is required.

## Qualification checkpoint — 2026-09-15

The frozen modern/legacy references above were used to close five previously documented semantic deltas: emergency icebreaker entity strike, direct damage source identity, lava passenger offset, AIR→LAND fall callback timing, and bounded/short-path propeller rotation. Their negative reproduction and final runtime evidence are recorded in `MOTORBOAT-QUALIFICATION-2026-09-15.md`.

The development-lab matrix passed 594 tests/97 suites, three dedicated-server boots and an Angelica client run on one unchanged source digest. Client qualification includes the real Motorboat sound lifecycle through mute, range, resource reload, restart and entity removal. This does not certify subjective audio quality or final art.

Authenticated multiplayer control, Crucible/Java 21, copied production pack/world, arbitrary shaders, soak and benchmark remain release gates rather than implementation assumptions.
