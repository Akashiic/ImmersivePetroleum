# Feature Matrix — Modern Target vs Bridge

Source freeze: TwistedGate 1.21.1 @ `e6cb01df...`; TwistedGate 1.12.2 @ `67005038...`.

| Family | 1.12.2 bridge | 1.21.1 target | Backport policy |
|---|---|---|---|
| Reservoirs | per-deposit/chunk cache | polygon/noise reservoirs + pressure | modern genesis + bounded sharded persistence, corruption fail-closed and deterministic recovery PASS in development lab; copied-world/pack qualification remains pending |
| Pumpjack | yes | yes | transactional extraction, reservoir taps/cache, redstone, covered-pipe safety, lubrication, 8 orientations and Angelica TESR PASS in development lab; copied-world/multiplayer/performance final pending |
| Distillation Tower | yes | yes | alpha.8 core/runtime PASS; alpha.9 renderer foundation PASS; final UX/art still planned |
| Derrick | no | yes | drilling/pressure, runtime, server container, directional grid editor and survival component acquisition PASS in the development lab; final presentation and pack/multiplayer qualification remain pending |
| Coker Unit | no | yes | modern processing expansion |
| Hydrotreater | no | yes | three-recipe modern processing, persistent paid contracts, outputs/recovery, lifecycle and Angelica GUI/TESR PASS in development lab; pack/multiplayer/performance final pending |
| Oil Tank multiblock | no | yes | modern storage, persistence, ports/equalization, lifecycle and Angelica renderer PASS in development lab; pack/multiplayer/performance final pending |
| Seismic Survey | no | yes | modern exploration UX |
| Well / Well Pipe | no | yes | modern reservoir infrastructure |
| Catalyst Refinery chemistry | IE Refinery base | catalyst-aware modern recipes | gasoline + redstone/constantan catalyst contracts, acetaldehyde fluid, strict IE17 transformer, restart and Angelica GUI PASS in development lab; pack/multiplayer/performance final pending |
| Auto Lubricator | yes | yes | preserve + audit IE handlers |
| Gas Generator | yes | yes | modern fuel/RF runtime, persistence, native wire/chunk-boundary audit and Angelica client PASS in development lab; final pack/perf/polish pending |
| Flarestack | no | yes | analog disposal, persistence/recovery, chunk-boundary safety and Angelica client PASS in development lab; final pack/perf/polish pending |
| Projector | yes | yes | port after multiblock schemas stabilize |
| Motorboat/Speedboat | yes | yes | modern fuel/physics/upgrades, two passengers, persistence/recovery, five semantic-gap fixes and Angelica/audio lifecycle PASS in development lab; pack/multiplayer/final art pending |
| Asphalt | yes | yes | 1.20x server-authoritative movement, four surface forms, config/removal semantics and Angelica/tooltips PASS in development lab; final art/pack/perf pending |
| Crude Oil/Diesel/Lubricant/Gasoline/Napalm | yes | yes | registry compatibility + modern semantics |
| Diesel Sulfur/Naphtha/Benzol/Petroleum Gas/Kerosene | no | yes | modern refining chain |
| Bitumen | yes | yes | preserve + Coker feed |
| Petcoke / Petcoke Dust / Block | no | yes | modern Coker chain |
| Paraffin Wax / Block | no | yes | modern material chain; wax/block + legacy target adaptations qualified in development lab |
| Petroleum Candle adaptation | no vanilla equivalent | modern wax -> vanilla candle use | original uncolored 1.7.10 candle, 1â€“4 metadata, ignite/extinguish/light/drop and Angelica renderer PASS in development lab |
| Ersatz Leather adaptation | no equivalent | IE ersatz leather wax use | explicit IP item + audited book/frame/armor/conveyor recipes PASS in development lab |
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
