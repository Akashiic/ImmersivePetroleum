# Immersive Petroleum 1.7.10 — Dossiê do Backport (Forbidden Series)

**English:** [README.md](README.md)

> Dossiê técnico-histórico do **backport clean-room do ImmersivePetroleum para Minecraft 1.7.10 / Forge 10.13.4.1614** (modpack *Forbidden Series*), reconstruído a partir do git, dos documentos de engenharia, dos handoffs e do estado em disco do projeto local. Este fork (`Akashiic/ImmersivePetroleum`) é do upstream moderno (TwistedGate, 1.21.1/NeoForge); **o conteúdo do upstream está intocado** — este dossiê vive só em `docs/backport-1.7.10/` do branch `1.7.10-backport`.

**Janela coberta:** 2026-09-09 → 2026-09-15 (38 commits, 11 tags `0.1.0-alpha.0…alpha.10`) · **Estimativa global:** ~67 % (faixa 61–74 %) · **Estado:** desenvolvimento em laboratório; **nada homologado em pack/mundo de produção**.

## Comece aqui

| Quero… | Abra |
|---|---|
| Entender **tudo** (missão, arquitetura, estado por família, processo, armadilhas) | [`CONTEXTO.md`](CONTEXTO.md) |
| Ver **quando** cada coisa aconteceu (fases, dia a dia, tags, JARs, % de progresso) | [`CRONOLOGIA.md`](CRONOLOGIA.md) |
| Ver os **diagramas** (git, Gantt, gates, ciclo de qualidade, arquitetura, jornada) | [`FLUXOGRAMAS.md`](FLUXOGRAMAS.md) |
| O **JAR em uso** e de onde ele realmente vem | [`BUILD-EM-USO.md`](BUILD-EM-USO.md) |
| Saber **onde parou e como retomar** (e o que está desatualizado) | [`ESTADO-ATUAL-E-RETOMADA.md`](ESTADO-ATUAL-E-RETOMADA.md) |
| Ler as **causas-raiz, hipóteses e evidências rejeitadas** | [`HIPOTESES-E-INCIDENTES.md`](HIPOTESES-E-INCIDENTES.md) |
| Saber **de onde vem cada fato**, licença e limites da investigação | [`PROVENIENCIA.md`](PROVENIENCIA.md) |
| Baixar os **JARs** já construídos (pre-releases + SHA-256) | [`RELEASES.md`](RELEASES.md) |
| Dados brutos (TSV) | [`data/`](data/) |
| Documentos originais **verbatim** + índice com SHA-256 | [`archive/`](archive/) · [`archive/INDEX.md`](archive/INDEX.md) |

## Em 10 linhas

1. **Missão:** backport premium e *clean-room* do conjunto **moderno** do ImmersivePetroleum (reservatórios por pressão, Pumpjack, Derrick, Distillation Tower, Coker, Hydrotreater, Oil Tank, Seismic, Gas Generator, Flarestack, Projector, Motorboat…) para 1.7.10, com arquitetura apropriada ao Forge 1.7.10.
2. **Runtime:** Forge 10.13.4.1614, Java 8 bytecode, IE 0.7.9 customizado, Angelica 2.2.8, GTNHLib 0.11.41; servidor-alvo Crucible + Java 21.
3. **Fontes de verdade (em ordem):** binários reais do pack → código próprio → TwistedGate 1.21.1 (congelado `e6cb01df…`) → TwistedGate 1.12.2 → Flaxbeard legado → docs de Forge/IE → logs/testes → inferência rotulada.
4. **Licença:** upstream *All Rights Reserved* ⇒ **só evidência**; código/assets são originais; G11 (release) **bloqueado** pelo gate de assets/licença.
5. **Método:** 12 portões (G0–G11), evidência salva por campanha, **multi-boot em servidor dedicado**, cliente Angelica com screenshot inspecionado, regra "compilar ≠ correto".
6. **Ritmo real:** 11 alphas em ~3 dias (09–12/09), depois 26 commits de qualificação em 13–15/09; testes 28 → 611, código main ~1,3 mil → ~39,9 mil linhas.
7. **Build em uso:** JAR `…catalyst-refinery-20260915T1300.24+1ec598dd1c-dirty` (15/09 18:25) = `1ec598d` + Catalyst não commitado — ver [`BUILD-EM-USO.md`](BUILD-EM-USO.md). **Último commit:** `2c7b3f9` (15/09 20:16 −03, Asphalt). Estimativa **~67 %**.
8. **Alerta:** `COMECE-AQUI-TRANSFERENCIA.md` e `README-CURRENT.md` do projeto local descrevem **12/09** e estão **defasados**; o checkout de trabalho está em um commit de ramo lateral.
9. **Só local:** o repositório da raiz tem `.git` sem commits e `origin` inexistente (`Akashiic/Immersive-Petroleum-1.7.10`); **o código-fonte do backport não está no GitHub** (só os JARs, em Releases).
10. **Falta:** mundo real, pack exato, multiplayer autenticado, shaders, soak/benchmarks, arte/áudio finais, resolução de licença.

## Estrutura

```text
docs/backport-1.7.10/
├── README.md · README.pt-BR.md
├── CONTEXTO.md                    ← o contexto sólido
├── CRONOLOGIA.md                  ← versões e progressão
├── FLUXOGRAMAS.md                 ← 10 diagramas Mermaid
├── BUILD-EM-USO.md                ← JAR do autor: identidade e origem
├── ESTADO-ATUAL-E-RETOMADA.md     ← onde parou / como retomar
├── HIPOTESES-E-INCIDENTES.md      ← causas-raiz, teorias, rejeitados
├── PROVENIENCIA.md                ← fontes, licença, método, limites
├── diagrams/                      ← .mmd + .svg de cada diagrama
├── data/                          ← commits, tags, branches, JARs, % de progresso, histórico de docs (TSV)
└── archive/                       ← cópias verbatim (85 docs de engenharia + handoff + project-docs + SHA256SUMS)
```

## Observações honestas

- **Nada foi reexecutado** por mim; os veredictos PASS e as contagens de testes são os do próprio projeto (evidência no disco do autor, fora deste repositório).
- O projeto declara que **implementação, revisão e aprovação foram feitas pelo mesmo assistente** — não há auditoria externa independente.
- Documentos originais têm trechos com acentuação corrompida; foram preservados byte a byte.

*Gerado em 25/10/2026 a partir do estado do disco e do git do projeto local.*
