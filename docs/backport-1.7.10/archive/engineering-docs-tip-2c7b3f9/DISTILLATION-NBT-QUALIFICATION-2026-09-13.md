# Distillation Tower — envelope NBT e admissão de recursos

Base: `16e7bab76ca327519a6f1fe992f776b0006572af`. Data: 2026-09-13.
Evidências desta frente: `run/tower-integrity-20260913T144218Z`.

## Defeito, reprodução e correção

O TileEntity tratava `machineState` presente com tipo diferente de compound como estado vazio, contornando o codec estrito. Também aceitava ausência em um mestre formado e mantinha indicação de atividade em certos estados rejeitados.
O candidato da conversa anterior foi confrontado com a fonte atual. Dez testes novos foram executados antes da produção mudar: 429 testes/70 suítes, seis falhas, zero erros/ignorados. Cinco falhas demonstraram perda/ausência/atividade; a sexta registrou a ausência do novo predicado de admissão. Os 419 testes anteriores não falharam.

A correção preserva o payload como NBTBase copiado, distingue ausência de tipo incorreto, mantém ausência em mestre formado e bloqueia energia/fill/drain durante quarentena/desmontagem. Não muda receitas, RNG, schema do processo, bibliotecas ou bytecode alvo.
Após o patch e após acrescentar o probe nativo, `cleanTest check --no-daemon` passou sem filtros: **429 testes, 70 suítes, zero falhas/erros/ignorados, Checkstyle main/test zero**. A fonte permaneceu igual durante as execuções. Recibos: `tower-nbt-green-20260913T144218Z` e `tower-nbt-probe-sourcecheck-20260913T144218Z` sob `run/guarded-tasks`.

## Campanha Forge real

`run/distillation-multiblock-campaign/20260913T152122Z-203686c84c404f19af694e6017dc5f1e` aprovou write, verify-break, verify-reform e orientation-matrix. O teste adicional atua nas portas reais de uma torre formada: quatro variantes inválidas, três recargas NBT cada, zero admissão de energia/fluido, zero dreno, dados opacos preservados e estado original integralmente restaurado.
Marcador obrigatório: `DISTILLATION_TILE_NBT_PORTS_PASS variants=4 reloads=3 energyBlocked=true fluidBlocked=true restored=true`.
O cenário de corrupção usa recargas explícitas do mesmo TileEntity no write; os boots seguintes são regressão da torre saudável restaurada. Não é uma alegação de quatro mundos corrompidos salvos e reabertos.
A campanha passou com digest de fonte inalterado; logs foram inspecionados e não contêm os marcadores fatais FML. Região: SHA-256 `511c5486293561351fde698295512541c51dbef190f1de75f64edfd00b699eaa`. Configurações restauradas conferidas por hash.

## Falhas operacionais preservadas

Um primeiro lançamento Python demorou antes de criar o recibo. A guarda anterior a encerramento/repetição constatou que ele já havia retomado; nada foi relançado ou morto. A reprodução terminou normalmente com os testes vermelhos.
A primeira campanha nativa aprovou o write e o novo probe, mas o runner compartilhado recuperou ExitCode vazio. Foi preservada como campanha reprovada. Teste de processos retornando 0 e 7 confirmou a recuperação exata ao conservar o handle. O runner compartilhado agora preserva `$proc.Handle` antes da espera e rejeita código ausente; os marcadores anteriores permanecem obrigatórios. Somente a campanha posterior de quatro boots é PASS.

## Limites

Esta frente não corrige nem aprova ainda a publicação de subprodutos, desmontagem adversarial, identidade viva completa ou chunks de todos os percursos. O ledger candidato da conversa anterior continua uma frente separada. Não há aprovação de Crucible/Java 21, pack completo, multiplayer autenticado, shaders, arte/áudio finais ou desempenho por estes resultados. A inspeção foi realizada pelo mesmo assistente; não é auditoria independente. Nenhum JAR ou mundo de produção foi alterado.
