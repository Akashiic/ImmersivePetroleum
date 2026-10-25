# Cronologia — Immersive Petroleum 1.7.10 (Forbidden Backport)

> Reconstruída a partir do **histórico git real** do repositório de trabalho local (38 commits, 11 tags, 37 branches) cruzado com os documentos de engenharia do próprio projeto. Fuso horário de todos os horários: **UTC−03:00**. Dados brutos: [`data/commits.tsv`](data/commits.tsv), [`data/tags.tsv`](data/tags.tsv), [`data/branches.tsv`](data/branches.tsv), [`data/release-jars.tsv`](data/release-jars.tsv), [`data/progress-estimates.tsv`](data/progress-estimates.tsv), [`data/docs-history.tsv`](data/docs-history.tsv).

> **Janela coberta:** 2026-09-09 19:51 → 2026-09-15 20:16 (≈ 6 dias e 25 minutos de relógio entre o primeiro e o último commit). O diretório foi inicializado como repositório da raiz em ~2026-10-02 (sem commits; ver `ESTADO-ATUAL-E-RETOMADA.md`).

## 0. Build em uso pelo autor (ponto de retomada de fato)

> O autor está usando o JAR `0.1.0-alpha.10-feature-catalyst-refinery-20260915T1300.24+1ec598dd1c-dirty` (SHA-256 `d5065d03…2c72c`, 1.583.283 B), carimbo de build **2026-09-15 18:25**. Análise completa em [`BUILD-EM-USO.md`](BUILD-EM-USO.md).

| Quando | Evento | Observação |
|---|---|---|
| 09-15 12:29 | `1ec598d` — cadeia de materiais (base do nome da versão; 24 commits após a alpha.10) | |
| **09-15 18:25** | **JAR do autor construído** = `1ec598d` + rascunho **não commitado** do Catalyst Refinery (`-dirty`) | Mesmo conjunto de 318 classes de topo que o commit `9879cdc`; **sem** as 3 classes do Asphalt de `2c7b3f9` |
| 09-15 18:42 | `9879cdc` — Catalyst Refinery commitado e qualificado (611 / 100) | 17 min depois do build |
| 09-15 20:16 | `2c7b3f9` — Asphalt (ponta do git) | Superconjunto do JAR em uso; sem JAR gerado |

**Leitura para quem vai retomar:** o *artefato* mais recente em uso é esse JAR "dirty"; o *código* mais recente e commitado é `2c7b3f9`. Preserve o worktree sujo `ImmersivePetroleum-catalyst-20260915T1700` (única fonte do JAR), mas continue o desenvolvimento a partir de `2c7b3f9`.

## 1. Resumo em uma tela

| Marco | Commit | Data/hora | Significado |
|---|---|---|---|
| Baseline | `fd97d51` | 2026-09-09 19:51 | Linha de base (alpha.0) |
| Última alpha publicada como pacote | `dc6587d` | 2026-09-12 14:04 | Última alpha publicada como pacote (alpha.10, JAR + ZIP) |
| Checkpoint de transferência de 12/09 | `db6b77d` | 2026-09-12 17:09 | Checkpoint de transferência de 12/09 (o que o COMECE-AQUI descreve) |
| Ponta mainline real | `2c7b3f9` | 2026-09-15 20:16 | Ponta mainline real (Asphalt) — **~67 %**, faixa 61–74 % |
| **Build em uso** | `1ec598d`+dirty | 2026-09-15 18:25 | JAR do autor (ver §0 e `BUILD-EM-USO.md`) |

Crescimento medido no código (`src/main/java` / `src/test/java`):

| Ponto | Arquivos main | Linhas main | Arquivos test | Linhas test | docs | tools |
|---|---:|---:|---:|---:|---:|---:|
| alpha.0 (`fd97d51`) | 1 | 34 | 0 | 0 | 5 | 1 |
| alpha.1 (`3dd5dcf`) | 13 | 1.271 | 5 | 424 | 8 | 5 |
| alpha.9 (`cff03f9`) | 73 | 10.467 | 28 | 3.170 | 24 | 15 |
| alpha.10 (`dc6587d`) | 95 | 15.280 | 40 | 5.217 | 29 | 23 |
| checkpoint 12/09 (`db6b77d`) | 272 | 33.668 | 64 | 6.529 | 57 | 45 |
| ponta 15/09 (`2c7b3f9`) | 321 | 39.869 | 101 | 9.110 | 85 | 56 |

## 2. Fases

### Fase 0 — Fundação e carta (09/09)

Nasce o repositório de trabalho com 19 arquivos / 924 linhas: carta do projeto, hierarquia de fontes de verdade, política de licenciamento (upstream = apenas evidência; clean-room), esqueleto Gradle (RetroFuturaGradle, Forge 10.13.4.1614, Java 8). Tag `0.1.0-alpha.0`.

| # | Quando | Commit | Tag | O quê | Δ arquivos | +/− linhas | Testes/suítes |
|--:|---|---|---|---|--:|---|---|
| 1 | 2026-09-09 19:51 | `fd97d51` | alpha.0 | Linha de base auditada: carta do projeto, hierarquia de fontes, esqueleto Gradle | 19 | +924 / −0 | — |

### Fase 1 — Domínio de reservatórios e fluidos (10/09)

Quatro alphas em um dia: reservatório determinístico com persistência fail-closed (28 → 76 testes), gênese de reservatórios, fundação de fluidos sem colisão de IDs e o núcleo transacional do Pumpjack (semântica SIMULATE/EXECUTE).

| # | Quando | Commit | Tag | O quê | Δ arquivos | +/− linhas | Testes/suítes |
|--:|---|---|---|---|--:|---|---|
| 2 | 2026-09-10 00:46 | `3dd5dcf` | alpha.1 | Núcleo determinístico de reservatórios + persistência segura | 30 | +2.262 / −20 | 28 |
| 3 | 2026-09-10 11:19 | `598ee10` | alpha.2 | Gênese determinística de reservatórios | 19 | +1.554 / −28 | 45 |
| 4 | 2026-09-10 15:39 | `42f1239` | alpha.3 | Fundação de fluidos (registro sem colisão de IDs) | 15 | +861 / −10 | 48 |
| 5 | 2026-09-10 22:27 | `3d4ba53` | alpha.4 | Núcleo transacional do Pumpjack | 16 | +1.950 / −10 | 76 |

### Fase 2 — Poço, multibloco e primeira torre (11/09)

Well/WellPipe, multibloco Pumpjack com formação transacional/rollback, primeiro renderer dinâmico (TESR sob Angelica) e o núcleo da Distillation Tower (maior salto de testes do período: 116 → 156).

| # | Quando | Commit | Tag | O quê | Δ arquivos | +/− linhas | Testes/suítes |
|--:|---|---|---|---|--:|---|---|
| 6 | 2026-09-11 01:18 | `cf4364b` | alpha.5 | Infraestrutura Well / WellPipe | 20 | +1.617 / −7 | 100 |
| 7 | 2026-09-11 03:19 | `67e5ab0` | alpha.6 | Multibloco Pumpjack em runtime | 21 | +1.903 / −28 | 106 |
| 8 | 2026-09-11 14:20 | `64d7932` | alpha.7 | Fundação do renderer do Pumpjack (TESR/Angelica) | 17 | +969 / −14 | 116 |
| 9 | 2026-09-11 23:39 | `759d3a5` | alpha.8 | Núcleo da Distillation Tower | 43 | +4.466 / −10 | 156 |

### Fase 3 — Derrick e a primeira transferência (12/09)

Renderer da torre (alpha.9) e Derrick (alpha.10, 245 testes / 40 suítes, JAR 452.282 B). À tarde, o checkpoint `db6b77d` congela 273 arquivos (+24.646 linhas) com todo o WIP auditado (Oil Tank, Hydro, Coker, Seismic, Gas, Flare, Lube, Projector, Molotov, Motorboat) e gera o pacote de transferência — **este é o estado que o `COMECE-AQUI-TRANSFERENCIA.md` descreve**.

| # | Quando | Commit | Tag | O quê | Δ arquivos | +/− linhas | Testes/suítes |
|--:|---|---|---|---|--:|---|---|
| 10 | 2026-09-12 03:16 | `cff03f9` | alpha.9 | Fundação do renderer da Distillation Tower | 14 | +692 / −11 | 159 |
| 11 | 2026-09-12 14:04 | `dc6587d` | alpha.10 | Derrick: extração, ciclo de vida auditado e controles iniciais | 73 | +8.216 / −199 | 245 / 40 |
| 12 | 2026-09-12 17:09 | `db6b77d` |  | Checkpoint de transferência completa (273 arquivos): WIP auditado + validação | 273 | +24.646 / −29 | 401 / 64 |

### Fase 4 — Qualificação de runtime e integridade (13/09)

Muda o regime de trabalho: de "escrever funcionalidades" para "qualificar com evidência". Entram o supervisor `guarded_task` (heartbeat, recibos, exit codes 73/74), campanhas multi-boot em servidor dedicado, catálogos de receita opcionais, quarentena de NBT malformado, ledger de entrega de subprodutos e o cliente NEI nativo.

| # | Quando | Commit | Tag | O quê | Δ arquivos | +/− linhas | Testes/suítes |
|--:|---|---|---|---|--:|---|---|
| 13 | 2026-09-13 00:47 | `6339c71` |  | Endurecimento do rollback pendente do Hydrotreater; alvo Crucible/Java 21 | 6 | +210 / −4 | — |
| 14 | 2026-09-13 02:33 | `6475315` |  | Qualificação de runtime e supervisor local de tarefas (guarded_task) | 20 | +428 / −19 | 407 |
| 15 | 2026-09-13 06:28 | `9ad549c` |  | Motorboat integrado; ciclo de passageiros seguro para servidor | 14 | +189 / −48 | 408 |
| 16 | 2026-09-13 07:41 | `c23571f` |  | Catálogos de receita opcionais (NEI/MineTweaker) + snapshots reais de máquinas | 13 | +357 / −11 | 410 |
| 17 | 2026-09-13 09:02 | `16e7bab` |  | Receitas admitidas preservadas em reload; envelopes ambíguos rejeitados | 12 | +335 / −36 | 419 |
| 18 | 2026-09-13 12:35 | `926c17e` |  | Payloads malformados da torre preservados (quarentena) + recurso real | 7 | +323 / −13 | 429 |
| 19 | 2026-09-13 15:10 | `2aed5b5` |  | Ledger de entrega de subprodutos da torre (cancelamento/restart/callback incerto) | 18 | +1.460 / −63 | 475 / 73 |
| 20 | 2026-09-13 21:39 | `7f86f4d` |  | NEI nativo: receitas, layouts, navegação, refresh seguro por revisão | 19 | +1.014 / −52 | 495 / 77 |

### Fase 5 — Onda de qualificação por família (14/09)

Treze commits em um dia. Cada família (Coker, Projector, Molotov, Seismic, Well, Derrick-grid, Oil Tank, Hydrotreater, Gas Generator, Flarestack) passa pelo mesmo ciclo: reprodução → correção na camada responsável → campanha de runtime → cliente Angelica com screenshot inspecionado. O reparo dos IDs de poção do IE ocorre em ramo lateral (`42b568f`) e é reintegrado (`a4182f9`).

| # | Quando | Commit | Tag | O quê | Δ arquivos | +/− linhas | Testes/suítes |
|--:|---|---|---|---|--:|---|---|
| 21 | 2026-09-14 00:43 | `fbcb919` |  | Coker customizado: contratos persistentes, scripts, metadados, UI nativa | 34 | +1.761 / −144 | 528 / 83 |
| 22 | 2026-09-14 12:14 | `3d645b5` |  | Projector: posse, colocação, templates, UX do cliente | 23 | +718 / −55 | 546 / 87 |
| 23 | 2026-09-14 13:47 | `5bd89e5` |  | Garrafa de gasolina e Molotov: persistência, transações, cliente | 12 | +134 / −66 | 548 / 87 |
| 24 | 2026-09-14 14:06 | `42b568f` |  | Reparo de IDs de poção do IE (ramo lateral) + fluidos/lubrificação | 8 | +307 / −5 | — |
| 25 | 2026-09-14 14:32 | `a4182f9` |  | Integração do reparo de poção IE; requalificação de fluidos e lubrificação | 8 | +321 / −4 | 562 / 88 |
| 26 | 2026-09-14 16:48 | `58f7b7b` |  | Seismic Survey: persistência, mapas, UX do cliente | 14 | +475 / −13 | 565 / 90 |
| 27 | 2026-09-14 17:20 | `23e45b2` |  | Well: infraestrutura, persistência, ciclo de vida | 9 | +328 / −80 | 572 / 92 |
| 28 | 2026-09-14 19:25 | `56ea3a5` |  | Derrick: grade direcional, sobrevivência, editor no cliente | 10 | +223 / −20 | 572 / 92 |
| 29 | 2026-09-14 20:26 | `c197971` |  | Oil Tank: armazenamento moderno, envelope persistente | 9 | +125 / −11 | 575 / 93 |
| 30 | 2026-09-14 20:56 | `7672529` |  | Hydrotreater: persistência, runtime, cliente Angelica | 8 | +132 / −13 | 579 / 94 |
| 31 | 2026-09-14 22:14 | `f717ba5` |  | Gas Generator: persistência, fios, ciclo de vida | 10 | +340 / −16 | 585 / 95 |
| 32 | 2026-09-14 22:36 | `b19fd88` |  | guarded_task: recibos resistentes a locks transitórios do Windows | 1 | +16 / −8 | — |
| 33 | 2026-09-14 23:00 | `59e2d9c` |  | Flarestack: persistência, runtime analógico, cliente | 12 | +308 / −17 | 589 / 96 |

### Fase 6 — Fechamento da primeira passada (15/09)

Motorboat moderno, extração Pumpjack+Reservatório de ponta a ponta, cadeia de materiais legados (vela, couro ersatz), Catalyst Refinery (adaptador IE17 estrito) e Asphalt. Último commit: `2c7b3f9`, 20:16. Depois disso o git não registra mais nada — há apenas trabalho não commitado em worktrees (ver `ESTADO-ATUAL-E-RETOMADA.md`).

| # | Quando | Commit | Tag | O quê | Δ arquivos | +/− linhas | Testes/suítes |
|--:|---|---|---|---|--:|---|---|
| 34 | 2026-09-15 00:26 | `0b7ac71` |  | Motorboat: semântica moderna e ciclo de vida do cliente | 12 | +299 / −34 | 594 / 97 |
| 35 | 2026-09-15 01:40 | `e898344` |  | Pumpjack + Reservoir: extração real e renderização | 11 | +360 / −302 | 594 / 97 |
| 36 | 2026-09-15 12:29 | `1ec598d` |  | Cadeia de materiais legada (vela, couro ersatz) + colocação transacional | 24 | +993 / −5 | 598 / 98 |
| 37 | 2026-09-15 18:42 | `9879cdc` |  | Catalyst Refinery: química e adaptador IE17 | 20 | +1.291 / −11 | 611 / 100 |
| 38 | 2026-09-15 20:16 | `2c7b3f9` |  | Asphalt: movimento e apresentação | 13 | +250 / −5 | 611 / 100 |

## 3. Dia a dia

| Dia | Commits | Primeiro → último | Testes ao fim do dia | Principais entregas |
|---|--:|---|---|---|
| 2026-09-09 | 1 | 19:51 → 19:51 | — | Linha de base auditada |
| 2026-09-10 | 4 | 00:46 → 22:27 | 76 | Núcleo determinístico de reservatórios + persistência segura; Gênese determinística de reservatórios; Fundação de fluidos (registro sem colisão de IDs); Núcleo transacional do Pumpjack |
| 2026-09-11 | 4 | 01:18 → 23:39 | 156 | Infraestrutura Well / WellPipe; Multibloco Pumpjack em runtime; Fundação do renderer do Pumpjack (TESR/Angelica); Núcleo da Distillation Tower |
| 2026-09-12 | 3 | 03:16 → 17:09 | 401 / 64 suítes | Fundação do renderer da Distillation Tower; Derrick; Checkpoint de transferência completa (273 arquivos) |
| 2026-09-13 | 8 | 00:47 → 21:39 | 495 / 77 suítes | Endurecimento do rollback pendente do Hydrotreater; alvo Crucible/Java 21; Qualificação de runtime e supervisor local de tarefas (guarded_task); Motorboat integrado; ciclo de passageiros seguro para servidor; Catálogos de receita opcionais (NEI/MineTweaker) + snapshots reais de máquinas; … |
| 2026-09-14 | 13 | 00:43 → 23:00 | 589 / 96 suítes | Coker customizado; Projector; Garrafa de gasolina e Molotov; Reparo de IDs de poção do IE (ramo lateral) + fluidos/lubrificação; … |
| 2026-09-15 | 5 | 00:26 → 20:16 | 611 / 100 suítes | Motorboat; Pumpjack + Reservoir; Cadeia de materiais legada (vela, couro ersatz) + colocação transacional; Catalyst Refinery; … |

## 4. Versões empacotadas (tags `0.1.0-alpha.N`)

Todas as tags são anotadas e apontam para commits da linha principal. Os JARs foram preservados em `dist/` do projeto local (hashes SHA-256 lidos dos `SHA256SUMS` de cada release). **Não há `dist/` para alpha.0 e alpha.1** (evidência em `evidence/g3a-alpha1-tagged-final`).

| Versão | Commit | Data | Testes | JAR (bytes) | SHA-256 |
|---|---|---|--:|--:|---|
| 0.1.0-alpha.0 | `fd97d51` | 2026-09-09 19:51 | — | — | (sem JAR em dist/) |
| 0.1.0-alpha.1 | `3dd5dcf` | 2026-09-10 00:46 | 28 | — | (sem JAR em dist/) |
| 0.1.0-alpha.2 | `598ee10` | 2026-09-10 11:19 | 45 | 65.679 | `fb24d1fc667af0d29bf41456bfbab46fe6c6bd5d78774726608610ce0f8c9787` |
| 0.1.0-alpha.3 | `42f1239` | 2026-09-10 15:39 | 48 | 81.674 | `82de7e151c1a1ef2831da5a900fa06842f347ef0fad1672756e09156f6bc7027` |
| 0.1.0-alpha.4 | `3d4ba53` | 2026-09-10 22:27 | 76 | 110.520 | `7522d6ef9f91041215247f6c2a3307868e4241ab6d10bcb7fd81add9cbc0dbc9` |
| 0.1.0-alpha.5 | `cf4364b` | 2026-09-11 01:18 | 100 | 133.570 | `2edc22cc43bcdb5a062e55bc67bb746ca4850cf14298304b667d148c8b028cce` |
| 0.1.0-alpha.6 | `67e5ab0` | 2026-09-11 03:19 | 106 | 179.837 | `5773ebe2db5947cc589dc00d73ba296a0e546336c3738e8eb3011f420424b1fd` |
| 0.1.0-alpha.7 | `64d7932` | 2026-09-11 14:20 | 116 | 197.396 | `41dcf282ae79d4db32cb57395a10670653ee41edc1282c8359ca9d10ec0523f7` |
| 0.1.0-alpha.8 | `759d3a5` | 2026-09-11 23:39 | 156 | 284.913 | `054859cefb627730e2754a7ba70bb6a64b1bc4f0dfb395032070cb6a46e7815c` |
| 0.1.0-alpha.9 | `cff03f9` | 2026-09-12 03:16 | 159 | 296.923 | `23e2b61f7f2b4f75a77bc732b50592354d6603edfde25b3d9bf211e98e315871` |
| 0.1.0-alpha.10 | `dc6587d` | 2026-09-12 14:04 | 245 / 40 suítes | 452.282 | `271359f01e011aba5ee03121da085c51e0c9587143cd94d36e8c0c630ae9b20a` |

Build **não-tag** em uso pelo autor (não está em `dist/`): `0.1.0-alpha.10-feature-catalyst-refinery-20260915T1300.24+1ec598dd1c-dirty` — 1.583.283 B — SHA-256 `d5065d03a3e4ea65b518e523a5809161c486ccd4ad5c456ffc91a9770ce1c72c` — construído 2026-09-15 18:25 a partir de `1ec598d` + Catalyst não commitado. Detalhes: [`BUILD-EM-USO.md`](BUILD-EM-USO.md).

Pacote de transferência de 12/09 (descrito pelo `COMECE-AQUI`): ZIP ≈ 95 MiB / 99.434.467 B, 1.732 entradas, SHA-256 `c8d90c79e851c062a037f1541a6352645429025f40ca51feac9f990a4399a364`; manifesto `HANDOFF_NOT_RELEASE`, restauração verificada.

## 5. Estimativa de progresso global ao longo do tempo

Fonte: `docs/TOTAL-PROGRESS.md` (julgamento de engenharia sobre um denominador fixo e ponderado — infra 20 %, extração/refino/armazenagem 35 %, exploração/utilidades 15 %, mobilidade 10 %, apresentação 10 %, homologação 10 %). **Não é contagem de linhas, commits ou testes e não é previsão de prazo.**

| Data | Checkpoint | Estimativa | Faixa | Testes / suítes |
|---|---|--:|---|---|
| 2026-09-12 | alpha.10 baseline (TOTAL-PROGRESS) | **35 %** | 30–40 % | 245 / 40 |
| 2026-09-13 | Reavaliação de continuidade | **45 %** | 40–50 % | — |
| 2026-09-13 | Campanhas e integração | **50 %** | 45–55 % | — |
| 2026-09-13 | Entrega de subprodutos (DT) | **50 %** | 45–55 % | 475 / 73 |
| 2026-09-14 | NEI e consistência do catálogo | **51 %** | 45–57 % | 495 / 77 |
| 2026-09-14 | Coker customizado | **52 %** | 46–58 % | 528 / 83 |
| 2026-09-14 | Projector | **53 %** | 47–60 % | 546 / 87 |
| 2026-09-14 | Garrafa de gasolina e Molotov | **54 %** | 48–61 % | 548 / 87 |
| 2026-09-14 | IE potion IDs / World Fluids / Lubrication | **55 %** | 49–62 % | 562 / 88 |
| 2026-09-14 | Seismic Survey | **56 %** | 50–63 % | 565 / 90 |
| 2026-09-14 | Well / WellPipe | **57 %** | 51–64 % | 572 / 92 |
| 2026-09-14 | Derrick directional grid / survival | **58 %** | 52–65 % | 572 / 92 |
| 2026-09-14 | Oil Tank modern storage | **59 %** | 53–66 % | 575 / 93 |
| 2026-09-14 | Hydrotreater modern processing | **60 %** | 54–67 % | 579 / 94 |
| 2026-09-14 | Gas Generator | **61 %** | 55–68 % | 585 / 95 |
| 2026-09-14 | Flarestack analog utility | **62 %** | 56–69 % | 589 / 96 |
| 2026-09-15 | Motorboat / Speedboat | **63 %** | 57–70 % | 594 / 97 |
| 2026-09-15 | Pumpjack + Reservoir extraction | **64 %** | 58–71 % | 594 / 97 |
| 2026-09-15 | Material Chain / legacy target adaptations | **65 %** | 59–72 % | 598 / 98 |
| 2026-09-15 | Catalyst Refinery chemistry | **66 %** | 60–73 % | 611 / 100 |
| 2026-09-15 | Asphalt movement/presentation | **67 %** | 61–74 % | 611 / 100 |

Leitura: a alpha.10 foi avaliada em 35 %; a reavaliação de 13/09 reconheceu o trabalho já presente no checkpoint (45 %); cada família qualificada depois acrescentou ~1 ponto. A faixa tem sempre ±6–7 pontos porque homologação (pack real, multiplayer autenticado, shaders, soak, arte/áudio finais) continua em aberto.

## 6. Notas de método e ressalvas

- Datas e horários vêm de `git log` (autor/committer date) e são exibidos em UTC−03:00.
- A coluna "Testes/suítes" reproduz o que a documentação do próprio commit registra; `—` significa que o commit não registra a contagem. Contagem de testes **nunca** foi usada como medida de progresso pelo projeto.
- `alpha.9`: 159 testes conforme `BUILD-AUDIT`; `alpha.10`: 245 testes / 40 suítes e 228 classes no JAR.
- O commit `42b568f` (reparo de poção IE) está em ramo lateral a partir de `2aed5b5` e foi reintegrado por `a4182f9`; o diretório de trabalho principal do projeto ficou **em `42b568f`**, não na ponta mainline `2c7b3f9`.
- Os diretórios de worktree têm nomes que não correspondem ao conteúdo (ex.: `…-nei-20260913T190723Z` está de fato na ponta `2c7b3f9`). Ver `data/branches.tsv`.
- Esta cronologia descreve **desenvolvimento em laboratório**: nenhuma alpha foi homologada em pacote/mundo de produção.
