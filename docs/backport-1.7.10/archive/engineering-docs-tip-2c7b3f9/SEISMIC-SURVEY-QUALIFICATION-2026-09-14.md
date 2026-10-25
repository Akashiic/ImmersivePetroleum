# Seismic Survey — qualificação de servidor, persistência e cliente

Data: 2026-09-14. Base versionada: `a4182f9b2d89bb6d6fd684708535bb6b2a4dc71c`.
Fonte final qualificada: digest `c29eb8b52986913a76f0cf4d7df96b58c21e4f7403cd98c5f312828f4a0f154b`.
Evidência consolidada: `run/seismic-resumption-20260914T1430/qualification.json`.

## Escopo aprovado no laboratório

O instrumento sísmico ocupa três células, aceita buckshot IE, conserva o cartucho vazio e executa descoberta incremental limitada no servidor. O relatório pronto é um snapshot portátil; abrir o caderno não concede autoridade de leitura ou mutação do reservatório no servidor.

A campanha final exercitou um disparo pago, reinicialização durante trabalho pendente, coleta do resultado, inventário saturado, publicação cancelada do item empacotado, desmontagem pela parte superior, reforma e retomada no mesmo local. Um scan completo 65×65 produziu 4.225 células e 1.083 células de depósitos no cenário congelado, sem carregar chunks adicionais.

O probe deixou de inferir carregamento apenas por contagem. Ele captura as identidades dos chunks já carregados e exige que o conjunto posterior não contenha qualquer chunk novo. A persistência do TileEntity usa `markTileEntityChunkModified` para o chunk proprietário em vez do `markDirty` herdado que pode provocar varreduras de comparadores.

## Cliente e relatório

A campanha cliente final passou com Angelica e quatro capturas revisadas: instrumento no mundo, mapa de sinal sísmico, mapa de depósitos e cartão de detalhe do reservatório. O mapa permanece norte-para-cima e mostra origem, coordenadas sob cursor, dimensão, quantidade observada, capacidade restante e fluxo estimado.

A textura dinâmica do mapa é compartilhada e reutilizada entre aberturas, evitando criar/deletar uma textura nova a cada caderno. Recarregamento de recursos, overlay e detalhe foram exercitados. Essa aprovação cobre legibilidade e funcionamento observados; não declara arte premium final nem compatibilidade com todo shader externo.

## Gates finais

Os três gates finais usaram exatamente a mesma fonte e terminaram com `source_unchanged=true`: `seismic-release-source-v2-20260914T1430`, `seismic-release-client-20260914T1430` e `seismic-release-native-20260914T1430`.

`cleanTest check --no-daemon` executou **565 testes em 90 suítes**, com zero falhas, erros ou ignorados. Checkstyle main/test: zero apontamentos. Os relatórios XML foram copiados para `run/seismic-resumption-20260914T1430/qualified-junit` e `qualified-checkstyle`.

Servidor final: campanha `20260914T190042Z-484714899a5446e89e983560eb8df46d`. Marcadores finais confirmaram autoridade de munição, publicação/coleta, persistência, mapa runtime e os três modos da fixture. O SHA-256 da região `r.195.195.mca` confere com `2477f34895dc42a90c37f9d2e140d7066928f68be9e00a2e2beb8bf77d55fb6b`.

Cliente final: campanha `seismic-20260914T185847Z-36c22065fe23425ab51daff466f57fde`, marcador `SEISMIC_CLIENT_PROBE_PASS draws=7 angelica=true map=4225 overlay=true detail=true reload=true textureReused=true`. As quatro imagens foram conferidas contra os hashes do resumo e inspecionadas visualmente.

`server.properties`, `eula.txt` e `options.txt` foram restaurados aos mesmos hashes do checkpoint anterior. Nenhum marcador FML fatal exigido pela auditoria apareceu nos logs finais.

## Correções desta frente

Além da integração já existente, a qualificação encontrou e fechou persistência de chunk durante recoil/trabalho, medição inadequada de carregamento de chunks na fixture, reuso de textura de caderno, textos localizados ausentes no relatório e recibos de processo dos runners. Os testes novos impedem reintrodução do `markDirty` herdado nesse TileEntity e verificam a persistência pelo chunk proprietário.

As tentativas intermediárias pertencentes a digests anteriores continuam arquivadas como diagnóstico; somente os três gates finais sobre `c29eb8b…` formam a aprovação desta frente.

## Limites explícitos

Esta aprovação não transforma o relatório em leitura ao vivo do reservatório e não testa jogador autenticado em multiplayer. Não há alegação de consistência atômica entre todos os arquivos do mundo diante de queda abrupta do host. Explosão/remoção externa forçada da estrutura não possui o mesmo preflight cancelável do break por jogador e continua fora do cenário certificado.

Crucible com Java 21, modpack completo, cópia de mundo real, multiplayer autenticado, shaders arbitrários, soak e benchmarks permanecem gates separados. A revisão foi conduzida pelo mesmo assistente com inspeção adversarial e testes; não houve revisor independente externo. Nenhum JAR ou mundo de produção foi modificado e nenhuma release foi emitida.
