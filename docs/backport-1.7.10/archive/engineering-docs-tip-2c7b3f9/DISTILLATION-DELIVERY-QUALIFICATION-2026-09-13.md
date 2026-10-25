# Distillation Tower — entrega persistente de subprodutos

Base versionada: `926c17e4840d603431f16fea63ebf563dcf28095`. Data: 2026-09-13.
Evidência consolidada desta integração: `run/delivery-integration-20260913T164121Z`.

## Defeito e reprodução preservada

O adaptador anterior ignorava o retorno de `World.spawnEntityInWorld` e descartava a quantidade produzida mesmo quando o evento nativo recusava o item. A fonte Forge fixada confirma esse retorno de recusa em `build/rfg/minecraft-src/java/net/minecraft/world/World.java`. O teste nativo anterior à integração falhou em `tower-delivery-native-red-20260913T144218Z`, campanha `20260913T154821Z-711680d679704b1e807dc6260eaaa59c`. O mundo e os logs foram preservados.

O checkout já continha o ledger, codec, adaptador e seus testes como WIP. Foram preservados antes de integrar. O gate anterior de domínio tinha 466 testes/72 suítes, mas não certificava sua utilização pelo TileEntity.

## Contrato integrado

A torre conserva uma única leva de produtos já sorteados. A conclusão do processo registra essa leva e marca o estado antes de chamar inventários ou publicar entidades. Enquanto a leva existir, não admite outro processo; tentar entregá-la novamente não repete receita, RNG, consumo de fluido ou RF. Recusas confirmadas mantêm os itens; confirmações parciais removem somente a parcela entregue. Exceção ou confirmação inconsistente preserva incerteza e bloqueia repetição automática.

O adaptador utiliza as APIs reais IE/Forge, verifica identidade de item/NBT, quantidade e identidade do dono/destinatário. Há no máximo 16 iterações de entrega por chamada, podendo cada iteração consultar inventário e publicar um restante; não se declara um teto de 16 callbacks. A apresentação e as receitas não foram alteradas.

`deliveryState` é um envelope separado schema 1; os saves antigos sem esse campo permanecem válidos. Tipos errados e dados futuros ficam opacos em quarentena. Snapshot IN_FLIGHT recarrega como UNCERTAIN, nunca como autorização para repetir. Partes dummy não podem assumir uma leva. A simulação, as portas e a quebra normal não reentram uma entrega em andamento.

A quebra normal pelo jogador recusa dono inválido, entrega pendente ou quarentena. Na remoção externa forçada de mestre/parte com estado não conciliado, `DistillationRecoveryRecord` conserva um registro por dono na `perWorldStorage` da dimensão. O nome é logado. Esse registro é evidência, não item de resgate, ferramenta automática ou autorização para reemitir recursos. Não há novo registro de item/TileEntity. A restauração estrutural não sobrescreve uma célula cuja identidade já mudou.

## Gates da fonte

Último check da fonte desta integração: `tower-delivery-complete-check-v2-20260913T164121Z`.
`cleanTest check --no-daemon`, sem filtros: **475 testes em 73 suítes, zero falhas/erros/ignorados; Checkstyle main/test zero**. Todos os 466 casos anteriores permanecem, com nove novos casos do dono/persistência/registro diagnóstico. Os 25 testes do ledger e 12 do codec são parte do total, não contagens adicionais. Uma campanha aleatória de 250 mil operações integra um dos testes, não 250 mil testes.

Digest da fonte na execução final: `42cde7a42afd3fb6b186ab14389a12bcbc3ae1bb50612d0553e1dd1f37dfcdce`, inalterado entre início e fim. O primeiro check do probe novo falhou por nome de API do relógio; foi corrigido para o método comprovado `WorldInfo.incrementTotalWorldTime`, somente na fixture. A falha permanece arquivada.

## Campanhas nativas aprovadas

A campanha final da torre é `20260913T173958Z-a433670e954c4cc9817a0f585ed9d814`, recibo `tower-delivery-complete-runtime-20260913T164121Z`. Os quatro boots passaram com fonte inalterada. Os probes anteriores de NBT, material, orientação e funcionamento permaneceram obrigatórios, junto dos novos marcadores.

No cenário simples, cinco pedras recusadas pelo EntityJoinWorldEvent foram retidas, entregues no tick seguinte uma única vez, sem novo débito de 100 RF/100 mB de entrada nem alteração dos 40 mB de saída. No cenário adversarial, foram exercitados reentrada do tick, tentativa de quebra nativa durante callback, snapshot em publicação, exceção após entidade realmente inserida e exceção após inventário nativo receber cinco itens. Os estados incertos impediram nova publicação após recarga NBT. Esses casos usam fixtures de servidor, não jogadores autenticados.

Uma torre adicional de 137 partes foi formada em área isolada e alimentada pelas portas reais. O primeiro boot conservou cinco itens pendentes; o segundo entregou os mesmos cinco; o terceiro encontrou os cinco itens persistidos, sem recriar a pendência nem repetir entrega. Outras duas torres foram removidas externamente pelo mestre e por uma parte. A quebra normal durante pendência foi recusada, a substituição por bloco de diamante permaneceu e dois registros diagnósticos foram relidos no boot seguinte com o payload exato. Os arquivos de região e os dois `.dat` de recuperação foram hasheados. Os registros não foram executados como restauração de recursos.

A campanha básica `20260913T164925Z-0c3bb34446b14834a22b6680902cca7a` e a adversarial intermediária `20260913T171520Z-054b4259ba2c466cb00103ba96b85567` também passaram. Elas pertencem a fontes anteriores; somente a campanha final certifica todos os cenários acima na fonte final.

Regressão Hydrotreater: `20260913T175519Z-83b78f6dff2440f498034ad1f26e8804`, quatro boots PASS, sem dependências opcionais de receitas adicionadas. A primeira tentativa foi rejeitada pelo controlador após o write nativo passar; conservou-se o handle antes de esperar pelo processo e adicionou-se recusa explícita de ExitCode ausente. O teste operacional confirmou saídas reais 0 e 7. A tentativa inicial continua FAIL, não foi promovida a PASS.

Regressão com MineTweaker: `20260913T180018Z-54a090a23eed4c04abe64119a32649e9`, dois boots PASS com CT 3.4.8 e o IC2 fixado do perfil. Substituição, undo, snapshots e conclusão sem os scripts sintéticos passaram. A exceção conhecida de nomes de tipos do CT continua classificada; IC2 não se tornou dependência do Petroleum.

Os logs finais da torre/Hydro/receitas não contêm os dois marcadores fatais FML exigidos pelos runners. Isso não significa ambiente sem avisos. `server.properties` e `eula.txt` foram conferidos contra os bytes anteriores e restaurados. O JAR IE preserva o SHA-256 fixado. Recibos e hashes consolidados ficam em `qualification.json` e nos três arquivos `*-runtime-audit.json` da pasta desta integração.

## Limites e próximas verificações

Revisão e inspeção executadas pelo mesmo assistente; nenhuma revisão independente externa é alegada. Não foram executados cliente, shaders, áudio, Crucible/Java 21, mundo de produção, pack completo, multiplayer autenticado ou benchmarks por esta integração. Nenhum ganho de FPS/TPS é atribuído ao patch.

O protocolo de saída de fluidos da torre e a qualificação estrutural completa continuam exigindo inspeção própria: retorno de publicação do material estrutural, falha de restauração, estruturas parcialmente descarregadas e fronteiras com callbacks externos arbitrários não estão universalmente aprovados por estes testes. O registro diagnóstico preserva o estado disponível do dono; não torna saves de jogador, chunks, entidades e WorldSavedData atomicamente consistentes numa queda abrupta do host.

O progresso global continua estimado em cerca de 50%, faixa de 45–55%, sobre o escopo completo. A correção fecha um bloqueio concreto de integridade; não representa uma nova família premium inteira entregue. Não houve release, push ou instalação em produção.
