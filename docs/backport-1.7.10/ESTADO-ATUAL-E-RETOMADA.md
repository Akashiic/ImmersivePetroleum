# Estado atual e guia de retomada

> Foto do disco local em **25/10/2026**, feita durante a investigação. Responde: *onde o trabalho realmente parou, o que está desatualizado, o que existe só localmente e por onde retomar.* Para o "porquê" e o histórico, veja [`CONTEXTO.md`](CONTEXTO.md) e [`CRONOLOGIA.md`](CRONOLOGIA.md).

## 1. Resumo executivo

- O trabalho real foi **mais longe do que qualquer documento de transferência diz**: o último commit é `2c7b3f9` (15/09/2026 20:16 −03:00, "Qualify Asphalt movement and client presentation"), com estimativa global **~67 %** (faixa 61–74 %). O `COMECE-AQUI-TRANSFERENCIA.md` e o `README-CURRENT.md` descrevem o checkpoint de **12/09** (`db6b77d`, 401 testes / 64 suítes) e a **alpha.10** — ficaram para trás por 26 commits, +210 testes e +36 suítes.
- O **checkout atual** do repositório de trabalho está num **commit de ramo lateral** (`42b568f`, ramo `feature/potion-id-integrity-20260913T184254Z`), **não** na ponta mainline.
- Existe **trabalho não commitado** em 3 worktrees (rascunhos que já foram superados, em sua maior parte, pelos commits da ponta). Não foi publicado nem apagado.
- O repositório na **raiz** da pasta do projeto tem `.git` próprio, **zero commits**, e `origin` apontando para `https://github.com/Akashiic/Immersive-Petroleum-1.7.10.git` — que **não existe** no GitHub.
- **Nenhum código do backport está no GitHub.** Este dossiê é a única parte publicada (no fork `Akashiic/ImmersivePetroleum`, branch `1.7.10-backport`).

## 1.1 Build em uso pelo autor

O autor usa o JAR `0.1.0-alpha.10-feature-catalyst-refinery-20260915T1300.24+1ec598dd1c-dirty` (SHA-256 `d5065d03…2c72c`) e o considera o ponto mais recente trabalhado. Análise ([`BUILD-EM-USO.md`](BUILD-EM-USO.md)): é `1ec598d` + rascunho **não commitado** do Catalyst Refinery, construído em 15/09 18:25 — **17 min antes** do commit `9879cdc` e **sem** o Asphalt de `2c7b3f9`. **Nenhum commit reproduz esse JAR**; a única fonte é o worktree sujo `ImmersivePetroleum-catalyst-20260915T1700` — **não o apague**. Para continuar o desenvolvimento, parta de `2c7b3f9` (superconjunto commitado e qualificado).

## 2. Mapa de pastas (Windows)

Raiz: `C:\Users\User\Desktop\Codex\immersivepetroleum-backport`

| Pasta | Conteúdo |
|---|---|
| `work/ImmersivePetroleum-1.7.10` | Repositório git de trabalho (38 commits, 11 tags, 37 branches) + worktrees irmãs |
| `dist/` | Pastas `0.1.0-alpha.2` … `alpha.10` com JAR, `SHA256SUMS`, docs; `immersivepetroleum-0.1.0-alpha.10-package.zip(.sha256)` |
| `engineering-handoff/20260912T200922Z` | Pacote de transferência de 12/09 (manifesto `HANDOFF_NOT_RELEASE`, bundle git, `source-code.zip`, refs upstream; ZIP 99.434.467 B, 1.732 entradas; restauração verificada) |
| `engineering-handoff-validation/` | Validação da restauração do handoff |
| `evidence/` | Evidência de gates (`g3…g5c…`), `upstream-revisions.json`, `runtime-mods-baseline.json` (161 JARs; UTF-8 com BOM → ler com `utf-8-sig`) |
| `project-docs/` | Cópia de documentos do projeto; `README-CURRENT.md` (**desatualizado**) |
| `tools/` | `reservoir_domain_sim.py` (e outros utilitários da raiz) |
| `upstream/` | Clones congelados do upstream (somente referência) |
| `artifacts/` | Vazia |
| `COMECE-AQUI-TRANSFERENCIA.md` | Índice do handoff de 12/09 (**desatualizado**) |

## 3. Branches, tags e worktrees

### 3.1 Linha principal e tags
Linha **linear**: `master` (alpha.0, `fd97d51`) → … → `2c7b3f9`. As 11 tags `0.1.0-alpha.0…alpha.10` são anotadas e estão todas no trecho 09–12/09. **Não há tags depois da alpha.10** — as versões entre 13 e 15/09 são identificadas apenas por commit/branch (e por *digests* nos documentos). Tabelas completas: [`data/tags.tsv`](data/tags.tsv), [`data/branches.tsv`](data/branches.tsv).

Pontas relevantes: `feature/asphalt-qualification-20260915T1840` e `feature/lubrication-qualification-20260915T2015` apontam para `2c7b3f9` (a ponta). `feature/catalyst-refinery-20260915T1300` está em `9879cdc`. `feature/extraction-journey-20260915T1200`, `feature/material-chain-qualification-20260915T0150` e `feature/catalyst-refinery-isolated-20260915T1700` apontam para `1ec598d` (a jornada de extração **não tem commit próprio**).

### 3.2 Ramo lateral
`42b568f` ("Repair pinned IE potion IDs…", 14/09 14:06), pai `2aed5b5`, foi **reaplicado** na linha principal como `a4182f9` (14:32). O diretório de trabalho principal ficou parado em `42b568f`.

### 3.3 Worktrees e trabalho não commitado

| Worktree (nome da pasta) | HEAD real | Estado | Observação |
|---|---|---|---|
| `ImmersivePetroleum-catalyst-20260915T1700` | `1ec598d` | ⚠ **fonte do JAR em uso** — **10 arquivos modificados + novos** (inclui `PetroleumRefineryTransformer`, sondas/testes/tool de CatalystRefinery) | Rascunho anterior ao commit `9879cdc`; a maioria dos arquivos **difere** da ponta. `ImmersivePetroleum.java`, `PetroleumDrillCorePlugin.java`, `PetroleumFluids.java`, `BlockPetroleumFluid.java` e `PetroleumFluidSpecTest.java` são **idênticos** à ponta (comparados por hash). |
| `ImmersivePetroleum-molotov-20260914T033810Z` | `fbcb919` | `MolotovProbe.java` + `run-molotov-campaign.ps1` não commitados | Diferem da ponta; superados pelo commit `5bd89e5`/`a4182f9` |
| `ImmersivePetroleum-nei-20260913T190723Z` | **`2c7b3f9`** (a ponta) | limpo | **Nome enganoso** — é a melhor cópia para trabalhar |
| `ImmersivePetroleum-pumpjack-final-20260915T1421Z` | `0b7ac71` | 8 arquivos de sondas/scripts não commitados | 7 dos 8 são idênticos à ponta; `run-premium-client-probe.ps1` difere |

> Resultado da comparação por hash: **o WIP não commitado é, em essência, rascunho já substituído pelos commits da ponta**, mas não foi reconciliado arquivo a arquivo. **Antes de apagar qualquer worktree**, faça `git diff` por arquivo contra `2c7b3f9`.

## 4. Documentos desatualizados (e o que dizem de errado)

| Documento | Diz | Realidade (git) |
|---|---|---|
| `COMECE-AQUI-TRANSFERENCIA.md` | Checkpoint `db6b77d`, 401 testes / 64 suítes | Ponta `2c7b3f9`, 611 / 100 |
| `project-docs/README-CURRENT.md` | Última versão: alpha.10 | Mainline ~26 commits à frente; sem tag |
| `docs/FEATURE-MATRIX.md` (ponta) | Várias linhas ainda "port after…" / sem atualização (Auto Lubricator, Coker, Molotov, DT) | Famílias já qualificadas em laboratório |
| `docs/ROADMAP.md` (ponta, cabeçalho de G7/G8) | G7/G8 "PLANNED" | Qualificadas em laboratório até 15/09 |
| Diretório de trabalho (`HEAD`) | — | Parado em `42b568f` |

O **documento mais confiável do estado** é `docs/TOTAL-PROGRESS.md` no commit `2c7b3f9` (atualizado a cada checkpoint) junto com os documentos `*-QUALIFICATION-2026-09-1x.md`.

## 5. Como retomar (receita)

0. **Preservar o worktree sujo do Catalyst e o JAR em uso** (ver §1.1): `git diff > catalyst-wip.patch`, cópia da pasta, hash do JAR.
1. **Escolher a base.** Trabalhar a partir de `2c7b3f9` (ex.: worktree `…-nei-20260913T190723Z`, ou `git switch -c retomada 2c7b3f9`). Não retomar do checkout atual (`42b568f`).
2. **Ler** `docs/TOTAL-PROGRESS.md`, `docs/HANDOFF-RESUME-PROMPT.md` (se existir no commit) e os docs de qualificação de 09-15 (Asphalt, Catalyst, Material chain).
3. **Validar o ambiente:** JDK 1.8.0_504 para build, Gradle/RFG, os JARs de desenvolvimento listados em [`CONTEXTO.md` §2](CONTEXTO.md#2-alvo-de-runtime-e-dependências) (conferir SHA-256 do IE `51cf081e…`).
4. **Repetir a regressão antes de qualquer mudança:** suíte JUnit (esperado 611 testes / 100 suítes) e uma campanha curta de servidor dedicado, sempre com o **mutex global** e `tools/guarded_task.py`. Julgar por marcadores PASS — **não** pelo exit code do Gradle.
5. **Reconciliar os 3 worktrees sujos** (§3.3) por `git diff`; arquivar o que for útil como patch.
6. **Criar tags** para os checkpoints 13–15/09 (hoje só existem até alpha.10) — sugestão: usar os commits da tabela de [`CRONOLOGIA.md`](CRONOLOGIA.md).
7. **Decidir o destino do código** (§7): criar o repositório `Akashiic/Immersive-Petroleum-1.7.10` (ou outro nome) e ajustar o `origin`.

## 6. Lacunas em aberto (priorizadas)

**Bloqueantes para qualquer release:**
1. **G11 / licença e assets** — upstream *All Rights Reserved*; produzir assets clean-room ou obter autorização.
2. **G2 — upgrade de mundo real:** copiar um mundo de produção e verificar carga sem remap de registro.
3. **G9 — matriz de compatibilidade** no pack exato (161 JARs): EnderIO, BuildCraft, Thermal, Mekanism, MFR, NEI, CraftTweaker, Angelica, GTNHLib e integrações do IE; opcionais devem ser testáveis na ausência.
4. **G10 — performance/soak/corrupção:** 1/16/64/256 máquinas, reservatórios cheios/depletados, multiblocos em borda de chunk, unload/reload repetido, NBT malformado, contadores de conservação de longa duração.
5. **Crucible + Java 21 + cópia real do pack** (alvo declarado pelo usuário).
6. **Multiplayer remoto autenticado**, shaderpacks ativos, benchmarks.

**Qualidade de conteúdo:**
7. Arte, modelos, texturas e áudio **finais e originais**; escuta humana do áudio; UX final da torre (G5C2).
8. **Jornada de sobrevivência** sem fixtures (Seismic → Derrick → Pumpjack → Oil Tank); `feature/extraction-journey-20260915T1200` ainda sem commit próprio.
9. Coker: ingredientes com **NBT / curingas / OreDict**; balanceamento final (valores atuais são evidência-fonte, não balanceamento aprovado).
10. FEATURE-MATRIX/ROADMAP desatualizados; sem registro de qualificação do **Oil Can**.
11. Causa-raiz do **cliente NEI preso no menu** nunca determinada (ver [`HIPOTESES-E-INCIDENTES.md`](HIPOTESES-E-INCIDENTES.md)).

**Higiene de repositório:**
12. Tags pós-alpha.10; diretório de trabalho fora da ponta; `.git` da raiz sem commits e `origin` inexistente; nomes de worktree enganosos.

## 7. O que foi (e não foi) publicado no GitHub

| Item | Situação |
|---|---|
| Fork `Akashiic/ImmersivePetroleum` (de `TwistedGate/ImmersivePetroleum`) | **Criado.** Branch padrão continua `1.21.1`, intocada |
| Este dossiê | **Publicado** no branch `1.7.10-backport` do fork, pasta `docs/backport-1.7.10/` |
| JARs já construídos (alpha.2–10 + build em uso `-dirty`) | **Publicados como pre-releases** do fork em 25/10/2026 — ver [`RELEASES.md`](RELEASES.md). As tags `1.7.10-0.1.0-alpha.N` apontam para o commit do dossiê, não para o commit-fonte |
| Código-fonte do backport, histórico git, tags do projeto, ZIP de handoff, logs | **Não publicados.** Decisão deliberada: o fork é de um projeto *All Rights Reserved*; publicar o código-fonte de um backport clean-room exige decisão do autor sobre repositório, licença e visibilidade |
| Repositório `Akashiic/Immersive-Petroleum-1.7.10` | **Não existe** (o `origin` local aponta para ele) |

Se o autor quiser publicar o código: criar o repositório (privado primeiro), `git remote set-url origin …`, enviar `master` e as 11 tags; o histórico de 38 commits é praticamente linear (um único commit em ramo lateral). O ZIP de handoff (~95 MiB) e os JARs não devem entrar no git — os JARs já estão em *Releases* ([`RELEASES.md`](RELEASES.md); hashes em [`data/release-jars.tsv`](data/release-jars.tsv)).

## 8. Comandos úteis (PowerShell)

```powershell
cd C:\Users\User\Desktop\Codex\immersivepetroleum-backport\work\ImmersivePetroleum-1.7.10
git log --oneline --graph --decorate --all | Select-Object -First 60
git worktree list
git status -sb
git diff --stat 2c7b3f9      # o que o checkout atual (42b568f) tem de diferente da ponta
git tag -l "0.1.0-alpha.*"
```
