# Projector — qualificação de laboratório, 2026-09-14

Base versionada: `fbcb919517bc8631e707abc6c4c19a84150775f1`.
Branch: `feature/projector-qualification-20260914T033754Z`.
Digest qualificado: `7a032173765761ae56977c6342a040563a64bdc738cef4c2e7c63814c2ec6f75`.
Evidência consolidada: `run/projector-resumption-20260914T052335Z/qualification.json`.

## Resultado

A frente passa como **qualificação de laboratório, não release**. O mesmo digest foi usado no check integral, na campanha dedicada e no cliente real. `cleanTest check --no-daemon` produziu **546 testes em 87 suítes, zero falhas, erros ou ignorados**, com Checkstyle main/test em zero. Os 539 casos presentes no início desta retomada permanecem; sete casos foram adicionados.

A campanha `20260914T062744Z-76aa8bdcdc374c70b6a87d0f6e9839c7` passou em três boots. Ela verificou receita/settings server-side, replay/slot/pin, materiais das seis famílias, covered pipe e top slab, construção criativa, eventos Forge, chunks descarregados, cenários adversariais e construção nativa completa dos seis templates.

A matriz de construção formou/colocou **956 células** sob orçamento 7, em Pumpjack, Distillation Tower, Derrick, Oil Tank, Hydrotreater e Coker. Repetir um template já correto não publicou blocos novamente e o item segurado permaneceu inalterado.

O hash da região principal foi reconferido como `709de3d128e630c23b9f4d3fc67dfec807d07e68810caa334e37310f5b47bbc8`. Dezenove arquivos de região do mundo de evidência tiveram SHA-256 registrados no `qualification.json`.

## Falhas reproduzidas antes da correção

`projector-envelope-red-v2-20260914T033754Z` mostrou que settings futuros/estranhos podiam ser tratados como estado conhecido, que o limite de texto não era o mesmo do wire UTF-8 e que um `ProjectorMessage` reutilizado podia reter validação. A leitura agora rejeita campos desconhecidos sem reescrever o NBT, usa o mesmo contrato UTF-8 estrito e recalcula a validade.

`projector-placement-red-20260914T033754Z` preservou a falha de publicação: uma exceção de callback podia deixar a célula recém-colocada. `ProjectorPlacement` congela a propriedade anterior e só restaura a célula que ainda identifica como sua. Substituições ou inventários criados por terceiros não são apagados. O `BlockSnapshot` entregue ao evento não é usado como autoridade de rollback depois do callback.

`projector-gui-owner-red-20260914T052335Z` demonstrou que uma tela antiga aceitava alterações após revisão/posição externas. A GUI e os jobs agora vinculam o contrato completo de `ProjectorSettings`; revisão, token, template, pose, dimensão, âncora, camada e modos participam da identidade.

`projector-template-identity-red-20260914T052335Z` demonstrou leitura repetida de `getUniqueName` e aceitação de nomes incompatíveis com o envelope de 128 bytes. O nome é lido uma vez e validado pelo mesmo `ProjectorText` de save/rede. A comparação do registro usa identidade das fontes, sem chamar `equals` de terceiros.

Todas as quatro execuções negativas permanecem FAIL e não foram reinterpretadas como sucesso.

## Cliente e recursos

A campanha final de cliente `projector-20260914T145651Z-04ad128b701445c99404a36ed788eb40` passou com Angelica. Ela validou 48 poses, 12 telas GUI (modelo e materiais das seis famílias), busca, seleção, rotação, espelho, camada e ownership da sessão. Foram produzidas 13 capturas com hashes verificados.

O reload de recursos liberou 15 display lists e confirmou sua deleção nativa, limpou as views e executou `refreshResources`. O diagnóstico de GL exige restauração de depth/blend/cull/modelview e tem limite para erros pré-existentes; não entra em loop ilimitado.

As 13 capturas foram inspecionadas em contact sheet. Não foi observado corte grosseiro, painel ausente ou template invisível. Isso aprova a fundação visual exercitada; não equivale a aprovação estética final, shaders arbitrários ou todos os idiomas/escala possíveis.

## Preservação do laboratório e limites

`run/server.properties`, `run/eula.txt` e `run/options.txt` conferem byte a byte com os hashes preservados antes desta frente. O JAR IE continua com SHA-256 `51cf081e5a7c9e92dc9ede65021ba2befbdd17971a070d7f26f8c83839c4ac2e`. Nenhum JAR do pack ou mundo de produção foi editado.

O mecanismo não persiste jobs criativos em andamento; após restart, células já corretas são apenas verificadas. Isso é deliberado. O mecanismo não força chunk e não transforma templates genéricos de terceiros em equivalência exata: candidatos genéricos continuam visualmente úteis, mas não recebem certificação verde.

As garantias de rollback cobrem a publicação síncrona exercitada. Um callback que substitui o bloco ou modifica o TileEntity assume aquela célula; o Projector preserva a intervenção em vez de apagá-la. Não existe transação distribuída entre chunks, player save e outros mods numa queda abrupta do host.

A revisão foi feita pelo mesmo assistente com testes adversariais; não há auditor independente externo. Crucible/Java 21, cópia do pack/mundo reais, multiplayer autenticado, shaders adicionais, uso prolongado e benchmark comparável de FPS/TPS permanecem gates separados.

## Progresso

Com esta frente aprovada, a estimativa global sobe conservadoramente de 52% para **53%, faixa de 47–60%**. O incremento reconhece uma família de utilidade com autoridade de servidor, UX, persistência de settings, construção, cliente e materiais exercitados; não é derivado do número de testes. O produto completo continua muito além deste gate.
