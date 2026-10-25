# ADR-003 - Forge 1.7.10 Fluid Registry and Collision Policy

Status: ACCEPTED for G4A
Date: 2026-09-10

## Context
The frozen 1.21.1 Petroleum line exposes ten process fluids, while Forge 1.7.10 uses a global fluid-name registry. Reservoir records persist modern namespaced fluid ids such as `immersivepetroleum:crudeoil`, but `FluidStack` NBT and runtime lookups resolve the global name `crudeoil`.

Forge 10.13.4.1614 `FluidRegistry.registerFluid()` always records a registered candidate in `masterFluidReference` under `<activeModId>:<fluidName>`, even when another mod already owns the global default name. This allows Petroleum to preserve provenance without demanding global ownership.

## Decision
Petroleum registers its own candidate for every modern Petroleum fluid while the active FML mod container is `immersivepetroleum`. Every candidate must resolve through `FluidRegistry.getDefaultFluidName(candidate)` to `immersivepetroleum:<name>`.

Gameplay stacks do **not** assume the candidate's `RegistryDelegate` has already rebound. `ReservoirFluidBinding` resolves `FluidRegistry.getFluid(name)` at operation time and constructs `FluidStack` from that effective global default.

## Collision semantics
If Petroleum owns the global default, binding status is `OWN_DEFAULT`. If another mod owns the same global name, Petroleum's candidate remains registered/provenanced but binding status is `DELEGATED_DEFAULT`, and produced stacks use the other mod's default instance. External canonical ids such as `minecraft:water` and `minecraft:lava` are validated against the default owner's unique id when possible.

This avoids duplicate incompatible process fluids while preserving Forge's world-persistent default-selection mechanism. A foreign default is not silently replaced merely because Petroleum loads later.

## Rendering boundary
G4A registers logical fluids only. It does not register placeable Petroleum fluid blocks and does not copy upstream textures. `PetroleumFluid` retains density/viscosity and modern presentation metadata; its icon getters fall back to Forge's vanilla WATER icons after texture stitching and apply project-owned tint values.

## Rejected approach
The first collision prototype created gameplay stacks from Petroleum's alternative candidate and assumed its `FluidDelegate` would already point at the current global default. A dedicated fixture that registered `crudeoil` first disproved that assumption: the candidate stack still resolved to the candidate. The approach was REJECTED and replaced with direct effective-default lookup.

JUnit tests that initialized `FluidRegistry` outside Forge bootstrap were also rejected because `Blocks.water` is not initialized in a plain test worker. Registry behavior is therefore verified by dedicated-server probes; pure JUnit remains responsible for static specifications and canonical-id logic.
