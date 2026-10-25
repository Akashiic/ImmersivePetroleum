# Hydrotreater: contrato de rollback de itens pendentes

Data: 2026-09-13. Base: `db6b77d63c91696ed492b8d069d529cda450a9ee`.
Escopo: `HydrotreaterState.restorePending(String,int)`, sem mudança de schema, receitas, ritmo, energia, fluidos, render ou dependências.

## Defeito e decisão

O handoff registrou que a API pública permitia criar itens pendentes sem `pendingDefinition`, mas `write()` emitia schema 2 e `read()` exigia `pendingContract`. Além disso, depois de consumir todos os itens, era possível restaurar outra identidade reutilizando o contrato antigo. A escrita resultante não atendia ao próprio contrato de leitura.

A correção rejeita, antes da mutação, uma restauração positiva que não tenha contrato pago retido ou cujo item divirja desse contrato. Quantidade zero continua sem efeito; limites de quantidade e identidade já existentes permanecem. O contrato retido após `consumePending` continua permitindo desfazer a publicação síncrona de saídas realmente processadas.

Não foi introduzido fallback silencioso para schema 1 nem um contrato inventado para itens arbitrários. Schema 1 real continua usando a migração existente. Chamadas sintéticas sem processo/contrato agora falham imediatamente; isso é uma restrição deliberada da API WIP de rollback, não uma ferramenta genérica de criar inventário.

Os dois usos de produção encontrados em `TileEntityHydrotreater.publishPending` reservam saídas processadas antes do callback e devolvem somente o restante confirmado. A inspeção desses caminhos não substitui execução Forge/Crucible com callbacks reais.

## Reprodução antes da alteração

Seis testes novos foram executados contra a produção original. Resultado XML: **6 testes, 3 falhas esperadas, 0 erros**. Falharam os casos sem contrato, com troca de identidade e com tentativa de recriar reserva depois de reiniciar um estado já esvaziado. Os casos de rollback legítimo, quantidade zero e limites passaram.

Evidência: `run/resume-hardening-20260913T032221Z/red/junit/TEST-flaxbeard.immersivepetroleum.common.machine.hydrotreater.HydrotreaterPendingReservationTest.xml` e logs da mesma pasta. Nenhuma alteração em `src/main` existia quando essa reprodução foi iniciada.

## Preservação da suíte

Os 11 métodos da suíte HydrotreaterStateTest e todas as linhas de asserção anteriores foram preservados. Dois arranjos de teste passaram a produzir um lote real antes de simular cancelamento/capacidade; o limite final de 64 itens e as asserções de conservação permanecem. A nova suíte contém seis métodos adicionais.

## Resultado após a correção

**PASS de domínio e compilação integrada.** `gradlew.bat check --no-daemon` executou sem filtros, com exit code 0 confirmado pelo processo filho, `test` executado (não UP-TO-DATE) e `BUILD SUCCESSFUL`. Os XMLs somam **407 testes em 65 suítes, zero falhas, erros ou ignorados**. Checkstyle main/test: zero apontamentos. A comparação dos nomes de casos preserva todos os 401 casos anteriores e acrescenta exatamente os seis novos.

Evidência final: `run/resume-hardening-20260913T032221Z/green-full/{stdout.log,stderr.log,result.json,junit,checkstyle}`. O manifesto `evidence-summary.json` na pasta da retomada registra os hashes das fontes alteradas, logs e relatórios. Esse gate recompilou a alteração e executou testes; não foi uma campanha de servidor, cliente ou build limpo pós-tag.

## Integridade do processo e limites

O check inicial da base registrou BUILD SUCCESSFUL, mas reutilizou os resultados de testes por cache. O helper de arquivamento dessa rodada teve um caminho Windows mal escapado; a cópia dos relatórios foi recuperada depois que o processo terminou, sem repetir efeitos de produção. Essa execução não é descrita como 401 testes recém-executados.
O helper PowerShell da fase vermelha devolveu ExitCode vazio apesar das falhas explícitas no log/XML. Seu exit code não foi usado para aprovar nada. Uma primeira tentativa do novo helper Python parou antes de iniciar Gradle por chave de ambiente COMSPEC; o resultado foi preservado. O helper corrigido usa o executável absoluto do sistema, timeout e mutex, e conserva o exit code real na evidência final.

A revisão deste patch foi feita pelo mesmo assistente com inspeção adversarial e testes; **não há aprovação independente externa nesta rodada**. A qualificação em Forge real/Crucible Java 21, callbacks, persistência entre boots e integração de receitas permanece pendente. Os gates anteriores de Hydro afetados pelos snapshots não são reabertos como PASS somente por esta suíte.

Coker, colocação Lube/Gas/Flare, campanha completa de lubrificação, hooks Motorboat/NEI/MT, cliente, arte/áudio, multiplayer e desempenho continuam com os limites do handoff. Nenhum JAR ou mundo de produção foi alterado e não foi emitida release.
