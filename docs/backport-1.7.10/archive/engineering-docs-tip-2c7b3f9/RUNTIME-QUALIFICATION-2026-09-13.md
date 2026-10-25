# Qualificação de runtime — continuidade de 13/09/2026

Base: `6339c7129c1a119f1d4022d6d95720e67688a4e3`. Branch: `feature/runtime-qualification-20260913`.
Evidência operacional e backups: `run/runtime-qualification-20260913T035724Z`.
Este relatório atualiza os subgates abaixo; não é release nem aprovação de Crucible/Java 21, cliente, multiplayer ou modpack completo.

## Coker default — campanha de quatro boots PASS

Campanha `coker-multiblock-campaign/20260913T044413Z-689a06f42a51465caf918d7c047de439`: write, verify-cycle, verify-break e orientation-matrix, sem filtro. Conclusão `COKER_UNIT_MULTIBLOCK_CAMPAIGN_PASS`. A falha anterior foi reproduzida e isolada no relógio congelado da fixture, sem alterar a lógica da máquina nem reduzir os 256 petcokes esperados; detalhes em COKER-PERSISTENCE-DIAGNOSIS-2026-09-13.md.

Região SHA-256: `259ecc01524f3d8ad8975c1c1e7d163da83379111532a3e8c5308de497be4bd3`.

## Lubrificação — campanha de quatro boots PASS

Campanha `lubrication-campaign/20260913T044657Z-ffabfd460f3847fcaa4c42dc6cee2072`: write, verify-break, verify-reform e orientation-matrix, sem filtro. Conclusão `LUBRICATION_CAMPAIGN_PASS`.
A fixture FLAT escrita antes do handoff foi finalmente executada, sem a colisão anterior do Crusher. O write também exige agora o marcador dos seis casos de colocação real via ForgeHooks. Há evidência separada do NBT de fluido, processamento nativo 8/10 ticks e upgrade da furadeira; não confundir a fixture de Excavator/BucketWheel com formação nativa completa do Excavator.

Região SHA-256: `ae47dd332010fbd18672af2f3474e917566e2b180c65d8e5eace891886e59841`.

## Infraestrutura de execução corrigida

Um teste isolado com processos retornando 0 e 7 comprovou que Start-Process sem preservar o handle entregava ExitCode vazio neste ambiente. Com `$proc.Handle` preservado antes da espera, ambos os códigos foram recuperados corretamente. Os runners Coker, Lube, Gas e Flare foram corrigidos; todos os marcadores/asserts anteriores foram mantidos. Evidência `process-exit-verification.log` na pasta operacional.

O supervisor novo, descrito em REMOTE-EXECUTION-RECOVERY.md, conserva estado/heartbeat/resultado em disco e recusa IDs repetidos. Cinco testes operacionais passaram: código de falha, execução única, pasta incompleta, cauda limitada de log grande e timeout/limpeza do filho próprio. Isso não prova reconexão automática de um socket MCP que não devolveu controle.

## Gas Generator: investigação inicial preservada

Os seis cenários de colocação passaram. Após reparar a chamada SRG do relógio da fixture pela API WorldInfo já comprovada, write e verify-break avançaram; verify-reform encontrou falha no teste de fronteira do cabo. A campanha inteira permanece não aprovada até diagnóstico e contraprova. As evidências rejeitadas não foram apagadas.

## Gas Generator — campanha de três boots PASS

Campanha `gasgenerator-multiblock-campaign/20260913T050929Z-0fd6cb3bf1ea4472a03b1ae487598332`: write, verify-break e verify-reform. Conclusão `GAS_GENERATOR_CAMPAIGN_PASS`.
A instrumentação mostrou que a montagem da fixture carregava o chunk vizinho antes da medição; os quatro ticks preservavam 1.000 RF e não aumentavam o número de chunks. A fixture passou a descarregar esse vizinho pela API nativa e exigir sua ausência antes de testar deferral/resumption. Nenhuma regra de consumo ou transferência do gerador foi alterada por essa correção.

Região SHA-256: `d27e6812019d0347ce94f6a108f2dfcaddfa7b5971e93ce8b9b3846acf505254`.

## Flarestack — campanha de três boots PASS

Campanha `flarestack-multiblock-campaign/20260913T051904Z-3dc5e59d5780450697e4bf9f20981bcc`: write, verify-break e verify-reform. Conclusão `FLARESTACK_CAMPAIGN_PASS`. Os seis casos de colocação nativa são obrigatórios no write. A chamada do relógio no probe também usa WorldInfo, evitando o nome SRG inexistente no runtime carregado.

Região SHA-256: `991dede29ccd22ca5b17480fd29b945f05920a862ba90c2ba44f05d3dd42c42d`.

## Compatibilidade dos avisos com jogadores simulados

O primeiro write do Flarestack passou na colocação e falhou com NullPointerException ao notificar FakePlayer pelo método de ICommandSender `addChatMessage`. A fonte Forge alvo confirma que FakePlayer sobrescreve `addChatComponentMessage`, não o anterior. EntityPlayerMP envia o mesmo S02PacketChat em ambos os caminhos para jogadores reais.
Os 13 avisos server-side dirigidos a EntityPlayer foram migrados para `addChatComponentMessage`, incluindo os avisos equivalentes de Gas, Oil Tank, Hydro, Projector e Survey. O aviso estritamente cliente não foi alterado. Não houve captura genérica de exceções para esconder a falha. A campanha Flarestack corrigida passou; as demais frentes ainda precisam dos seus próprios cenários de interação aplicáveis.

As quatro famílias representam 14 boots aprovados em campanhas distintas, com escopos e identidades conservados. Isso não transforma o conjunto inteiro do addon em release. Os marcadores de teste e hashes dos mundos são evidências dessas execuções, não invariantes entre mundos ou versões.

## Gate integrado da fonte

`cleanTest check --no-daemon` executou a suíte completa novamente, sem filtros: **407 testes, 65 suítes, zero falhas/erros/ignorados e zero Checkstyle main/test**. `test` foi executado, não reaproveitado por cache. O supervisor registrou exit 0 e fonte inalterada em `run/guarded-tasks/runtime-source-check-20260913T035724Z/result.json`. XMLs conservados na pasta operacional em `runtime-junit-407` e `runtime-checkstyle`.

A revisão final do supervisor passou **sete testes operacionais**, incluindo os dois adicionais de alteração da fonte e falha da leitura final sem perder o recibo. Evidência `guarded-tool-tests-final.log`. Esses testes Python são contados separadamente dos 407 JUnit.

Os hashes de server.properties e eula.txt coincidiram com as cópias anteriores após as campanhas. As execuções rejeitadas, logs, mundos e fontes diagnósticas intermediárias foram preservadas. Não houve instalação em produção, atualização de dependência ou release.

A inspeção foi realizada pelo mesmo assistente, acompanhada por testes adversariais e execuções reais; não é apresentada como auditoria independente externa. O estado completo de fonte/evidências desse checkpoint fica em `runtime-evidence-summary.json` na pasta operacional.
