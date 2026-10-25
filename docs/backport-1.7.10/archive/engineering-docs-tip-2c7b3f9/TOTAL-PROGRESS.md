# Progresso do backport completo

Referência inicial desta avaliação: `dc6587d` / alpha.10, em 2026-09-12.

**Estimativa de engenharia: aproximadamente 35%, faixa de 30–40%.** Não é uma contagem objetiva de linhas, commits ou testes, nem uma previsão de tempo restante. O denominador inclui o conjunto moderno completo e os critérios de entrega premium. Estimativas anteriores que davam peso excessivo à fundação industrial não devem ser comparadas diretamente com esta base.

| Frente | Peso no total | Execução estimada na alpha.10 | Evidência e lacunas |
|---|---:|---:|---|
| Infraestrutura, persistência e confiabilidade | 20% | 70–85% | Build, domínios, registries e campanhas passam; migração do mundo real e integrações faltam. |
| Extração, refino e armazenagem | 35% | 35–45% | Reservatórios, Pumpjack, Derrick e torre têm partes aprovadas; Oil Tank, Coker, Hydrotreater e UX completa faltam. |
| Exploração e utilitários | 15% | 5–15% | Base reutilizável; pesquisa sísmica, geração, lubrificação, flarestack e projector pendentes. |
| Mobilidade e itens restantes | 10% | 0–10% | Motorboat, upgrades, Molotov e famílias de materiais ainda não entregues. |
| Apresentação, UX e documentação | 10% | 15–30% | Renderizadores iniciais e documentação técnica; arte final, áudio e integração de receitas/manual pendentes. |
| Homologação e desempenho | 10% | 5–15% | Campanhas de desenvolvimento existem; JAR no pack completo, multiplayer e benchmarks pendentes. |

Os pesos somam 100%. Os intervalos ponderados dão aproximadamente 29–41%, arredondados para comunicar a incerteza sem falsa precisão. As frentes separam implementação de apresentação e homologação para evitar contabilizar o mesmo teste como três entregas.

## Regra de atualização

- Registrar comportamento moderno de referência e a adaptação necessária à 1.7.10.
- Atualizar a matriz por recurso com implementação, teste de domínio, runtime, UX, persistência, integração e homologação separados.
- Código novo ainda em revisão não aumenta automaticamente o percentual aprovado.
- Cada checkpoint é uma etapa. O objetivo continua sendo entregar todas as famílias da FEATURE-MATRIX e fechar os critérios finais da DELIVERY-PLAN.

## Execução iniciada após alpha.10

Pesquisa sísmica e relatórios, Oil Tank, editor direcional autorizado do Derrick e aquisição de concreto em sobrevivência estão em implementação paralela. Não estão contabilizados como concluídos nesta avaliação inicial.

## Congelamento para transferência, 2026-09-12

O cliente solicitou preparar a sucessão de engenharia antes do término da cota. A implementação avançou para várias famílias adicionais; consulte `HANDOFF-2026-09-12.md` para o inventário e `HANDOFF-VALIDATION.md` para o gate do checkpoint. O texto acima continua sendo a estimativa da **baseline alpha.10**, não uma porcentagem atual recalculada. Nenhuma nova porcentagem global homologada foi emitida no congelamento; runtime, cliente e qualificação ainda têm gates abertos. Não inferir conclusão pelo volume de código no checkpoint.

## Reavaliação de continuidade — 2026-09-13

Após revalidar o checkpoint `db6b77d63c91696ed492b8d069d529cda450a9ee`, a nova estimativa de engenharia é **aproximadamente 45%, faixa de 40–50%**, mantendo o denominador completo e os pesos anteriores. Trata-se de estimativa sobre implementação e evidências, não homologação integral das famílias.

A matriz, os intervalos por frente, o cálculo e os bloqueios estão em [ENGINEERING-RESUMPTION-2026-09-13.md](ENGINEERING-RESUMPTION-2026-09-13.md). O servidor de destino é explicitamente Crucible com Java 21; essa qualificação não pode ser substituída pelos testes Forge/Java 8. A JVM do cliente continua sendo uma dimensão separada da matriz.

O número anterior de 35% permanece válido como registro histórico da alpha.10. O novo julgamento reconhece o trabalho posterior, sem contar código sem hooks ou testes não executados como entregas completas. A correção pontual de persistência iniciada nesta retomada não produz, por si só, um novo aumento no percentual global. Não há prazo de calendário aprovado.

## Reavaliação após campanhas e integração — 2026-09-13

Estimativa atual: **aproximadamente 50%**, faixa comunicada arredondada **45–55%**. Não é aprovação de 50% das features nem previsão de prazo. Mantêm-se os pesos e o escopo premium completo. O aumento reconhece as campanhas reais de Coker/Lube/Gas/Flare, Motorboat servidor/cliente e receitas das máquinas entre boots, não somente a quantidade de testes ou o patch NBT desta rodada.

| Frente | Peso | Intervalo de execução estimado |
|---|---:|---:|
| Infraestrutura/persistência/confiabilidade | 20% | 70–85% |
| Extração/refino/armazenagem | 35% | 50–60% |
| Exploração/utilitários | 15% | 35–50% |
| Mobilidade/itens restantes | 10% | 30–45% |
| Apresentação/UX/documentação | 10% | 25–35% |
| Homologação/desempenho | 10% | 10–15% |

A aritmética ponderada resulta em 43,25–55%, centro 49,125%; a comunicação de 50% (45–55%) é arredondamento de julgamento, não intervalo estatístico. Critérios e evidências: RUNTIME-QUALIFICATION, MOTORBOAT-QUALIFICATION, RECIPE-INTEGRATION, RECIPE-RELOAD-INTEGRITY e DISTILLATION-NBT-QUALIFICATION, todos de 2026-09-13.

Continuam abertos publicação/desmontagem adversarial da torre, Coker customizável, cliente NEI, famílias sem campanhas completas, adaptações restantes, arte/áudio finais, jornada survival, Crucible/Java 21, pack/mundo reais copiados, multiplayer e medições. Código candidato ou testes preparados sem execução não contam como frente concluída. Não elevar a porcentagem por cada patch pontual.

## Continuidade da entrega de subprodutos — 2026-09-13

Mantida a estimativa **50%, faixa de 45–55%**. A integração do ledger da torre, persistência entre boots, callbacks adversariais e regressões DT/Hydro/receitas estão documentados em `DISTILLATION-DELIVERY-QUALIFICATION-2026-09-13.md`. O check atual contém 475 testes/73 suítes sem falhas, mas a quantidade de testes não redefine o denominador do produto. Não se concede aumento automático de percentual por fechar um bloqueio pontual de integridade. Os gates restantes do escopo premium completo continuam abertos.

## NEI e consistência do catálogo — 2026-09-14

Estimativa de engenharia atualizada para **51%, faixa de 45–57%**, sobre o mesmo produto completo. A frente de receitas no cliente passou por categorias/páginas reais, idiomas, escalas, callbacks de navegação, recarregamento e servidor sem NEI. A última fonte tem 495 testes/77 suítes e matriz completa aprovada. Evidências e limitações estão em `NEI-CLIENT-QUALIFICATION-2026-09-14.md`.

A correção da ordem de leitura da revisão impede que uma edição concorrente seja tomada como já refletida num snapshot anterior. A sequência de qualificação não promoveu uma execução parada no menu a PASS: preservou o diagnóstico, recuperou o processo próprio e exigiu nova matriz. Receitas customizadas do Coker, restante do conteúdo, apresentação final, pack/Crucible e multiplayer continuam fora desta aprovação.

## Coker customizado — checkpoint de 2026-09-14

Estimativa de engenharia: **52%, faixa de 46–58%**, para o mesmo produto completo. O incremento reconhece contratos persistentes por câmara, API de scripts, variantes exatas de itens, desmontagem correta, consulta pelo NEI e GUI com parâmetros variáveis, exercitados em servidor e cliente. Não resulta da contagem de testes. A matriz final do Coker teve 528 testes/83 suítes, dez boots de servidor e três campanhas de cliente. Referências: `COKER-CUSTOM-RECIPES.md` e `COKER-CUSTOM-QUALIFICATION-2026-09-14.md`.

Continuam pendentes ingredientes mais gerais (NBT/wildcards/OreDictionary), famílias/campanhas restantes, apresentação final, jornada survival e a qualificação de Crucible/Java 21, pack completo, mundo copiado, multiplayer, shaders e desempenho. O próximo bloco de execução é o Projector. O checkpoint de compatibilidade de poções em outro worktree não foi incorporado automaticamente a esta avaliação.

## Projector — checkpoint de 2026-09-14

Estimativa de engenharia atualizada para **53%, faixa de 47–60%**, sobre o mesmo produto premium completo. O incremento reconhece a conclusão laboratorial do Projector: autoridade de servidor, settings e protocolo estritos, seis templates exatos, construção criativa protegida por eventos, GUI/materials, cliente Angelica, recarregamento de recursos e matriz completa de construção.

O digest qualificado passou com 546 testes/87 suítes, três boots dedicados, 956 células construídas sob orçamento e 13 capturas de cliente revisadas. Evidências: `PROJECTOR-QUALIFICATION-2026-09-14.md` e `run/projector-resumption-20260914T052335Z/qualification.json`.

Esse aumento não inclui Crucible/Java 21, pack/mundo copiados, multiplayer autenticado, shaders arbitrários, soak ou benchmark final. Molotov e outras famílias ainda não qualificadas continuam fora do numerador aprovado.

## Garrafa de gasolina e Molotov — checkpoint de 2026-09-14

Estimativa de engenharia atualizada para **54%, faixa de 48–61%**, mantendo o mesmo denominador do produto premium completo. O incremento reconhece uma família de item/entidade agora exercitada em fonte, dois boots dedicados e cliente Angelica: recipiente de 250 mB, crafting, ignição de 20 ticks, pavio de 300 ticks, transações persistentes, proteção de fogo/dano, fronteiras de chunks e apresentação inicial. A porcentagem não deriva dos 548 testes.

A frente corrigiu três envelopes persistentes para preservar dados futuros/malformados de forma opaca: pavio, journal e projétil. Falhas anteriores causadas pela fixture — ausência de `ticksExisted++`, queda/morte do ator sintético e uso de getters `@SideOnly(CLIENT)` em diagnóstico — foram documentadas e não contadas como bugs de produção. Evidência: `MOLOTOV-QUALIFICATION-2026-09-14.md`.

Continuam fora desta aprovação o acabamento visual/sonoro final, Crucible/Java 21, multiplayer autenticado, pack e mundo copiados, shaders e benchmarks. O próximo avanço deve fechar outra família ou gate substancial; não elevar a porcentagem por correções pontuais isoladas.

## Integração IE potion IDs / World Fluids / Lubrication — 2026-09-14

Após requalificar a correção dos IDs de efeitos do IE sobre a linha pós-Projector/Molotov, a estimativa global passa para **aproximadamente 55%, faixa de 49–62%**. O número reconhece uma frente de compatibilidade e duas famílias de runtime novamente aprovadas sobre a mesma fonte consolidada; não transforma quantidade de testes em percentual de produto.

A fonte integrada passou 562 testes/88 suítes, World Fluids, quatro boots de Lubrication e cliente Angelica no mesmo digest `eb2321b881b5e1ea87ea9ea4588f757611426ec353f31c0ed35c5595383054a5`. Crucible/Java 21, modpack completo, multiplayer autenticado, shaders, benchmarks e acabamento audiovisual continuam abertos e impedem uma estimativa mais alta.

## Seismic Survey — checkpoint de 2026-09-14

Estimativa de engenharia atualizada para **56%, faixa de 50–63%**, mantendo o mesmo denominador do backport premium completo. O incremento reconhece uma família de exploração agora exercitada de ponta a ponta: munição e autoridade do servidor, descoberta incremental, relatório portátil, persistência entre boots, empacotamento/desmontagem, mapa 65×65, detalhe de reservatório e cliente Angelica.

A fonte final `c29eb8b52986913a76f0cf4d7df96b58c21e4f7403cd98c5f312828f4a0f154b` passou **565 testes/90 suítes**, três boots dedicados e quatro capturas cliente revisadas. O scan de runtime confirmou 4.225 células, 1.083 células de depósito no cenário congelado e nenhuma identidade de chunk nova carregada pelo trabalho do scanner. Referência: `SEISMIC-SURVEY-QUALIFICATION-2026-09-14.md`.

Crucible/Java 21, pack/mundo copiados, multiplayer autenticado, shaders arbitrários, soak, benchmarks e acabamento audiovisual final continuam fora dessa aprovação. O aumento não deriva da contagem de testes e não transforma relatórios sísmicos em consultas live ao servidor.

## Well / WellPipe — checkpoint de 2026-09-14

Estimativa de engenharia atualizada para **57%, faixa de 51–64%**, mantendo o mesmo denominador do backport premium completo. O incremento reconhece uma família estrutural da Modern Refinery agora qualificada: topologia persistente, conectividade física, rollback de segmento, quarentena de NBT, autodestruição e custo de persistência auditado.

A fonte final `fe995100744cc30189c798f4f630a1a3258a247c7ab50e76072ff664e2165316` passou **572 testes/92 suítes** e três boots dedicados. A região final confere por SHA-256 e os arquivos de configuração retornaram aos hashes anteriores. Evidência: `WELL-INFRASTRUCTURE-QUALIFICATION-2026-09-14.md`.

Well/WellPipe são infraestrutura escondida e não possuem gate cliente independente. Crucible/Java 21, pack/mundo copiados, multiplayer autenticado, soak, benchmarks e apresentação final das máquinas controladoras continuam fora dessa aprovação. O próximo bloco de alto impacto é o Derrick Grid Editor e a aquisição survival restante do Derrick.

## Derrick directional grid / survival — checkpoint de 2026-09-14

Estimativa de engenharia atualizada para **58%, faixa de 52–65%**, mantendo o mesmo denominador do backport premium completo. O incremento reconhece o fechamento dos dois gaps antes explicitamente abertos do Derrick: editor directional 69×69 e aquisição survival do componente de grating compatível, além da requalificação conjunta do runtime já existente.

O digest final `41379c1cce9bd275cdb55e270f9d708c4a0603c123651930818250c89cded3af` passou 572 testes/92 suítes, quatro boots dedicados e cliente Angelica com torre, GUI normal e editor. O servidor comprovou protocolo de 20 bytes, token/revision/range/rate-limit/lock, plano de quatro taps/sete unidades, crafting reversível da grating slab, drilling/pressure, recovery/quarantine/handoff e matriz de orientação.

A primeira captura do editor revelou tooltip PT-BR cortado; ela foi rejeitada e substituída somente após wrapping nativo e nova campanha cliente. Evidência: `DERRICK-GRID-QUALIFICATION-2026-09-14.md`. Trânsito remoto real do pacote, Crucible/Java 21, pack/mundo reais, multiplayer autenticado, benchmarks e apresentação final continuam abertos.

## Oil Tank modern storage — checkpoint de 2026-09-14

Estimativa de engenharia atualizada para **59%, faixa de 53–66%**, mantendo o mesmo denominador do backport premium completo. O incremento reconhece o fechamento laboratorial do armazenamento moderno: capacidade/tag de fluido, seis portas, equalização, output/redstone, recipientes, persistência/quarentena, lifecycle estrutural e cliente Angelica.

O digest final `e94930c4a86bcf155be05c462cae62c708671b4a6add0e6027b5ef080d78b7d9` passou **575 testes/93 suítes**, quatro boots dedicados e cliente Angelica. Uma reprodução negativa mostrou que campos futuros top-level do schema 1 eram aceitos e depois normalizados; o envelope agora falha fechado enquanto NBT interno do fluido permanece opaco. Evidência: `OILTANK-QUALIFICATION-2026-09-14.md`.

A porcentagem não deriva da contagem de testes. Crucible/Java 21, pack/mundo copiados, multiplayer autenticado, shaders, soak, benchmarks e acabamento visual/sonoro final continuam fora do numerador aprovado. O próximo avanço deve fechar outra família/gate substancial da Modern Refinery ou Industrial Utility.

## Hydrotreater modern processing — checkpoint de 2026-09-14

Estimativa de engenharia atualizada para **60%, faixa de 54–67%**, mantendo o mesmo denominador do backport premium completo. O incremento reconhece outra família central da Modern Refinery agora qualificada: três receitas modernas, contratos pagos persistentes, portas/GUI/redstone, publicação conservativa, recovery/lifecycle, oito orientações e cliente Angelica.

O digest final `083b9409e6d6441aecbd82059b6ca21733a58cf2510445eb4296bd3c340d3d62` passou **579 testes/94 suítes**, quatro boots dedicados e cliente Angelica. A auditoria corrigiu dois envelopes que aceitavam campos futuros e também revelou, por campanha negativa, a necessidade de permitir `id/x/y/z` vanilla no NBT de disco completo encaminhado pelo IE. Evidência: `HYDROTREATER-QUALIFICATION-2026-09-14.md`.

A porcentagem não deriva da quantidade de testes. Crucible/Java 21, pack/mundo copiados, multiplayer autenticado, shaders, soak, benchmarks e acabamento visual/sonoro final permanecem fora do numerador aprovado.

## Gas Generator â€” checkpoint de 2026-09-14

Estimativa de engenharia atualizada para **61%, faixa de 55â€“68%**, mantendo o mesmo denominador do backport premium completo. O incremento reconhece uma famÃ­lia Industrial Utility agora qualificada em laboratÃ³rio: trÃªs combustÃ­veis congelados, batch pago persistente, redstone/buffer, packing/pickup, recipientes, output frontal/wire, fronteira de chunk e lifecycle cliente.

O digest final `1955232433ffbe348a6c47e14090c528db146a8c946efabd4ceee70829c716d2` passou **585 testes/95 suÃ­tes**, trÃªs boots dedicados e cliente Angelica. A fronteira de wire comprovou `chunkLoads=0` enquanto o vizinho permanecia descarregado. O envelope runtime/state passou a preservar dados futuros incompatÃ­veis de forma opaca/quarentenada. EvidÃªncia: `GAS-GENERATOR-QUALIFICATION-2026-09-14.md`.

A porcentagem nÃ£o deriva da contagem de testes. Crucible/Java 21, pack/mundo copiados, multiplayer autenticado, shaders arbitrÃ¡rios, soak, benchmark e acabamento audiovisual final continuam fora do numerador aprovado.
## Flarestack analog utility - checkpoint 2026-09-14

Engineering estimate updated to **62%, range 56-69%**, retaining the same denominator: the complete premium backport. The increment recognizes another Industrial Utility family now qualified end-to-end in the development lab: analog disposal, persistent tank/inversion, survival acquisition, callbacks/damage, packed recovery, chunk-boundary safety, renderer/particle/audio lifecycle and Angelica compatibility.

Final digest `6a9378559704130a11b505d1de63fc5ab10e9ec3bb1308d201d1430b1c617cdd` passed **589 tests / 96 suites**, three dedicated boots and the Angelica client. Negative reproduction proved and closed future-field loss in both the state and TileEntity envelopes. Evidence: `FLARESTACK-QUALIFICATION-2026-09-14.md`.

The percentage is not derived from test count. Crucible/Java 21, copied pack/world, authenticated multiplayer, shaders, soak, benchmarks and final audiovisual polish remain outside the approved numerator.

## Motorboat / Speedboat — checkpoint de 2026-09-15

Estimativa de engenharia atualizada para **63%, faixa de 57–70%**, mantendo o mesmo denominador do backport premium completo. O incremento reconhece uma família substancial de Mobility/Polish agora requalificada sobre a linha atual, incluindo cinco diferenças semânticas que o handoff anterior deixava explicitamente abertas.

O digest final `ccbeb1b04985f381afba7a491ce03ba35d2cc4c1d454f67605de256f2c621afa` passou **594 testes/97 suítes**, três boots dedicados e cliente Angelica. O servidor comprovou survival/workbench, cinco upgrades, dois passageiros, autoridade de input, persistência/drop/redeploy e os contratos de icebreaker-emergency, fonte direta de dano, offset de lava, queda AIR→LAND e hélice limitada. O cliente comprovou 104 renders, item renderers, `rotLerp` da hélice e lifecycle real de som com mute, alcance, reload, restart e stop.

Evidência: `MOTORBOAT-QUALIFICATION-2026-09-15.md` e `run/motorboat-resumption-20260914T2310/final-qualification.json`. As execuções negativas de 13/09–15/09 permanecem preservadas e não foram promovidas retroativamente a PASS.

Crucible/Java 21, pack/mundo copiados, multiplayer autenticado, controle remoto real, shaderpacks arbitrários, soak, benchmarks e acabamento audiovisual final continuam fora do numerador aprovado. A porcentagem não deriva da contagem de testes.

## Pumpjack + Reservoir extraction — checkpoint 2026-09-15

Estimativa de engenharia atualizada para **64%, faixa de 58–71%**, preservando o mesmo denominador: o backport premium completo. O incremento reconhece o fechamento laboratorial da cadeia de extração Pumpjack/Reservoir, não a quantidade de testes.

O digest final `23e2e88adbbc32e91b86bfb8a8028ae4c159a0bba23e1ecd7fc7a6371f4a9f93` passou **594 testes/97 suítes**, Reservoir Genesis, Reservoir Persistence com corrupção fail-closed e recuperação, kernel Pumpjack, multiblock/lifecycle, oito orientações e cliente Angelica.

A prova visual inicial foi rejeitada duas vezes até que a fixture passasse a instalar um master Pumpjack real no mundo; a captura final foi inspecionada sem clipping evidente. Configurações de servidor/cliente/splash retornaram byte a byte aos hashes anteriores.

Evidência: `PUMPJACK-RESERVOIR-QUALIFICATION-2026-09-15.md` e `run/pumpjack-resumption-20260915T033556Z/final-qualification.json`.

Crucible/Java 21, pack/mundo copiados, multiplayer autenticado, shaderpacks arbitrários, soak, benchmarks e apresentação audiovisual final permanecem fora do numerador aprovado.

## Material Chain / legacy target adaptations — checkpoint 2026-09-15

Estimativa de engenharia atualizada para **65%, faixa de 59–72%**, mantendo o mesmo denominador: o backport premium completo. O incremento reconhece o fechamento laboratorial das adaptações paraffin/material que estavam explicitamente abertas: Petroleum Candle, Ersatz Leather, concrete bottling físico e placement metadata/stackable transacional.

O digest final `d6daae003825b7168bf5d2220338d21bfb4afabd3ab62a50e1ceed977fab2a3f` passou **598 testes/98 suítes**, campanha Derrick/material de quatro boots e cliente Angelica. A primeira campanha cliente foi rejeitada por vazamento de `GL_LIGHTING`; somente a v2 com restauração GL entrou na aprovação.

Como `OwnedItemPlacement` é compartilhado, Auto Lubricator, Gas Generator e Flarestack foram reexecutados no mesmo digest e os três repetiram `OWNED_ITEM_PLACEMENT_PASS cases=6` junto de seus gates de restart/recovery. Evidência: `MATERIAL-CHAIN-QUALIFICATION-2026-09-15.md` e `run/material-chain-resumption-20260915T1200/final-qualification.json`.

A porcentagem não deriva da quantidade de testes. Catalyst-dependent phenol/acetaldehyde, Crucible/Java 21, pack/mundo copiados, multiplayer autenticado, shaderpacks arbitrários, soak/benchmark e acabamento visual final continuam fora do numerador aprovado.

## Catalyst Refinery chemistry â€” checkpoint 2026-09-15

Estimativa de engenharia atualizada para **66%, faixa de 60â€“73%**, mantendo o mesmo denominador: o backport premium completo. O incremento reconhece o fechamento laboratorial da quÃ­mica Catalyst Refinery e nÃ£o deriva da quantidade de testes.

O digest final `268efe6c65afbea0ef5cdae8290408b189d998703afb50df7c873259ca534120` passou **611 testes/100 suÃ­tes**, dois boots dedicados e cliente Angelica. A linha agora executa os trÃªs contratos modernos congelados: gasoline 15 naphtha + 10 benzol -> 25 gasoline (80), `phenol` 5 benzol + 5 petroleum_gas -> 10 creosote IE (240, redstone catalyst) e acetaldehyde 15 petroleum_gas -> 15 acetaldehyde (120, plateConstantan catalyst).

O transformer IE 0.7.9 amplia a inventory/Container para sete slots, adiciona o catalyst slot 6 em `(73,26)`, adapta lookup/energia/comparaÃ§Ã£o de fluidos e aceita somente os nomes MCP/SRG explicitamente provados. As execuÃ§Ãµes RED para dual-name/slot-name e o NoSuchMethodError nativo permanecem preservados como evidÃªncia negativa.

EvidÃªncia: `CATALYST-REFINERY-QUALIFICATION-2026-09-15.md`. Crucible/Java 21, pack/mundo copiados, multiplayer autenticado, shaderpacks arbitrÃ¡rios, soak/benchmark e acabamento visual final continuam fora do numerador aprovado.

## Asphalt movement/presentation — checkpoint 2026-09-15

Estimativa de engenharia atualizada para **67%, faixa de 61–74%**, mantendo o mesmo denominador: o backport premium completo. O incremento reconhece o fechamento laboratorial da família Asphalt, não a quantidade de testes.

O digest final `05624b1386ace3c8ff7ff56c659b0db7d3f2a9f521fca857998a84df779df09b` passou **611 testes/100 suítes**, campanha servidor de quatro boots e cliente Angelica. O servidor comprovou quatro formatos a 1.20× sem empilhamento após 4.000 updates, remoção por config/saída da superfície e wax a 0.95×. O cliente fechou o RED de tooltip ausente, validando os três ItemBlocks, seis formas, config ON/OFF e restauração GL.

Evidência: `ASPHALT-QUALIFICATION-2026-09-15.md` e `run/asphalt-resumption-20260915T1950/final-qualification.json`. Crucible/Java 21, pack/mundo copiados, multiplayer autenticado, shaderpacks arbitrários, soak, benchmark e acabamento visual final continuam fora do numerador aprovado.
