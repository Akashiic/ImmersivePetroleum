# IE potion IDs — correção restrita e qualificação

Iniciada em 2026-09-13 e fechada em 2026-09-14. Base: `2aed5b574523d89aa6af43e2f3d7bd6f00c3bdb1`.
Evidências: `run/potion-id-integrity-20260913T184254Z` e recibos em `run/guarded-tasks`.
O addon permanece em desenvolvimento; esta frente não aprova a release completa.

## Causa demonstrada

A campanha dos fluidos falhava em `lubricant contact`. O JAR IE fixado possui `IEPotions.getPotionID(int,String)` que recebe o ID resolvido por `Config.getPotionID` no local 2, mas retorna o argumento do local 0. A inspeção `javap` confirma que Config retorna seu valor correto. O erro ocorre no helper posterior.

Antes da correção, o servidor registrou Flammable=24 e Slippery=24, embora os objetos fossem distintos e o arquivo de configuração indicasse 24/25. O efeito do lubrificante se misturava ao anterior. Fontes: disassembly em `run/utility-qualification-20260913T181314Z/ie-potions.javap.txt`, `ie-config.javap.txt` desta frente e campanha `20260913T182513Z-cea9d80216a14ae5ba3ed08f1e8dbabe`.

## Correção e fronteira

`PetroleumPotionIdTransformer` é registrado pelo core plugin existente, ao lado do adaptador da furadeira. Ele aceita somente o nome da classe, assinatura e sequência de instruções verificados. Confere variáveis locais, chamadas, campo do array, destino do salto e ausência de handlers de exceção. Modifica somente o local carregado antes de IRETURN, de 0 para 2. Nenhuma instrução de controle de fluxo, stack depth ou tipo é alterada.

O formato equivalente já corrigido é um no-op; transformação repetida não aplica a alteração novamente. Forma inesperada do helper é rejeitada explicitamente, não remendada por heurística. Os dois nomes do campo do array (SRG e desenvolvimento) são reconhecidos. O transformer não resolve classes Minecraft durante a transformação e permanece no prefixo de exclusão já utilizado pelo plugin.

O JAR `ImmersiveEngineering-garden-cloche-test-2.jar` não é reescrito. A seleção de IDs continua pertencendo à configuração nativa IE. Não há alteração de registros de itens/blocos, limpeza de efeitos existentes, atualização de bibliotecas ou mudança do alvo de bytecode Java 8.

## Reprodução e testes

Antes da produção mudar, os 14 testes novos executados pelo pipeline real do core plugin elevaram a suíte para 489 testes/74 suítes. Houve 11 falhas esperadas, incluindo retorno 0 em vez de 2; todos os 475 casos anteriores passaram. Após a correção, o check integral sem filtros passou. Os testes cobrem o JAR real, mapeamentos, forma já corrigida, rejeição de alterações incompatíveis e invariância do restante da classe após desfazer a única instrução alterada.

Os testes são inspeções de bytecode com as dependências reais do projeto. Não há stubs usados para aparentar runtime Forge. As execuções em servidor e cliente devem ser consideradas separadamente.

## Limite de migração

Esta correção não migra dados antigos nem remove efeitos de entidades ou jogadores. Um ID previamente colidido pode não permitir identificar qual efeito originou o registro. A futura instalação exige ensaio em cópia do mundo e do modpack; o cliente e o servidor precisam da mesma combinação qualificada. O JAR original do IE e as configurações escolhidas pelo usuário não foram substituídos.

## Controle das evidências

A campanha de lubrificação `potion-id-lubrication-20260913T184254Z` completou seus cenários, mas o supervisor retornou 74 por mudança da fonte. A diferença foi isolada a duas linhas de diagnóstico na fixture do dispenser: remover somente essas linhas em memória reproduz exatamente o digest inicial. O recibo continua não aprovado; uma repetição com a fonte congelada é necessária. Os rascunhos de probes sob run não são resultados executados.

## Resultado dos fluidos já conferido

A tarefa `potion-id-worldfluid-v2-20260913T184254Z` aprovou os dois boots com fonte inalterada, na campanha `20260913T190936Z-376d7fc889db40e8ba2bf426f3626a20`. Foram conferidos os marcadores de dez fontes persistidas, zero dreno duplicado, três receitas nativas de engarrafamento e três combustíveis nativos. O hash da região confere com o resumo.

O teste do dispenser foi corrigido somente na montagem da fixture: o callback nativo recalcula a orientação ao adicionar o bloco. O cenário agora configura e verifica a face pretendida após esse callback; o log confirmou metadata 3 antes e 5 depois. Não foi alterado o comportamento de produção do dispenser.

Os recibos das repetições finais, do check integral e do cliente são condições adicionais de aprovação; não se presume seu resultado pelo início das tarefas.

## Fechamento da qualificação — 2026-09-14

A ressalva anterior sobre repetições pendentes foi superada pelos gates finais desta seção. A fonte `3ee003103d6d02583499f61c913077d93f4210ff4e25463ad7122aa104eaae6c` passou no check integral, na campanha de fluidos, na campanha de lubrificação e no cliente Angelica. O check contém **489 testes em 74 suítes**, zero falhas/erros/ignorados e Checkstyle main/test zero.

A repetição de fluidos é `20260914T165041Z-6b1ea83bc2a54ec3b79aff9047abb57f`, com dois boots e região SHA-256 `5d727b25b1a1bcab89732794d2280d96e651cec5d831ee44fbc43fe020e77886`. A repetição de lubrificação é `20260914T165257Z-511f76fc14194b9dba8ac8b75b18495f`, com quatro boots/orientações e região SHA-256 `0d50bd9aba932706b72dab43206b0860b65d6068ba3d9ceabce2a7f68021f0d0`.

O cliente qualificado é `run/premium-client-campaign/lubrication-20260913T201458Z-c4b55457c16d48a09bc0b779b594b231`, screenshot SHA-256 `3c07a99d0f818b47259209bd2c179e632b09072ca51d9c739acd25e4e4bc4ec5`. A captura foi inspecionada como fundação de renderer; não é aprovação da arte final.

As tarefas antigas que falharam, foram invalidadas por mudança de fonte ou pararam no menu permanecem FAIL. A evidência consolidada é `run/potion-id-integrity-20260913T184254Z/final-qualification.json`; elas não foram promovidas retroativamente.

O JAR IE preserva SHA-256 `51cf081e5a7c9e92dc9ede65021ba2befbdd17971a070d7f26f8c83839c4ac2e`. `server.properties`, `eula.txt` e `ImmersiveEngineering.cfg` retornaram aos hashes anteriores. Esta aprovação é Forge/Java 8 no laboratório; não aprova Crucible/Java 21, multiplayer autenticado, mundo de produção, shaders ou migração de efeitos antigos já gravados com IDs colididos.

## Requalificação sobre a linha consolidada — 2026-09-14

A correção foi integrada sobre `5bd89e5822c281275492a39decb9e851ff3cdd97`, sem herdar automaticamente os PASS da branch antiga. A fonte combinada teve digest `eb2321b881b5e1ea87ea9ea4588f757611426ec353f31c0ed35c5595383054a5` durante todos os gates.

O check integral passou com **562 testes em 88 suítes**, zero falhas, erros ou ignorados, e Checkstyle main/test sem apontamentos. A campanha World Fluids `20260914T170932Z-ad07692dd9de4dc58ec465d3f639245a` passou nos dois boots; o SHA-256 da região recomputado foi `196e5073d01490edb1e361e2b1152e9fca612e444e1a8ffdbd222b9cff7dfa2f` e confere com o resumo.

A campanha Lubrication `20260914T172423Z-446d61968b31415c9db0c189a235894c` passou quatro boots na mesma fonte, incluindo formação/orientação, quebra, reforma, escrow e drill-oil. O SHA-256 da região recomputado foi `023608fb184a4c584c2af67580a4154e3d60cbdff8c65311cba6ce160ea76766`.

O cliente Angelica `lubrication-20260914T172717Z-ff939ca3c69e4edab23d9c6ae720d59a` passou no mesmo digest; a captura final foi inspecionada e permanece classificada como fundação visual, não arte final premium. `server.properties`, `eula.txt` e `options.txt` retornaram aos hashes do checkpoint anterior. Não houve reescrita do JAR IE, instalação em produção, push ou release.
