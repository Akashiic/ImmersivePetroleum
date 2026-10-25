# Contexto sólido — Immersive Petroleum 1.7.10 (Forbidden Backport)

> **O que é este documento.** O dossiê de contexto do que foi construído até 15/09/2026 no backport do ImmersivePetroleum para Minecraft 1.7.10, reconstruído a partir de: histórico git (38 commits), 85 documentos de engenharia, 3 handoffs, evidências de campanhas de runtime, manifestos e 4 worktrees. Cada afirmação factual aponta para uma fonte em [`archive/`](archive/) ou em [`data/`](data/). Onde algo é inferência minha, está marcado como **[inferência]**.
>
> Leia junto com: [`CRONOLOGIA.md`](CRONOLOGIA.md) · [`FLUXOGRAMAS.md`](FLUXOGRAMAS.md) · [`ESTADO-ATUAL-E-RETOMADA.md`](ESTADO-ATUAL-E-RETOMADA.md) · [`HIPOTESES-E-INCIDENTES.md`](HIPOTESES-E-INCIDENTES.md) · [`PROVENIENCIA.md`](PROVENIENCIA.md).

> **Build em uso pelo autor:** `0.1.0-alpha.10-feature-catalyst-refinery-20260915T1300.24+1ec598dd1c-dirty` (SHA-256 `d5065d03…2c72c`) = `1ec598d` + Catalyst Refinery não commitado, construído em 15/09 18:25. É o artefato mais recente em uso; o código commitado mais recente é `2c7b3f9`. Ver [`BUILD-EM-USO.md`](BUILD-EM-USO.md).

## Índice

1. [Missão e escopo](#1-missão-e-escopo)
2. [Alvo de runtime e dependências](#2-alvo-de-runtime-e-dependências)
3. [Fontes de verdade e licenciamento](#3-fontes-de-verdade-e-licenciamento)
4. [Princípios de engenharia e Definition of Done](#4-princípios-de-engenharia-e-definition-of-done)
5. [Arquitetura](#5-arquitetura)
6. [Estado por família de funcionalidade](#6-estado-por-família-de-funcionalidade)
7. [Como o trabalho foi conduzido (processo e infraestrutura de qualidade)](#7-como-o-trabalho-foi-conduzido)
8. [Armadilhas de API de 1.7.10 já documentadas](#8-armadilhas-de-api-do-1710-já-documentadas)
9. [O que ainda não está provado](#9-o-que-ainda-não-está-provado)
10. [Glossário](#10-glossário)

---

## 1. Missão e escopo

**Projeto:** "Immersive Petroleum – Forbidden Backport". `modId = immersivepetroleum`, grupo Java `flaxbeard.immersivepetroleum`.

**Missão (carta de 09/09/2026):** construir uma reimplementação/backport **premium e de alta fidelidade** do Immersive Petroleum para o runtime **Forbidden Series** (modpack 1.7.10), preservando a identidade industrial e o conjunto de funcionalidades **modernas** do mod (a versão 1.21.1 de TwistedGate), usando arquitetura apropriada para Forge 1.7.10 em vez de transplantar cegamente código NeoForge. Nas palavras da carta: o alvo não é "fazer rodar"; é um addon de nível de produção, com multiblocos de aparência moderna, simulação determinística, dados de mundo seguros, fluidos/energia corretos, sincronização multiplayer robusta, renderização consciente do Angelica e orçamentos de desempenho explícitos.

**Natureza do código:** reimplementação **clean-room**. Código e assets são escritos do zero; o upstream serve só de **evidência de comportamento** (ver §3). Nenhum modelo, textura ou som do upstream é copiado.

**Papéis na carta:** "Chief Engineer + Auditor + Approver" — a documentação registra que o mesmo assistente de IA implementou, revisou e aprovou; **não existe auditoria externa independente**, e os documentos do projeto dizem isso explicitamente.

**O que é o "nosso fork" no GitHub vs. o projeto local.** O repositório `Akashiic/ImmersivePetroleum` é um fork do upstream moderno (1.21.1, NeoForge) — é onde este dossiê está publicado. O **código do backport 1.7.10 não está nesse fork**: vive em `C:\Users\User\Desktop\Codex\immersivepetroleum-backport\work\ImmersivePetroleum-1.7.10` (ver §6 de `ESTADO-ATUAL-E-RETOMADA.md`).

## 2. Alvo de runtime e dependências

| Item | Valor |
|---|---|
| Minecraft / Forge | 1.7.10 / 10.13.4.1614 |
| Bytecode | Java 8 (class file major **52**, verificado no G1) |
| Toolchain | RetroFuturaGradle, mapeamentos `stable_12`; JDK de desenvolvimento 1.8.0_504 |
| Servidor-alvo | **Crucible 1.7.10 com Java 21** (confirmado pelo usuário; documentado no commit `6339c71`, 13/09) |
| Immersive Engineering (dev) | `ImmersiveEngineering-garden-cloche-test-2.jar` (IE 0.7.9 customizado) — SHA-256 `51cf081e5a7c9e92dc9ede65021ba2befbdd17971a070d7f26f8c83839c4ac2e` |
| Bibliotecas de dev | GTNHLib 0.11.41 · Angelica 2.2.8 · UniMixins 0.3.1 · Hodgepodge 2.7.189 (referência) |
| Opcionais (compileOnly) | NEI 2.8.125-GTNH · CraftTweaker 3.4.8 |
| Coremod | `common.compat.drilloil.asm.PetroleumDrillCorePlugin` — transformers ASM: *drill-oil*, *potion-ID*, *refinery/catalyst* |
| Inventário do pack real | `evidence/runtime-mods-baseline.json`: 161 JARs, 161 hashes, 0 nulos ([`archive/evidence-index/`](archive/evidence-index/)) |

Regras do runtime: nunca modificar JARs de produção do modpack; o Petroleum é addon **separado** (não polui o núcleo do IE sem deficiência de API comprovada); registros do IE e compatibilidade de mundo são preservados.

## 3. Fontes de verdade e licenciamento

### 3.1 Hierarquia (carta, `PROJECT-CHARTER.md`)

1. Binários reais do runtime Forbidden Series e comportamento observado.
2. Código próprio do backport do IE 1.7.10 e artefato construído.
3. TwistedGate **ImmersivePetroleum 1.21.1** — semântica/funcionalidades atuais — congelado em `e6cb01df32d4adfd096d49c02bb91e60fef56a15`.
4. TwistedGate **1.12.2** — ponte de migração — `670050389c777e47e8beda18bf41cb6e819b66d4`.
5. **Flaxbeard** (legado) `master` — arqueologia de comportamento histórico — `dce4c3b8d2b59d30357a006cf1a5fd1640e61a30`.
6. Documentação/código exato de Forge, IE e GTNHLib.
7. Logs, profiling e testes reprodutíveis.
8. Inferência — apenas rotulada e com plano de validação.

O manifesto do handoff ainda registra a referência do IE 1.21.1 (`75a27f03e4243544243567e8d5c38d336f4f10f4`). Diagrama: [`FLUXOGRAMAS.md` §6](FLUXOGRAMAS.md#6-hierarquia-de-fontes-de-verdade).

### 3.2 Licença e assets

- O upstream não expõe arquivo de licença na raiz e a distribuição no CurseForge está marcada **All Rights Reserved**.
- Portanto o código/assets do upstream são **apenas evidência**. Publicar pacote com modelos/texturas copiados está **bloqueado** por um *gate de licença* dedicado; o caminho permitido é **clean-room / assets recriados**.
- Consequência registrada no `ROADMAP.md`: **G11 (release candidate) está BLOQUEADO** até a liberação de assets/licença ou assets limpos.
- Este dossiê publica **somente documentação própria** (texto escrito pelo projeto) e metadados — nenhum código-fonte do mod, JAR ou asset do upstream. Ver [`PROVENIENCIA.md`](PROVENIENCIA.md).

## 4. Princípios de engenharia e Definition of Done

### 4.1 Restrições inegociáveis (carta)

- IDs/nomes estáveis e política de migração para todo bloco/item/TileEntity antes do release.
- Carregamento de classes em servidor dedicado é **gate obrigatório**: classes de renderer de cliente nunca vazam para o servidor.
- Geração de reservatórios **determinística, limitada, persistente e ciente de dimensão**.
- Mutações de fluido/energia **transacionais** (sem duplicação/perda em falha parcial).
- Multiblocos idempotentes em quebra/reforma/descarga de chunk.
- Estado de renderização balanceado, testado com Angelica ligado; sem dependência oculta de OptiFine.
- Sem spam de log por tick, alocações ilimitadas, varreduras ilimitadas ou I/O síncrono em caminhos de tick.
- Integrações opcionais falham de forma suave, isoladas por adaptadores.
- **Cada família de máquina tem kill-switch de configuração.**

### 4.2 Definition of Done (resumo)

Uma funcionalidade só é APROVADA quando todos os itens aplicáveis passam: proveniência e semântica-alvo registradas; build limpo + artefato reobfuscado; cliente e servidor dedicado carregam; mundo-base do IE carrega sem remap; novo mundo funciona; forma/quebra/reforma de multibloco; persistência após descarga de chunk e restart; conservação de fluido/energia; **sincronização de rede não confia em estado inválido do cliente**; integração NEI/manual sem crash; smoke Angelica ON/OFF onde aplicável; orçamento de desempenho medido ou limitado analiticamente; caminhos de falha sem dupe, void ou multibloco-fantasma; defaults de configuração e notas de migração; **PASS/FAIL do auditor com evidência**.

### 4.3 Filosofia de aprovação

- *Compilar é evidência de sintaxe, não de correção.*
- Subsistema com corrupção de save, duplicação, vazamento de classe de servidor, vazamento de estado GL ou custo de tick ilimitado é **REJEITADO** mesmo que "funcione" visualmente.
- Gate reprovado volta **à menor camada responsável**; reescritas não relacionadas são proibidas.
- Nenhuma linha pode passar de BLOCKED/FAIL para PASS "por inspeção visual" quando persistência, conservação, rede ou classloading de servidor se aplicam.
- Evidência rejeitada é **preservada**, nunca apagada; asserções nunca são enfraquecidas para passar.
- O percentual de progresso **nunca** é derivado do número de testes; estimativas usam denominador fixo ponderado (infra 20 % · extração/refino/armazenagem 35 % · exploração/utilidades 15 % · mobilidade 10 % · apresentação 10 % · homologação 10 %).

## 5. Arquitetura

Resumo de `ARCHITECTURE.md` (diagrama em [`FLUXOGRAMAS.md` §7](FLUXOGRAMAS.md#7-arquitetura-em-camadas)).

### 5.1 Módulos

| Pacote | Responsabilidade |
|---|---|
| `api.reservoir` | Tipos imutáveis e modelo de domínio determinístico de reservatórios |
| `common.reservoir` | Geração, consulta, transações de extração e ciclo de vida de cache |
| `common.storage` | Persistência versionada (WorldSavedData/regiões); sem dependências de renderer |
| `common.multiblock` | Formação/orientação/ciclo mestre–parte sobre o IE 1.7.10 |
| `common.processing` | Pumpjack, Derrick, Distillation Tower, Coker e demais transações de máquina |
| `common.fluid` | Fluidos e adaptadores de registro |
| `common.compat` | Integrações opcionais isoladas do carregamento de classes do núcleo (+ coremod) |
| `client.render` | Malha estática + armadura dinâmica (TESR) |
| `client.gui` | Somente GUI; o servidor é autoritativo |

### 5.2 Decisões estruturais que se repetem em todo o código

- **Reservatórios.** Semente determinística = seed do mundo + dimensão + versão estável do algoritmo; flood-fill iterativo (nunca recursivo), com área máxima e guardas de corrupção; busca espacial por chave de região; **cache descartável, dado persistido autoritativo**; NBT v1 com ganchos de migração; aritmética de capacidade em `long`; extração com semântica **SIMULATE → EXECUTE** (1.7.10 não tem `FluidAction`); nunca *force-load* de chunk só para responder consulta. Persistência em **shards 512×512 por dimensão** (`>>9`, escala do `RegionPos` moderno).
- **Multiblocos transacionais.** Formação valida tudo sem mutar → resolve orientação/espelho → aloca estado mestre → converte membros → **rollback** se qualquer conversão falhar → só então marca/sincroniza. Quebrar qualquer membro resolve o mestre exatamente uma vez, invalida a estrutura, restaura blocos constituintes e impede drop duplicado.
- **Persistência fail-closed.** Envelopes NBT versionados; versão desconhecida ou payload malformado **não é reescrito silenciosamente**: vai para *quarentena opaca* preservando o NBT bruto, com diagnóstico.
- **Renderização.** Pumpjack definiu o contrato: corpo estático em geometria cacheada + armadura dinâmica hierárquica (manivela, contrapesos, viga, bielas, haste) via **um único TESR no mestre**, fase única de animação com cinemática ligada (não osciladores independentes), caixa de colisão cobrindo a máquina inteira, zero alocação por frame, **nenhum vazamento de estado GL**. Angelica ligado é o alvo primário.
- **Contenção de falhas.** Todo subsistema e integração tem kill-switch de config; desativar nunca exige apagar dados de mundo.
- **Rede.** Comandos de GUI executam na thread de tick do servidor, exigem container vivo correspondente, distância e payload limitado e validado *antes* de alocar/mutar.
- **Sem estado de cliente no servidor.** Sem I/O de disco, decodificação de recursos, criação de threads ou filas ilimitadas em ticks/renders.

### 5.3 Coremod ASM

`PetroleumDrillCorePlugin` aplica três famílias de transformers: **drill-oil** (extração/óleo), **potion-ID** (reparo de colisão de IDs de poção do IE — ver incidente em [`HIPOTESES-E-INCIDENTES.md`](HIPOTESES-E-INCIDENTES.md)) e **refinery/catalyst** (adaptador estrito para a Refinery do IE 17). Os transformers usam nomes **MCP e SRG** (a falha com apenas um dos dois causou `NoSuchMethodError`). Classes de listener ASM precisam ser públicas.

## 6. Estado por família de funcionalidade

Legenda: **Lab** = aprovado no laboratório de desenvolvimento (build limpo, testes JUnit, campanhas de servidor dedicado multi-boot e, onde aplicável, cliente Angelica 2.2.8 com screenshot inspecionado). **Nenhuma família foi homologada em pack real, mundo copiado de produção, multiplayer autenticado, shaderpack ativo ou benchmark.** Valores numéricos vêm dos documentos de gate citados.

| Família | Primeira aparição | Estado em 15/09 | Fatos técnicos registrados | Lacunas declaradas |
|---|---|---|---|---|
| **Reservatórios** (G3) | alpha.1/2 (`3dd5dcf`, `598ee10`) | Lab · G3A/G3B PASS | Campo simplex V1 reconstruído com testes de paridade; scanner canônico não recursivo; shards 512×512; codecs NBT versionados; genesis determinística (tipo/capacidade por identidade estável, óleo/aquífero/lava a partir das receitas 1.21.1); campanhas de 250 mil casos aleatórios e footprint de 268.435.456 colunas; corrupção de GZIP fail-closed + recuperação | Upgrade de **mundo real** (G2) pendente; política de migração de versão do algoritmo |
| **Fluidos** (G4A) | alpha.3 (`42f1239`) | Lab | 10 fluidos registrados via `FluidRegistry` do Forge 1.7.10; ids canônicos `immersivepetroleum:<nome>`; colisão com `crudeoil` estrangeiro testada; `registerAll()` idempotente | Sem texturas upstream; arte final pendente |
| **Pumpjack** (G4B) | alpha.4–7 (`3d4ba53`…`64d7932`); requalificado `e898344` | Lab | Semântica moderna 1.21.1; bloqueia enquanto qualquer tap finito tiver pressão; **1024 Flux/t e 15 mB/t por tap finito**; saída finita L→O com reserva + rollback exato; reservatórios infinitos com ofertas independentes por porta (até 10 tentativas); energia CoFH reservada transacionalmente; template de **32 blocos**; 8 orientações; TESR com ~696 vértices/174 quads por frame, 37 draws GL; extração real contra Reservoir (`e898344`) | Arte/sombra final (G4B3B), pack/multiplayer/performance |
| **Well / WellPipe** (G4B2) | alpha.5 (`cf4364b`); qualificado `23e45b2` | Lab | Blocos ocultos sem item/loot; TileEntity persistente + conector vertical leve; limites modernos 69×69; topologia imutável após iniciar perfuração; rollback ao quebrar tubo; auto-destruição no bedrock; timer sem `markDirty` no hot-path (corrigido) | Final art, multiplayer |
| **Distillation Tower** (G5) | alpha.8/9 (`759d3a5`, `cff03f9`); NBT/entrega `926c17e`, `2aed5b5` | Lab | Tanques de 24.000 mB, buffer 16.000 RF, fila de um processo; template de **137 blocos** gerado do NBT congelado (SHA-256); formação transacional; portas CoFH/Forge (entrada fill-only, saída agregada drain-only); persistência schema-v1 com quarentena; **ledger de entrega de subprodutos** (cancelamento/restart/callback incerto); TESR com 21 draws | G5C2: UX/arte finais, shaderpack ativo, política de LOD medida |
| **Derrick** (G6) | alpha.10 (`dc6587d`); grade `56ea3a5` | Lab | **59 partes**; perfuração física + virtual (2 físicos + 382 virtuais no teste), saída de pressão real com *spill*, handoff para Pumpjack no mesmo Well; container de servidor (FakePlayer + Container real; shift-click de 4 tubos com conservação); caminhos de falha (cancelamento, schema-999 retido, endpoint de pressão malformado, Well inválido); grade direcional e aquisição de componentes em sobrevivência | Arte/áudio finais, shaderpack ativo, multiplayer remoto |
| **Seismic Survey** | `58f7b7b` | Lab | Persistência de mapas + UX de cliente | Jornada de sobrevivência ponta a ponta (ramo `extraction-journey` não tem commit próprio) |
| **Oil Tank** | `c197971` | Lab | Armazenamento moderno, portas/equalização, envelope persistente | Pack/multiplayer/performance |
| **Coker** | WIP no checkpoint; custom em `fbcb919` | Lab | Contratos persistentes customizados, scripts, metadados, UI nativa; cadeia petcoke (ex.: `petcoke`: 2 betume + 125 mB água → 2 petcoke + 27 mB diesel sulfuroso, 15.360 RF, 30 ticks — valor-fonte, **não** balanceamento final) | Ingredientes com NBT/curingas/OreDict; balanceamento |
| **Hydrotreater** | `7672529`; endurecido `6339c71` | Lab | 3 receitas modernas; contratos persistentes; recuperação de saídas; rollback pendente endurecido; envelope precisa admitir `id/x/y/z` | Pack/multiplayer/performance |
| **Catalyst Refinery** | `9879cdc` | Lab | Contratos gasolina + catalisador (redstone/constantan), fluido acetaldeído, **transformer estrito para Refinery do IE 17**, restart e GUI Angelica | Pack/multiplayer/performance |
| **Gas Generator** | `f717ba5` | Lab | Runtime combustível/RF, persistência, auditoria de fio/chunk-boundary | Polimento, performance |
| **Flarestack** | `59e2d9c` | Lab | Descarte analógico, persistência/recuperação, segurança em borda de chunk | Polimento, performance |
| **Lubrificação / Auto Lubricator** | WIP; `42b568f`/`a4182f9` | Lab | Política: preservar e auditar os handlers do IE; IDs de poção reparados via ASM; `OwnedItemPlacement` compartilhado com 6 casos reexecutados (Auto Lubricator, Gas, Flarestack) | Linha da FEATURE-MATRIX não atualizada |
| **Projector** | `3d645b5` | Lab | Posse, colocação, templates, UX nativa | Validar abuso de pacotes (G8) |
| **Asphalt** | `2c7b3f9` | Lab | Movimento 1.20x autoritativo no servidor; 4 formas de superfície; config/remoção; tooltips | Arte final/pack/performance |
| **Motorboat / Speedboat** | `9ad549c`, `0b7ac71` | Lab | Combustível/física/upgrades modernos; **5 upgrades**, 2 passageiros, autoridade de input, persistência/drop/redeploy; contratos icebreaker-emergency, fonte de dano, offset de lava, queda AIR→LAND, hélice limitada; áudio com ciclo de vida | Arte final, multiplayer |
| **Materiais** | `1ec598d` | Lab | Cera/bloco de parafina; **vela do Petroleum** original (1.7.10, metadado 1–4, acende/apaga/luz/drop, renderer Angelica); **couro ersatz** como item IP explícito com receitas auditadas; colocação transacional | — |
| **Molotov / Gasoline Bottle** | `5bd89e5` | Lab | Persistência, transações e cliente | UX tardia |
| **NEI / CraftTweaker** | `c23571f`, `16e7bab`, `7f86f4d` | Lab | Catálogos de receita opcionais; receitas admitidas preservadas em *reload*; envelopes ambíguos rejeitados; NEI nativo com layouts, navegação e refresh por revisão; CraftTweaker 3.4.8 exige IC2 (SyntheticCrop) | G9: matriz de pack exato |

Detalhe de camadas e dependências: [`FLUXOGRAMAS.md` §8](FLUXOGRAMAS.md#8-jornada-das-famílias-de-funcionalidade). Evidências por família estão nos documentos `2026-09-13/14/15-*` em [`archive/engineering-docs-tip-2c7b3f9/`](archive/engineering-docs-tip-2c7b3f9/).

## 7. Como o trabalho foi conduzido

### 7.1 Gates e evidência

O `ROADMAP.md` define G0–G11 (diagrama em [`FLUXOGRAMAS.md` §4](FLUXOGRAMAS.md#4-portões-de-aprovação-g0g11)): G0 congelamento de evidências (161/161 hashes) · G1 build reprodutível · G2 runtime esqueleto · G3 reservatório/storage · G4 fundação + Pumpjack · G5 Distillation Tower · G6 extração moderna · G7 processamento moderno · G8 mobilidade/construção · G9 matriz de compatibilidade · G10 performance/soak/corrupção · G11 release candidate. Cada gate tem subportões (ex.: G4B1, G4B2A/B/C, G4B3A/B, G5A/B/C1/C2, G6A–G6F) com decisão **PASS / FAIL / BLOCKED / PLANNED** e evidência salva em `evidence/`.

### 7.2 Infraestrutura de qualificação (tudo em `tools/` e `run/` do projeto local)

- **Campanhas multi-boot** em servidor dedicado: escreve → reinicia → muta → reinicia → quebra → reforma, em 4–5 JVMs seguidas, com matriz de **8 orientações**.
- **Mutex global** `Global\ImmersivePetroleumRuntimeProbe`: todas as campanhas o compartilham; lançamento concorrente é rejeitado *antes* de criar processos Gradle/Java (isolamento entre chats/execuções).
- **`tools/guarded_task.py`**: supervisor local com heartbeat, recibos em `run/guarded-tasks` e códigos de saída 73/74; endurecido contra locks transitórios do Windows (`b19fd88`); introduzido em `6475315` (supervisão local recuperável de tarefas).
- **Sondas de cliente Angelica**: restauração de estado GL, contagem de draws, screenshots deterministas **inspecionados**.
- **Digests de código-fonte** (inclusive 138 hashes sem divergência na revisão independente da alpha.10) e SHA-256 de regiões de mundo.
- **Simulação de domínio** em Python (`tools/reservoir_domain_sim.py`) e campanhas de 250 mil casos aleatórios para conservação.
- **Julgar por marcadores, não por exit code:** Gradle/`runServer` pode terminar com 0 e `BUILD SUCCESSFUL` mesmo depois de FML reportar exceção de mod.

### 7.3 Papéis e disciplina

Dono da implementação integra; revisor independente procura contraexemplos concretos; aprovador avalia a evidência salva; achados tardios reabrem gates já aprovados (o caso do **cano coberto do IE duplicando itens**, achado na revisão do Derrick, forçou regressões em Pumpjack e Distillation). Declaração honesta recorrente: *"mesmo assistente revisou, sem auditoria externa independente"*.

## 8. Armadilhas de API do 1.7.10 já documentadas

Registradas nos handoffs para evitar repetição de erro:

- Compilar contra `build/rfg/recompiled_minecraft-1.7.10.jar`.
- O construtor `ItemFluidContainer(int)` resulta em **capacidade 0**.
- Ordem dos argumentos de `DieselHandler` do IE.
- `World.setTileEntity` e `Chunk.removeTileEntity`: ordem de chamadas importa para evitar fantasmas.
- Classes de listener ASM precisam ser **públicas**.
- Não existe `getTileData()` em TileEntity de 1.7.10.
- `BlockSnapshot.restore` tem **bug de máscara** (flags).
- `ChunkProviderClient.chunkExists` sempre retorna `true`.
- `GL_CONSTANT_COLOR` está em `GL11`; `glBlendColor` em `GL14`.
- `MapStorage.loadData` instancia o `WorldSavedData` antes de descomprimir e, se o GZIP falhar, pode devolver um *shell* vazio em vez de `null`.
- `FakePlayer`: use `addChatComponentMessage` (e não `addChatMessage`) em testes.
- Resolver ids de fluido canônicos para o **nome de registro do Forge** antes de despachar.

## 9. O que ainda não está provado

(Ver lista completa e priorizada em [`ESTADO-ATUAL-E-RETOMADA.md`](ESTADO-ATUAL-E-RETOMADA.md).)

- **G2 – upgrade de mundo real:** nenhum mundo copiado de produção foi exposto ao addon.
- Servidor **Crucible/Java 21** e cópia real do pack.
- Multiplayer remoto autenticado, shaderpacks ativos, soak e benchmarks (1/16/64/256 máquinas).
- Arte, modelos, texturas e áudio **finais** originais; escuta humana do áudio.
- Jornada de sobrevivência ponta a ponta sem fixtures.
- Gate de licença/assets (G11 bloqueado).
- Pendências de conteúdo: ingredientes do Coker (NBT/curingas/OreDict), UX final da torre, linhas desatualizadas da FEATURE-MATRIX.

## 10. Glossário

| Termo | Significado |
|---|---|
| **IP / Petroleum** | ImmersivePetroleum |
| **IE** | Immersive Engineering (no pack: 0.7.9 customizado) |
| **Forbidden Series** | O modpack/servidor-alvo |
| **Gate (G0–G11)** | Portão de aprovação com critérios de saída e evidência |
| **Campanha** | Execução automatizada multi-boot em servidor dedicado (e/ou cliente) que produz um veredito |
| **Fail-closed** | Dado desconhecido/corrompido é preservado e recusado, nunca reescrito |
| **Quarentena opaca** | Preservação do NBT bruto de um payload que o código não entende |
| **SIMULATE/EXECUTE** | Duas fases de uma transação de fluido/energia: calcular sem mutar, depois aplicar |
| **TESR** | TileEntitySpecialRenderer — renderer dinâmico de máquinas |
| **Handoff** | Pacote de transferência para outro contexto de trabalho |
| **Rejeitado** | Evidência preservada que **não** foi aceita como PASS |
| **Lab** | Aprovado no laboratório de desenvolvimento; não é homologação de produção |
