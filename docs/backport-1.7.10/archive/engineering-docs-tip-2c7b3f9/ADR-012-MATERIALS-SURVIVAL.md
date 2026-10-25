# Materials, construction and survival integration

Status: implemented for development validation; not a release approval.

## Primary references

The modern oracle is the local frozen Immersive Petroleum 1.21.1 tree at
`e6cb01df32d4adfd096d49c02bb91e60fef56a15`: `common/blocks/stone/AsphaltBlock.java`,
`ParaffinWaxBlock.java`, `IPContent.java`, and generated `recipe/arcfurnace/steel.json`,
`recipe/squeezer/graphite_dust.json`, `recipe/refinery/gasoline.json` and material crafting JSON.
The compatibility oracle is the pinned IE 0.7.9 JAR in `libs`, inspected with `javap -c -p`.
Minecraft/Forge signatures were checked against `build/rfg/minecraft-src/java`.

## Available paths

* Petcoke and its dust, paraffin wax, sulfur fallback, asphalt blocks/slabs/stairs,
  compressed petcoke/wax blocks, and their native crafting/fuel registrations.
* Crusher: one petcoke -> one dust; one block -> nine dust, at the modern base energy values.
* Arc furnace: iron + petcoke dust -> steel + slag, 400 ticks at 512 RF/t before IE configuration.
* Native IE squeezer: eight petcoke dust -> one HOP graphite dust.
* Native IE refinery: 15 mB naphtha + 10 mB benzol -> 25 mB gasoline.
* Dry concrete bucket: four sand + two gravel + two clay balls + empty bucket;
  native IE bottler adds 1,000 mB water to make 1,000 mB concrete.
  Derrick accepts only the exact required quantity and keeps the remaining fluid in the bucket.

Sulfur is registered under `dustSulfur` because the pinned IE JAR lacks its own sulfur item.
Petcoke and wax compression gives nine items back. The block fuel times are ten times the
single-item times, matching the intentional modern fuel values rather than a conservation rule.

## Explicit compatibility decisions

Legacy IE has no MixerRecipe API. Concrete uses its actual bottler instead. Two modern
500 mB mixer batches supply the material and water denominator; bottler energy/timing follows
legacy IE and is not asserted equal to the modern mixer.

`DieselHandler.addSqueezerRecipe` takes processing **time**, not RF. The native IE graphite
recipe uses 240 ticks for eight coke dust, so the petroleum counterpart uses 240 ticks as well.
The legacy squeezer's configuration and batching govern consumption (default 10 RF/t and
multiple simultaneous inputs). This does not reproduce the modern 19,200 RF per recipe.
The refinery likewise has no per-recipe RF parameter; quantities match while energy follows IE.
No global IE settings or unrelated recipes are changed to conceal these differences.

Minecraft 1.7 has no block `speedFactor`. Asphalt uses one unsaved, server-owned operation-2
movement attribute modifier (+20%); wax uses -5% plus native `slipperiness=1.05`.
The modifier applies while grounded, is removed after leaving, and uses vanilla attribute
synchronization. Four asphalt shapes are recognized using the entity's feet height, including
bottom slabs. UUID replacement prevents stacking; stable ticks create no new modifier objects.
This preserves the intended movement benefit but is not a claim of identical modern transient
physics or zero network delay on entering/leaving a surface. Config `miscellaneous.asphaltSpeed`
disables the asphalt modifier without removing blocks or saved data. No chunk is loaded by this hook.

The concrete container rejects negative transfers, malformed/out-of-range saved amounts,
foreign fluids and illegal stacked containers. Forge 1.7's two-argument item-container
constructor is required: its one-argument constructor retains an ignored item ID and zero capacity.
Partial buckets deliberately use IFluidContainerItem, not a static full-bucket registry match.

## Validation and remaining scope

The opt-in fresh-world `PetroleumMaterialProbe` checks four road forms, repeated updates,
config disable, wax and leaving surfaces, arc/refinery recipe registration, and the actual IE
squeezer tile consuming eight dust while refusing to produce graphite from seven.
`ConcreteSurvivalProbe` checks crafting/bottling recipe admission, exact partial pour, retained
remainder, distance and duplicate rejection. A recipe lookup is not a physical bottler simulation.
Passing markers must be present in retained campaign logs before claiming these gates passed.

Current presentation uses legacy atlas references and tints. Original final art, player-facing
manual/recipe browsing, multiplayer movement measurements, the physical bottler and broad pack
qualification remain separate open gates. Modern wax integrations with post-1.7 vanilla copper
and candles require a compatible target content provider; none is claimed by these registrations.

## Qualification update — 2026-09-15

The previously open legacy paraffin-content work is now implemented and qualified in the development lab. Petroleum Candle is a code-native, uncolored metadata block with counts 1–4, three light levels per candle, ignite/extinguish, exact drops and no TileEntity. Ersatz Leather is a new IP item produced from eight IE hemp fabric plus paraffin wax; explicit audited recipes cover books, item frames, four vanilla armor pieces and the IE conveyor.

Concrete validation now includes the physical pinned-IE Bottling Machine rather than recipe lookup alone. The native fixture converted a dry concrete bucket with 1,000 mB water into 1,000 mB concrete, while Derrick partial transfer retained the unconsumed 750 mB after a 250 mB pour.

Native Forge placement is also no longer pending for the shared helper. Auto Lubricator, Gas Generator and Flarestack were rerun after the stackable/metadata placement changes and each emitted `OWNED_ITEM_PLACEMENT_PASS ... cases=6` on the final source digest.

Final evidence and explicit limits are in `MATERIAL-CHAIN-QUALIFICATION-2026-09-15.md`. The chemistry proposal for catalyst-dependent phenol/acetaldehyde remains open and is not implied by this qualification.
