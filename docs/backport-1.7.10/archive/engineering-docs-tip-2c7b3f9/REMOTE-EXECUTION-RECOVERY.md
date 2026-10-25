# Execução remota recuperável

O transporte MCP não é o dono da conclusão de um build ou campanha. A evidência fica no computador, em `run/guarded-tasks/<id>`, com comando, PID, horários, heartbeat, logs e resultado. O identificador nunca é reutilizado: uma segunda execução retorna 73 antes de iniciar outro filho, inclusive quando existe uma pasta de início incompleto.

`tools/guarded_task.py` executa um comando local explícito, grava stdout/stderr diretamente em arquivos e publica um heartbeat curto durante a execução. A consulta `python -B tools/guarded_task.py <id> --status --tail stderr` limita a cauda a 2048 bytes. O digest das fontes/arquivos Gradle é comparado antes e depois; divergência impede interpretar o resultado como um gate da fonte congelada.

## Interpretação de estado

- Heartbeat recente: o supervisor local respondeu; não prova que o programa filho esteja progredindo.
- Heartbeat antigo: requer inspeção de PID, horário de criação, filhos e logs; não autoriza matar ou repetir automaticamente.
- Pasta/resultado ausente: pode haver atraso antes de o Python inicializar. Conferir o PID do lançamento e seu comando antes de qualquer nova ação.
- `completed`/exit 0: significa somente que o comando retornou zero. Campanhas Minecraft ainda exigem marcadores de domínio, ausência de erro FML, restauração de configuração e fonte correspondente.
- `failed`, `timeout` ou `cleanup_failed`: preservar dados. Não transformar BUILD SUCCESSFUL em aprovação e não reutilizar o mesmo ID.

## Recuperação do canal

Após uma chamada retornar erro de transporte, abandonar aquela operação grande. Fazer `ping`; quando necessário consultar `list_devices` e resolver novamente o dispositivo autorizado. Reconsultar o estado local salvo e os processos antes de retomar. Usar apenas intervalos curtos de arquivos, buscas limitadas e caudas de logs. Não reiniciar Desktop Commander nem encerrar processos de outros chats para recuperar este projeto.

O conector não oferece aqui uma operação explícita de reconexão de socket. O procedimento depende do retorno do controle e de o serviço voltar a aceitar chamadas; um script do projeto não pode garantir recuperar uma chamada MCP que ainda não devolveu o controle. O heartbeat preserva observabilidade do trabalho local, não substitui o canal.

## Isolamento

As campanhas continuam usando `Global\ImmersivePetroleumRuntimeProbe`. O supervisor não toma esse mutex do filho. Nunca iniciar duas campanhas simultaneamente nem modificar fontes enquanto uma campanha compila/executa. O timeout externo deve ser maior que os timeouts internos mais a limpeza.

O timeout externo encerra somente a árvore do filho explicitamente criado por essa tarefa. Como encerramento forçado pode impedir um finally, conservar antes da execução cópias de server.properties/eula e seus hashes; revalidá-los depois. Nunca restaurar cegamente sobre uma campanha diferente. Os testes operacionais usam apenas diretórios temporários e processos sintéticos.

## Falhas de identidade da fonte

Se o comando retornar zero, mas a fonte mudar durante a execução ou a verificação final ficar ilegível, o supervisor registra `source_changed` e retorna 74, em vez de aprovar aquela fonte. A falha da leitura final também fica no recibo; não impede sua gravação normal. O sucesso de um comando que já retornou erro nunca é inventado por esse tratamento.

A consulta de status calcula a idade do heartbeat. Após 15 segundos sem atualização em starting/running, sinaliza `heartbeat_stale`; é um alerta para inspeção, não uma ordem de matar, reiniciar ou repetir a operação. Tarefas concluídas não são classificadas como travadas apenas por serem antigas.
