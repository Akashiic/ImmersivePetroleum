# Immersive Petroleum 1.7.10 — Backport Dossier (Forbidden Series)

**Português (principal):** [README.pt-BR.md](README.pt-BR.md)

> A technical-historical dossier of the **clean-room backport of ImmersivePetroleum to Minecraft 1.7.10 / Forge 10.13.4.1614** (for the *Forbidden Series* modpack), reconstructed from the project's git history, engineering documents, handoffs and on-disk state. This fork (`Akashiic/ImmersivePetroleum`) tracks the modern upstream (TwistedGate, 1.21.1/NeoForge); **upstream content is untouched** — everything here lives in `docs/backport-1.7.10/` on the `1.7.10-backport` branch. The long-form documents are written in Portuguese; this page summarizes them.

**Covered window:** 2026-09-09 → 2026-09-15 (38 commits, 11 tags `0.1.0-alpha.0…alpha.10`) · **Overall estimate:** ~67 % (range 61–74 %) · **Status:** lab-qualified development; **nothing validated on a production pack/world**.

## Start here

| I want… | Open |
|---|---|
| The full context (mission, architecture, per-family status, process, API traps) | [`CONTEXTO.md`](CONTEXTO.md) |
| When things happened (phases, day-by-day, tags, JAR hashes, progress %) | [`CRONOLOGIA.md`](CRONOLOGIA.md) |
| Diagrams (git lineage, Gantt, gates, quality loop, architecture, feature journey) | [`FLUXOGRAMAS.md`](FLUXOGRAMAS.md) |
| The JAR in use and where it really comes from | [`BUILD-EM-USO.md`](BUILD-EM-USO.md) |
| Where work stopped and how to resume (and what is stale) | [`ESTADO-ATUAL-E-RETOMADA.md`](ESTADO-ATUAL-E-RETOMADA.md) |
| Root causes, hypotheses, rejected evidence | [`HIPOTESES-E-INCIDENTES.md`](HIPOTESES-E-INCIDENTES.md) |
| Provenance, licensing, method and limits | [`PROVENIENCIA.md`](PROVENIENCIA.md) |
| Download the already-built **JARs** (pre-releases + SHA-256) | [`RELEASES.md`](RELEASES.md) |
| Raw data (TSV) | [`data/`](data/) |
| Verbatim original docs + SHA-256 index | [`archive/`](archive/) · [`archive/INDEX.md`](archive/INDEX.md) |

## The short version

- **Goal:** a premium, *clean-room* 1.7.10 reimplementation of the **modern** ImmersivePetroleum feature set (pressure-based reservoirs, Pumpjack, Derrick, Distillation Tower, Coker, Hydrotreater, Oil Tank, Seismic Survey, Gas Generator, Flarestack, Projector, Motorboat…), using architecture suited to Forge 1.7.10 rather than a blind port.
- **Runtime:** Forge 10.13.4.1614, Java 8 bytecode, custom IE 0.7.9, Angelica 2.2.8, GTNHLib 0.11.41; deployment target Crucible on Java 21.
- **Truth hierarchy:** real pack binaries → own source → TwistedGate 1.21.1 (frozen `e6cb01df…`, which is exactly this fork's `1.21.1` tip) → TwistedGate 1.12.2 → Flaxbeard legacy → Forge/IE docs → logs/tests → labeled inference.
- **Licensing:** upstream is *All Rights Reserved*, so it is **evidence only**; code and assets are original; the release gate (G11) is **blocked** on asset/license clearance.
- **Method:** 12 approval gates (G0–G11), saved evidence per campaign, multi-boot dedicated-server campaigns, Angelica client probes with inspected screenshots, "compiling ≠ correct".
- **Pace:** 11 alphas in ~3 days (Sep 9–12), then 26 qualification commits (Sep 13–15); tests 28 → 611; main code ≈1.3k → ≈39.9k lines.
- **Build in use:** JAR `…catalyst-refinery-20260915T1300.24+1ec598dd1c-dirty` (built 2026-09-15 18:25) = `1ec598d` + uncommitted Catalyst work — see [`BUILD-EM-USO.md`](BUILD-EM-USO.md).
- **Last commit:** `2c7b3f9` (2026-09-15 20:16 −03:00, Asphalt) — estimate **~67 %**.
- **Warnings:** the local `COMECE-AQUI-TRANSFERENCIA.md` and `README-CURRENT.md` describe **Sep 12** and are stale; the working checkout sits on a side-branch commit; the root repository has no commits and a non-existent `origin`. **The backport source code is not on GitHub** (only the JARs, as Releases).
- **Still open:** real-world upgrade, exact-pack compatibility, authenticated multiplayer, shaderpacks, soak/benchmarks, final art/audio, license resolution.

## Honest caveats

- I did **not re-run** the project; PASS verdicts and test counts are the project's own (evidence lives on the author's disk, outside this repo).
- The project itself states that implementation, review and approval were performed by the same assistant — **no independent external audit**.
- Some original documents contain mojibake; they are archived byte-for-byte.

*Generated on 2026-10-25 from the local project's git and disk state.*
