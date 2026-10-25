# Coker customizado — qualificação de contratos, scripts e interfaces

Base versionada: `7f86f4d40bb7ef91356230ebdba9b03956b1daa3` (NEI qualificado).
Frente: `feature/coker-recipes-20260914T004009Z`, no worktree isolado `ImmersivePetroleum-nei-20260913T190723Z`.
Evidência desta integração: `run/coker-continuation-20260914T013231Z`.
API e fronteiras: `COKER-CUSTOM-RECIPES.md`.

## Continuidade preservada

A retomada encontrou contratos, catálogo, codec e estado das câmaras já preparados como WIP, com 517 testes/79 suítes. Os arquivos e relatórios foram copiados antes da integração. Não se reatribui esse trabalho anterior a esta rodada. O commit base continha 495 testes; 22 testes de contratos/estado estavam no WIP. A integração acrescentou 11 testes, chegando a 528 testes/83 suítes, além de sete testes operacionais do coordenador Python, contados separadamente.

O catálogo customizado está ligado ao TileEntity, MineTweaker, NEI, portas, recipientes, publicação de itens, desmontagem e GUI. O schema 2 mantém os contratos aceitos enquanto o schema 1 migra somente a receita padrão congelada. A bancada de testes nativos é separada dos mundos de produção.

## Reprodução negativa antes das correções

- `coker-browser-red-20260914T013231Z`: a nova receita existia no catálogo, mas o navegador ainda mostrava somente o default; falha expected 2 / actual 1. O navegador agora consulta o catálogo real.
- `coker-legacy-identity-red-20260914T013231Z`: duas falhas mostraram rejeição de identidades legadas com maiúsculas. O contrato de item passou a preservar a grafia exata; o ID próprio da receita continua canônico. O teste nativo posterior confirmou uma identidade real `IC2:itemToolPainter`, compilada pelo ZenScript e removida pelo undo.
- `coker-chamber-isolation-red-20260914T013231Z`: duas falhas de reentrada direta da API de domínio durante publicação. `feed` e `canFillInput`/`fillInput` agora recusam reentrada enquanto o tick é dono da operação. O teste adicional de duas câmaras com resíduos diferentes verifica contabilidade e roundtrip em cada tick, sem misturar buffers.

Todos os diretórios negativos e as respectivas asserções permaneceram preservados. O primeiro teste nativo customizado também parou por erro do runner: uma string de marcador foi concatenada à seguinte. A lista foi tipada como `string[]`; não houve redução da exigência de marcadores ou promoção retroativa daquela tentativa a PASS.

## Fundação e limites de compatibilidade

O comportamento temporal foi confrontado com `CokingChamber.java` no upstream 1.21.1 congelado e com `ADR-COKER-UNIT.md`. A normalização dos nomes de fluidos foi conferida no construtor Forge `Fluid`; nomes de itens legados não foram tratados como nomes de fluidos. O JAR IE original não foi editado.

A API nova é de ingredientes exatos com metadata, sem NBT, wildcard ou OreDictionary. Ela não pretende implementar silenciosamente todos os tipos de ingredientes modernos. Essa fronteira é publicada para impedir que uma limitação seja confundida com paridade integral.

## Fechamento da matriz e checkpoint

Matriz final `coker-final-20260914T013231Z`: sete etapas aprovadas, com digest de fonte `b767b252aa732f66aea0f7b1165a52bf718a9a04f4265dd5ceeafcb77e467218` inalterado em todas elas. O encerramento foi revalidado por leitura dos recibos e comparação da fonte atual em 2026-09-14; isso não é uma nova execução das mesmas campanhas.

Check integral: **528 testes, 83 suítes, zero falhas, erros ou ignorados; Checkstyle main/test zero**. Campanha customizada `20260914T031711Z-5cc7e2970e6444d9a161127d8bed09c7`: quatro boots. Regressão padrão `20260914T031956Z-79c51491f35142a397436bc5a61720a5`: quatro boots. Regressão DT/Hydro com scripts `20260914T032237Z-800e41e31bb14473a9c945e15ff23884`: dois boots.

Clientes finais: NEI pt_BR/2 em `20260914T032400Z-7b6ecaf2856c44949f29608dd96469fc`, NEI en_US/1 em `20260914T032513Z-bcb9df2503d447ddb37e00040dfc4377`, cada um com sete cartões; máquina em `coker-20260914T032620Z-da037a47b13043cba8da1faf0ec6f71f`, com modelo, GUI padrão e GUI customizada. A GUI customizada verifica reconstrução de timer 150000/duração 300000 e resolução dos nomes dos fluidos pelos IDs recebidos.

Foram rechecados 72 hashes de logs, resumos, capturas e regiões. As 17 capturas finais foram inspecionadas no fechamento, incluindo todos os cartões nos dois idiomas/escalas. A geometria e os conteúdos observados cabem nos painéis. A captura externa mostra uma vista lateral da estrutura; não certifica apresentação premium final de todos os ângulos. Contatos visuais derivados e recibo de fechamento estão em `run/projector-continuation-20260914T033754Z`; originais permanecem nos diretórios das campanhas.

Consolidação original: `run/coker-continuation-20260914T013231Z/final-qualification.json`. Nenhum JAR original, mundo de produção, push ou release foi alterado por esta frente. `server.properties`, `eula.txt` e `options.txt` foram restaurados e comparados aos hashes anteriores.

A revisão foi do mesmo assistente; não há auditor independente externo alegado. A matriz não aprova Crucible/Java 21, o pack completo, shaders, multiplayer autenticado, consistência atômica entre arquivos durante queda abrupta ou desempenho. Os limites de ingredientes exatos e adaptações de capacidade permanecem explícitos em `COKER-CUSTOM-RECIPES.md`.

## Matriz final e fechamento

Matriz `coker-final-20260914T013231Z`: sete etapas PASS, fonte e drivers inalterados. Digest final: `b767b252aa732f66aea0f7b1165a52bf718a9a04f4265dd5ceeafcb77e467218`. O check completo executou 528 testes/83 suites, zero falhas, erros ou ignorados; Checkstyle main/test zero. Os sete testes operacionais do coordenador sao separados dessa contagem.

Campanhas finais: custom scripts `20260914T031711Z-5cc7e2970e6444d9a161127d8bed09c7` (4 boots); default `20260914T031956Z-79c51491f35142a397436bc5a61720a5` (4 boots); refinaria `20260914T032237Z-800e41e31bb14473a9c945e15ff23884` (2 boots). Os scripts foram compilados no CT fixado com o IC2 de referencia; o IC2 nao se tornou dependencia obrigatoria do addon. A campanha default continua exercitando os controles e a receita original sem scripts opcionais.

Clientes finais: NEI pt_BR/2 `20260914T032400Z-7b6ecaf2856c44949f29608dd96469fc`; NEI en_US/1 `20260914T032513Z-bcb9df2503d447ddb37e00040dfc4377`; maquina `coker-20260914T032620Z-da037a47b13043cba8da1faf0ec6f71f`. Cada NEI incluiu sete paginas, metadata e substituicao ao vivo; a maquina verificou reconstrucao do contador 150000/300000, capacidade 16 e nomes dos fluidos. As 17 capturas tiveram hashes conferidos. A retomada seguinte inspecionou todas em contact sheets, preservando originais; a estrutura e os elementos observados cabem no enquadramento. A GUI ainda tem apresentacao inicial e popup nativo de tutorial: nao se aprova arte final por esse gate.

Contabilidade customizada: 6 itens consumidos, 8 produtos metadata 1, 1000 mB de lavagem, 26 mB residuais e 300 RF. Dois itens nao consumidos sobreviveram no inventario mesmo sem a receita ativa. Desmontagem: 5 itens crus metadata 4, 4 processados metadata 1, uma capsula; cancelamento e restart nao produziram duplicacao. O script aceitou identidade real `IC2:itemToolPainter` sem alterar caixa.

Consolidacao em `run/coker-continuation-20260914T013231Z/final-qualification.json`, XMLs `qualified-junit`/`qualified-checkstyle`, recibos em `run/guarded-tasks`. Revalidacao e revisao visual do fechamento: `run/projector-resumption-20260914T033810Z/coker-closure.json`. Regioes, fonte e configuracoes foram conferidos novamente antes do commit; nao houve nova execucao de toda a matriz apenas para repetir o fechamento.

Limites: revisao pelo mesmo assistente, nao auditor independente; ausencia de teste de producao, pack completo, Crucible/Java 21, shaders, multiplayer autenticado e benchmarks. O suporte exato a ingredientes nao substitui NBT/wildcards/OreDictionary. Os avisos conhecidos do ambiente legado permanecem arquivados e nao sao descritos como ambiente sem warnings. Nenhuma release, push ou instalacao em producao foi feita.
