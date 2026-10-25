# Feature Matrix — Modern Target vs Bridge

Source freeze: TwistedGate 1.21.1 @ `e6cb01df...`; TwistedGate 1.12.2 @ `67005038...`.

| Family | 1.12.2 bridge | 1.21.1 target | Backport policy |
|---|---|---|---|
| Reservoirs | per-deposit/chunk cache | polygon/noise reservoirs + pressure | modern semantics, safer bounded storage |
| Pumpjack | yes | yes | first extraction vertical slice; linked 3D armature |
| Distillation Tower | yes | yes | modern recipe outputs, premium static geometry |
| Derrick | no | yes | modern expansion after Pumpjack |
| Coker Unit | no | yes | modern processing expansion |
| Hydrotreater | no | yes | modern processing expansion |
| Oil Tank multiblock | no | yes | modern storage expansion |
| Seismic Survey | no | yes | modern exploration UX |
| Well / Well Pipe | no | yes | modern reservoir infrastructure |
| Auto Lubricator | yes | yes | preserve + audit IE handlers |
| Gas Generator | yes | yes | preserve with transaction/perf audit |
| Flarestack | no | yes | modern utility expansion |
| Projector | yes | yes | port after multiblock schemas stabilize |
| Motorboat/Speedboat | yes | yes | modern behavior/upgrades after core industry |
| Asphalt | yes | yes | preserve |
| Crude Oil/Diesel/Lubricant/Gasoline/Napalm | yes | yes | registry compatibility + modern semantics |
| Diesel Sulfur/Naphtha/Benzol/Petroleum Gas/Kerosene | no | yes | modern refining chain |
| Bitumen | yes | yes | preserve + Coker feed |
| Petcoke / Petcoke Dust / Block | no | yes | modern Coker chain |
| Paraffin Wax / Block | no | yes | modern material chain |
| Molotov / Gasoline Bottle | no | yes | late UX/content tier |
| Boat upgrades | older upgrade system | reinforced hull, icebreaker, tank, rudders, paddles | modern set after vehicle core |

## Verified current default refinery chain samples
- Distillation `oil`: 60 mB crude -> 15 mB naphtha + 20 mB kerosene + 30 mB sulfur diesel + 10 mB lubricant, energy 1024, plus 7% bitumen byproduct in the frozen 1.21.1 generated recipe.
- Coker `petcoke`: 2 bitumen + 125 mB water -> 2 petcoke + 27 mB sulfur diesel, energy 15360, time 30.
- Hydrotreater `sulfur_recovery`: 1000 mB sulfur diesel + 500 mB water -> 1000 mB diesel + 5 IE sulfur dust, energy 8000, time 100.

These values are source evidence, not yet declared final balance for Forbidden Series. Balance becomes immutable only after recipe/throughput simulation and server design review.

## Release tiers
1. **Industrial Foundation**: reservoirs, crude oil, Pumpjack, Distillation Tower, core output fluids/materials.
2. **Modern Refinery**: Coker, Hydrotreater, Derrick, Oil Tank, Seismic Survey, Well infrastructure, expanded fractions.
3. **Industrial Utility**: lubricant, gas generator, flarestack, projector, asphalt/material integrations.
4. **Mobility/Polish**: Motorboat + upgrades, Oil Can, gasoline bottle/Molotov, presentation/audio/advanced visuals.
