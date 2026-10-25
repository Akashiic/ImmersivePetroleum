# Garrafa de gasolina e Molotov — qualificação de laboratório

Base versionada: `3d645b5cf1525c440f195c2cb891276d841df3dd`.
Branch: `feature/molotov-qualification-20260914T1205`.
Fonte aprovada: `e2db4299a93d7bb2e6936641119e198d3f847de853bc6b0d9662cdf364d8e681`.
Evidência consolidada: `run/molotov-resumption-20260914T1205/final-qualification.json`.

## Gates aprovados

A mesma fonte passou `cleanTest check --no-daemon`, dois boots dedicados e o cliente premium. O check final contém **548 testes em 87 suítes**, zero falhas, erros ou ignorados e Checkstyle main/test sem apontamentos.

A campanha de servidor final é `run/molotov-campaign/20260914T163031Z-71e65826538d4c2399ea46baf6241097`. O primeiro boot verificou crafting, recipiente de 250 mB, ignição de 20 ticks, pavio de 300 ticks, inventário cheio, troca de isqueiro, publicação cancelada/reentrante e callbacks de fluido incertos. O segundo boot verificou persistência do pavio, journal incerto, projétil salvo, impacto terminal único, dano atribuído, água, gamerule, proteção, portal/MultiPlace e fronteira de chunk descarregada.

O arquivo de região declarado pela campanha foi relido com SHA-256 `20bfcd9bc31f1b0f75bca4b584a9443f2b72affff592cacebf84bfcec2e771c1`. Nenhum marcador FML fatal exigido pelo runner aparece nos logs finais.

O cliente final é `run/premium-client-campaign/molotov-20260914T163251Z-f5e0914edceb4b6aaba6b47708aa6461`. Foram executadas 12 chamadas de renderização (três itens por quatro contextos), Angelica estava carregado e os estados CULL/TEXTURE/LIGHTING/BLEND/DEPTH foram restaurados. A captura única possui SHA-256 `bae0e4d97a77998ee7aa76df347581cb70dd913d44fcfc628f1cd06045e4d1a6`.

A captura foi inspecionada: as três variantes estão visíveis e o Molotov aceso aparece em primeira pessoa sem corte evidente. Isso aprova a fundação visual observada, não a arte ou a validação auditiva premium final.

## Falhas reproduzidas e classificação

Três falhas da campanha inicial eram defeitos da fixture, não do item. O ator sintético chamava `EntityPlayer.onUpdate()` sem o `++ticksExisted` feito por `World.updateEntities`, portanto a ignição acumulava apenas um tick. Depois disso, ticks manuais também permitiam queda e morte do ator, fazendo `EntityPlayer.onDeath` derrubar o inventário. Um diagnóstico temporário ainda chamou `getItemInUse`/`getItemInUseCount`, métodos `@SideOnly(CLIENT)` inexistentes no servidor dedicado. As três causas foram confirmadas em fonte/log e removidas; nenhuma foi convertida artificialmente em patch de produção.

A fixture final incrementa `ticksExisted` como o tick nativo e mantém o ator na célula segura durante a simulação. As campanhas inválidas e seus mundos/logs permanecem preservados e não são contados como PASS.

Dois problemas de persistência eram reais. `MolotovState` aceitava campos desconhecidos com schema 1 e poderia apagá-los na próxima gravação. O envelope superior de `MolotovWorldData` tinha a mesma lacuna. Dois testes negativos foram executados antes do patch: nove testes, duas falhas esperadas. Ambos os codecs agora preservam o compound incompatível integralmente em quarentena.

O projétil possuía a mesma categoria de problema: um campo futuro ou um booleano byte diferente de 0/1 era interpretado como estado conhecido. A campanha negativa `molotov-projectile-envelope-red-20260914T1205` falhou antes do patch. `EntityMolotov` agora exige o conjunto exato de campos e booleanos estritos; o boot final registrou `MOLOTOV_PROJECTILE_ENVELOPE_PASS future=true strictBoolean=true opaqueRoundtrip=true`.

## Transações e conservação

O item aceso conserva uma reserva persistente antes de publicar o projétil. Recusa comprovada pode devolver o item; callback que lança exceção ou produz confirmação incompatível mantém evidência incerta e não autoriza repetição/refund automático. A mesma regra vale para a transferência de 250 mB de gasolina e para devoluções que precisem cair como `EntityItem`.

O uso com inventário cheio aborta sem consumir Molotov ou danificar o isqueiro. A ignição empilhada converte exatamente uma unidade em item aceso e conserva a sobra num slot compatível. Trocar o isqueiro durante a carga invalida a operação. A contagem do pavio é relativa a ticks de inventário, não ao relógio do mundo; baú e jogador desconectado pausam esse caminho.

O impacto é terminal e idempotente. O projétil não carrega chunks para procurar colisões ou fogo, e uma fronteira descarregada pausa seu avanço. A propagação inicial de fogo visita somente a componente de ar dentro de raio quadrado nove. Proteção de colocação, proteção de dano e `mobGriefing` continuam contratos independentes.

## Integridade operacional e limites

`server.properties`, `eula.txt` e `options.txt` foram comparados por SHA-256 com o checkpoint anterior e restaurados exatamente. O runner de cliente específico passou a delegar ao runner premium comum; a evidência usa diretório único, screenshot único e hash, sem sobrescrever capturas anteriores. Os runners exigem ExitCode real e encerram somente os processos que criaram.

Esta qualificação usa um `EntityPlayer` sintético sem conexão autenticada; isso não demonstra uma sessão multiplayer real. O JAR IE fixado não foi alterado. Não foram qualificados nesta frente Crucible/Java 21, modpack completo, cópia de mundo de produção, shaders, escuta humana dos sons, medição de FPS/TPS/rede ou consistência atômica de arquivos distintos numa queda abrupta do host.

A revisão foi feita pelo mesmo responsável técnico com testes e inspeção adversarial; não é apresentada como auditoria independente externa. Nenhum artefato foi promovido para produção e não foi emitida release.
