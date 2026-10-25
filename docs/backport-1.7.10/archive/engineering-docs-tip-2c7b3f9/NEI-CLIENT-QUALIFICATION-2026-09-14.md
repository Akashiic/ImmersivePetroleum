# NEI — categorias reais, leitura das receitas e integridade da apresentação

Base: `2aed5b574523d89aa6af43e2f3d7bd6f00c3bdb1`. Frente isolada: `feature/nei-qualification-20260913T190723Z`.
Fontes de evidência: `run/nei-resumption-20260913T212403Z` e `run/nei-finalization-20260913T235224Z`.
Escopo desta frente: integração cliente NEI 2.8.125-GTNH e ausência opcional no servidor. Não é release.

## Defeitos reproduzidos e corrigidos

A primeira campanha abria as categorias mas a revisão visual encontrou o ingrediente sólido do Coker sob o rótulo de saídas e conteúdo cortado. A nova asserção nativa falhou antes da alteração em `nei-layout-native-red-20260913T212403Z`. A geometria separa entradas/saídas, acomoda itens junto dos fluidos, mantém rodapé, define quatro colunas e permite rolagem nativa quando necessário. Há testes de geometria com 10 mil layouts, contados como um caso JUnit, não 10 mil testes.

Os títulos `Saídas` e `Item registrado indisponível` continham codificação dupla. Os bytes foram corrigidos e testados como UTF-8. Os nomes exibidos em tooltips para teclas vêm dos bindings reais do NEI; callbacks usam a tecla recebida, respeitam remapeamento e não ativam uma tecla desabilitada. Tooltip de tecla ausente tem tradução explícita.

O envio de metadados por IMC runtime não sustentava os ícones das abas no perfil real. A integração agora participa de `NEIRegisterHandlerInfosEvent`, API confirmada na fonte exata do NEI, e restaura ícones/dimensões após `GuiRecipeTab.loadHandlerInfo`. Registros repetidos do plugin não duplicam handlers.

A inspeção de uma captura encontrou o ciclo de petróleo alternando para `?` quando chegava ao alias opcional `oil`, não instalado no perfil mínimo. A asserção nativa reproduziu isso em `nei-fluid-alias-red-20260913T212403Z`. Somente a lista de apresentação é filtrada por identidade registrada; a receita mantém todos os aliases. Se nenhuma alternativa de uma receita customizada estiver instalada, ela continua visível com sua identidade desconhecida, em vez de desaparecer silenciosamente.

A revisão final identificou que a geração do catálogo era lida depois da construção da lista de cartões. Uma edição entre as duas operações poderia parecer já consumida pelo navegador. O teste de bytecode sobre a classe real falhou em `nei-revision-order-red-20260913T212403Z`: 495 casos, uma falha, nenhum erro. O método agora observa a revisão antes do snapshot. Uma mudança concorrente exige nova atualização no tick seguinte; não se afirma snapshot global atômico entre catálogos independentes.

## Qualificação automatizada

`tools/qualify_nei.py` coordena check integral, quatro perfis (pt_BR/en_US × escalas efetivas 1/2) e servidor dedicado sem NEI. Cada etapa tem identidade, timeout, heartbeat, fonte antes/depois e recibo persistente; alteração de fonte/runner invalida o resultado. A identidade existente não reexecuta etapas. Sete testes operacionais verificam a sequência, recusa de replay, falhas e mudança de código/driver. Esses testes são separados do total JUnit.

Cada cliente deve verificar seis páginas reais, sete consultas, estado GL, adição/remoção com tela aberta, duas ações de mouse, três callbacks de tecla incluindo remapeamento, tecla desativada e metadados após reload. São callbacks no cliente real com NEI/Angelica, não injeção de teclas no sistema operacional ou multiplayer autenticado. Cada perfil exige seis capturas novas com SHA-256. As opções de idioma/escala são alteradas apenas no laboratório e restauradas byte a byte.

O primeiro encerramento após a correção da revisão foi rejeitado: o segundo perfil permaneceu no menu após iniciar o servidor integrado. Dump de threads e captura da janela foram preservados. O Desktop Commander respondia; não se concluiu falha de socket ou causa definitiva do cliente. A solicitação de fechamento normal não encerrou o cliente, então somente o processo próprio do diagnóstico foi encerrado, com verificação posterior. O perfil foi reexecutado isoladamente e passou. A matriz rejeitada continua FAIL; não foi editada para aparentar sucesso. Uma matriz nova foi exigida para aprovação final.

## Resultado final desta fonte

Matriz `nei-certified-20260913T235224Z`: **seis etapas aprovadas**, sem alteração da fonte ou dos runners durante a execução. Digest da fonte: `003298ea2bbc575de23fddf59459f56e2db528c475a36b5e4d68f7062f3f5eff`.

O check executou `cleanTest check --no-daemon` sem filtros: **495 testes, 77 suítes, zero falhas, erros ou ignorados**, Checkstyle main/test zero. O caso de revisão foi incluído nesse total e agora passou; a reprodução negativa anterior permanece arquivada.

As quatro campanhas finais de cliente são `20260914T002025Z-b8ab3136011a46e48f69357f0af60b44` (pt_BR/2), `20260914T002139Z-afa90e8ec4e44efeb73a4110e52f3d88` (en_US/1), `20260914T002242Z-b4aabdb8e285465ea6773e8923aa1427` (pt_BR/1) e `20260914T002350Z-36bbd88562cc4f918664dd9b98a21da8` (en_US/2). Foram conferidos os hashes das 24 capturas e inspecionados os seis painéis em cada combinação. Os elementos observados cabem nos cartões; na escala 1 permanece espaço livre no container nativo do NEI. Não foi declarada aprovação de skins, shaders ou tamanhos de janela arbitrários.

A campanha dedicada sem NEI/MT `20260914T002458Z-876ec2ebdfcb4f8a812b7dafa6ef217e` passou nos quatro boots e preservou os 11 marcadores da torre, incluindo reservas e reinicialização. Seu arquivo de região foi conferido pelo hash do resumo. As opções do cliente, `server.properties` e `eula.txt` foram comparadas aos bytes anteriores e restauradas. O JAR IE fixado mantém SHA-256 `51cf081e5a7c9e92dc9ede65021ba2befbdd17971a070d7f26f8c83839c4ac2e`.

Consolidação: `run/nei-finalization-20260913T235224Z/qualification.json`; recibos por etapa em `run/guarded-tasks`; matriz final em `run/nei-qualification-matrix/nei-certified-20260913T235224Z/result.json`.

## Limites preservados

As campanhas usam o cliente de desenvolvimento com NEI/CodeChickenCore fixados, Angelica/GTNHLib e IE. Não são homologação de Crucible/Java 21, do pack completo com UniMixins/Hodgepodge, de mundo de produção ou de multiplayer autenticado. A front-end de receitas não altera as receitas nem preenche funcionalidades de produção ainda ausentes. O Coker ainda usa somente a receita fixa no checkpoint desta frente; receitas customizadas pertencem à próxima implementação.

A revisão visual, de código e das evidências foi feita pelo mesmo assistente; não há auditor independente externo alegado. O evento que deixou um cliente no menu não teve causa raiz conclusivamente identificada e não foi apagado dos resultados. Não houve push, release ou instalação em produção.

Estimativa global após esta frente: **aproximadamente 51%, faixa de 45–57%**, para o produto completo. O pequeno aumento reconhece integração e apresentação verificadas, não a quantidade de testes. Trata-se de julgamento de engenharia, não de medição de tempo restante ou aprovação integral de 51% das famílias.
