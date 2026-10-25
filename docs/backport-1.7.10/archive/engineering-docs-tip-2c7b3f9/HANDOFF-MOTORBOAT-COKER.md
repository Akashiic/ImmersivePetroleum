# Transferência: Motorboat e próxima etapa do Coker

Data: 2026-09-12. Responsável desta frente: `/root/derrick_runtime`.
Checkout: `C:\Users\User\Desktop\Codex\immersivepetroleum-backport\work\ImmersivePetroleum-1.7.10`.

## Congelamento e aprovação

O cliente pediu transferência antes do limite de uso. O coordenador determinou congelar Java, testes e Gradle, escrever este documento e não iniciar receitas customizadas do Coker. Essa ordem está aplicada. Motorboat permanece WIP: a compilação isolada e os testes de domínio passaram, mas não houve campanha integrada de servidor nem cliente desta família. Não está homologado para distribuição ou mundos de jogadores.

O root concluiu o **fullcheck consolidado sem filtro: PASS**, com **401 testes em 64 suítes, zero falhas, erros ou skips; Checkstyle zero**. A compilação cobre o estado Motorboat congelado; hooks e runtime continuam pendentes. Log: `run/handoff-full-check.log`, SHA-256 `afaea4ac837b6a51e2e50096f16a9db6cc918d04e320090764a05841fe1e0f69`, resultado informado pelo coordenador após este documento ser escrito. Esse gate prevalece sobre a compilação isolada abaixo.

Nenhum Gradle, servidor ou cliente foi iniciado por este subagente. Todos os processos próprios rastreados encerraram: sessões de `javac`/JUnit `73799`, `80233`, `15222` e consultas `javap` `1815`, `96451`. Não há processo próprio pendente conhecido.

## Arquivos que devem ser preservados

Os arquivos Motorboat são novos/untracked no momento da transferência. Copiar apenas o diff de arquivos rastreados perderia a implementação.

| Caminho relativo ao checkout | Conteúdo |
| --- | --- |
| `src/main/java/flaxbeard/immersivepetroleum/common/motorboat/` | `MotorboatUpgrade`, `MotorboatFuels`, `MotorboatState`, `MotorboatPhysics`, `MotorboatTransactions`, `ItemMotorboatUpgrade`, `ItemMotorboat`, `MotorboatContent`, `MotorboatInputMessage`, `MotorboatNetwork`, `EntityMotorboat`, `EntityMotorboatSeat`, `MotorboatServerProbe` |
| `src/main/java/flaxbeard/immersivepetroleum/client/motorboat/` | `MotorboatRenderer`, `MotorboatItemRenderer`, `MotorboatSound`, `MotorboatClient`, `MotorboatRendererProbe` |
| `src/test/java/flaxbeard/immersivepetroleum/common/motorboat/` | `MotorboatStateTest`, `MotorboatPhysicsTest` — 19 testes |
| `tools/run-motorboat-campaign.ps1` | Três boots; UUID para mundo/logs; mutex compartilhado; restauração exata de properties/eula/env; processos Hidden e timeout |
| `tools/run-motorboat-client-probe.ps1` | Cliente GL/áudio opt-in; UUID para logs; mutex, restauração de env e encerramento limitado do processo próprio |
| `docs/ADR-MOTORBOAT.md` | Fontes congeladas, contratos e decisões de adaptação |

O Coker existente, os fixes anteriores de Hydro/Oil e os scripts de outras campanhas foram congelados antes desta frente. Não sobrescrever as correções posteriores do root ou de `/root/derrick_audit`.

## Implementação Motorboat existente

- Lancha com três slots reais de `IUpgradeableTool`/`IInternalStorageItem` do IE 0.7.9; cinco upgrades: casco reforçado, quebra-gelo, tanque, lemes e remos. Seis receitas copiadas semanticamente das definições congeladas, usando materiais IE 1.7.10 verificados por API.
- Combustíveis imutáveis por configuração: gasolina 1 mB/tick, nafta e benzol 2 mB/tick. Tanque 8000/16000 mB. Remover o upgrade mantém o excedente de combustível até 16000 mB; não permite novo abastecimento acima da capacidade reduzida, não cria recipiente e não descarta volume.
- Estado com tipos NBT estritos, rejeição/preservação de payloads futuros ou malformados, inventário sem upgrades duplicados, identidade/tag de fluido e tags de upgrades copiadas. Publicação incerta bloqueia novas operações.
- Equações de direção, aceleração, ré, boost e remos em domínio sem callbacks; adaptação explícita de flutuação 1.12.2. Entidade direta com movimento e consumo calculados pelo servidor, interpolação cliente e verificações de chunks já carregados antes das consultas de colisão.
- Mensagem fixa de sete bytes: entity ID, sequência de 16 bits e cinco bits de entrada. Não recebe coordenadas, velocidade, combustível nem upgrades. Apenas o motorista autenticado é aceito; replay é rejeitado; controles expiram após dez ticks. Fila coalescida com no máximo 128 jogadores e 32 despachos por tick; o handler Netty não lê mundo.
- Segunda entidade de assento representa o segundo passageiro no modelo de montaria única da 1.7.10. Associação persistida por UUID, identificação visual por DataWatcher, procura local limitada a chunks carregados e promoção do passageiro quando o motorista sai.
- Abastecimento da lancha colocada aceita recipientes Forge/IE reais. Callbacks recebem cópias; valida quantidade, remanescente após dreno, saída unitária, referências/NBT do inventário original e reentrada antes do commit. O item guardado não implementa capacidade de fluido, conforme o contrato moderno lido.
- Coleta por dano preserva combustível/upgrades; entrega ao inventário vazio do atacante disponível ou publica EntityItem com retorno verificado. Cancelamento confirmado conserva a entidade. Exceção ou mutação do payload bloqueia retry e sela o estado/saída. Falhas externas arbitrárias não foram executadas em runtime.
- Geometria original do casco, motor, hélice e cinco upgrades. Item renderer próprio. Som referenciado do IE instalado (`immersiveengineering:dieselGenerator`), sem copiar gravação ou assets modernos.

## Hooks de integração ainda faltantes

Na leitura feita para este documento, `ImmersivePetroleum.java` e `ClientProxy.java` ainda não continham chamadas Motorboat. A configuração compartilhada já contém `enableMotorboat` e `motorboatFuels`. O root pode integrar durante o fullcheck; verificar o estado atual antes de adicionar duplicatas.

1. Após ler a configuração, antes de registrar receitas: `MotorboatContent.configureFuels(PetroleumConfig.motorboatFuels)` e `MotorboatContent.preInit()`.
2. No init comum, após materiais/IE disponíveis: `MotorboatContent.init()`.
3. No init cliente: `MotorboatClient.init()`. Esse método já registra os renderers e, se solicitado pela propriedade, o probe cliente.
4. No server started: `MotorboatServerProbe.runIfRequested(server)`.
5. No server stopped: `MotorboatNetwork.clearServer()`.

`MotorboatContent.preInit()` registra também a rede. IDs locais reservados: **60 Motorboat, 61 MotorboatSeat**. Itens: `immersivepetroleum:motorboat` e `upgrade_reinforced_hull`, `upgrade_icebreaker`, `upgrade_tank`, `upgrade_rudders`, `upgrade_paddles` no mesmo namespace. Não há GUI ID adicional.

O helper novo do root `client.audio.PetroleumSoundLifecycle` **não foi conectado à família Motorboat**. Integrar cleanup registrado via `register(Runnable)`: encerrar/parar todos os loops e limpar o mapa `MotorboatClient.SOUNDS` em reload/world cleanup. Retentativa do mixer sem reload deve ser limitada (proposta do root: 40 ticks) e condicionada ao volume master habilitado (`enabled()`). Hoje F3+T ou `SoundHandler.stopSounds()` pode parar a reprodução sem marcar `MovingSound.donePlaying`, deixando uma entrada que impede o reinício. Isso é pendência concreta de lifecycle, não uma aprovação de áudio.

O manual Motorboat já foi acrescentado pelo root aos dois langs. As chaves específicas de item/tooltip abaixo ainda não estavam presentes na leitura; integrar sem apagar entradas existentes:

```properties
# en_US.lang
item.immersivepetroleum.motorboat.name=Motorboat
item.immersivepetroleum.motorboatUpgrade.reinforced_hull.name=Reinforced Hull
item.immersivepetroleum.motorboatUpgrade.icebreaker.name=Icebreaker
item.immersivepetroleum.motorboatUpgrade.tank.name=Expanded Fuel Tank
item.immersivepetroleum.motorboatUpgrade.rudders.name=Rudders
item.immersivepetroleum.motorboatUpgrade.paddles.name=Emergency Paddles
desc.immersivepetroleum.motorboat.empty=Empty
desc.immersivepetroleum.motorboat.retainedFuel=Excess fuel retained; consume it before refilling.
desc.immersivepetroleum.motorboat.quarantined=Preserved state requires recovery; operation is blocked.

# pt_BR.lang
item.immersivepetroleum.motorboat.name=Lancha a motor
item.immersivepetroleum.motorboatUpgrade.reinforced_hull.name=Casco reforçado
item.immersivepetroleum.motorboatUpgrade.icebreaker.name=Quebra-gelo
item.immersivepetroleum.motorboatUpgrade.tank.name=Tanque de combustível ampliado
item.immersivepetroleum.motorboatUpgrade.rudders.name=Lemes
item.immersivepetroleum.motorboatUpgrade.paddles.name=Remos de emergência
desc.immersivepetroleum.motorboat.empty=Vazio
desc.immersivepetroleum.motorboat.retainedFuel=Excedente preservado; consuma antes de reabastecer.
desc.immersivepetroleum.motorboat.quarantined=Estado preservado para recuperação; operação bloqueada.
```

Se a família GasolineBottle do root estiver integrada, registrar sua equivalência de 250 mB de gasolina para `Items.glass_bottle` no `FluidContainerRegistry` permite usar a interação genérica existente. Não foi adicionada API especial de garrafa nesta frente.

## Evidências isoladas e limites exatos

Foram usadas APIs do **`build/rfg/recompiled_minecraft-1.7.10.jar`**, não nomes do cache Unimined. O IE deobf usado está em `C:\Users\User\.gradle\caches\transforms-3\e74b440530ec06cf6611f404459f129a\transformed\ImmersiveEngineering-garden-cloche-test-2-deobf.jar`.

Compilação isolada: `javac -encoding UTF-8 -source 8 -target 8 -proc:none`, incluindo todos os fontes sob `common/motorboat`, `client/motorboat`, os dois testes e a configuração compartilhada, com classpath do JAR RFG, classes locais já compiladas, IE, Netty 4.0.10, LWJGL 2.9.4, Authlib 1.5.21, Guava 17, Log4j API, JUnit 4.13.2 e Hamcrest. Destino separado; nenhum output de produção foi sobrescrito.

| Evidência | Resultado |
| --- | --- |
| `run/motorboat-api-check/2c34c03aaf6c4c96832dc7f9504d8d0b` | Compilação isolada PASS e `JUnitCore MotorboatStateTest MotorboatPhysicsTest`: **OK (19 tests)**, 0,722 s |
| `run/motorboat-api-check/e766c544caa54d1fb3ae372a6c7a80a9` | Segunda compilação isolada PASS, incluindo probes de servidor/cliente; **OK (19 tests)**, 1,005 s |
| Parser PowerShell dos dois scripts Motorboat | Zero erros de sintaxe; scripts não executados |
| `git diff --check` naquele ponto | Exit 0; somente avisos de normalização LF/CRLF do checkout |

Os diretórios de API check contêm classes, não um log persistido completo; os resultados acima vieram da saída das ferramentas desta sessão. O `javac` emitiu aviso de bootstrap classpath não definido para `-source 8`; não equivale a testar uma JVM Java 8. JUnit em execução isolada informou falta de implementação Log4j e fallback Netty para heap buffers, mas terminou com 19 testes aprovados. Não usar esses tempos como benchmark.

**Após a segunda compilação isolada foram feitas alterações finais:** verificação/selagem de payload da coleta em `EntityMotorboat`, revalidação da entidade publicada em `ItemMotorboat` e adaptação de `AdversarialCan`/quarto modo de recipiente em `MotorboatServerProbe`. O PASS isolado não cobre exatamente esses patches; o **fullcheck posterior do root cobre sua compilação e a suíte consolidada**, conforme resultado no início deste documento. Os callbacks/probes runtime correspondentes continuam sem execução. Não houve novo Gradle/JUnit iniciado por este subagente após a ordem de transferência.

Os testes cobrem capacidade/simulação, escrow após remover tanque/reload, identidade/tag de fluido, NBT estrito/futuro, tags de upgrades, duplicatas, publicação incerta, tabela de combustível, taxas e equações de impulso/ré/remos/lemes, flutuação, entradas não finitas e tamanho/bits da mensagem. Não exercem mundo Forge, montarias, callbacks reais, colocação por raycast, GL ou mixer.

Revisão independente: `/root/derrick_audit` leu apenas `MotorboatState`/`MotorboatPhysics` e não identificou bloqueador comprovado nesse recorte; foi deslocado para outras frentes. Isso não é auditoria completa nem aprovação do adaptador, renderer ou protocolo em runtime.

## Campanhas preparadas, ainda não executadas

Servidor: `tools/run-motorboat-campaign.ps1 -BootTimeoutSeconds 900`. Porta configurada: 25586. O runner aceita também o parâmetro opcional de filtro de desenvolvimento herdado do padrão do projeto, mas um gate de entrega deve rodar sem excluir famílias. O runner utiliza três boots (`write`, `verify-break`, `verify-reform`) e exige:

- `MOTORBOAT_SURVIVAL_PASS`: seis receitas, workbench IE real, três upgrades, excedente de tanque, jerrycan, dois passageiros, autorização/replay/expiração, impulso pago, remos, gelo, casco/lava, recipientes adversariais e payload futuro.
- `MOTORBOAT_PACK_PASS`: entidade reiniciada com 970 mB, cancelamento/reentrada durante drop, saída única, preservação de combustível/upgrades no item.
- `MOTORBOAT_REDEPLOY_PASS`: item reiniciado, reconstrução e ré, bloqueio de referência destacada/morta e configuração desativada.

O journal da fixture usa WorldSavedData próprio. As consultas/carregamento deliberados do probe não representam comportamento do runtime da lancha. A primeira execução pode revelar pressupostos inválidos do probe; exigir pré-condições e contraprova antes de classificar a causa como bug do jogo.

Cliente: `tools/run-motorboat-client-probe.ps1 -TimeoutSeconds 900`. Cria mundo/screenshot com UUID, verifica 26 combinações válidas em quatro orientações (104 chamadas), restauração de estado GL, presença do recurso sonoro e início/fim lógico do loop. O screenshot deve ser inspecionado; execução sem erro GL não prova qualidade visual, áudio audível, montaria remota nem performance. A fixture usa DataWatcher e entidade cliente artificiais exclusivamente para diagnóstico; não é uma simulação anunciada como gameplay validado.

## Pendências e riscos para a retomada

1. Integrar hooks, passar fullcheck sem filtros e só então rodar os gates reais. Não deixar o texto do manual sugerir que registro/funcionamento já foram homologados.
2. Corrigir o lifecycle de áudio descrito acima antes de aprovação. Confirmar sons após F3+T, troca de mundo, mutar/desmutar master e entrada/saída de alcance; medir separadamente qualquer custo.
3. Revisar os contratos de locomoção que não foram encerrados antes do freeze. Leitura final encontrou diferenças objetivas a resolver/documentar: o choque do quebra-gelo no moderno não exige `!isEmergency()`, mas o adaptador atual exige; criatividade/coleta moderna usa a entidade direta do dano e o adaptador usa `source.getEntity()` para parte da decisão; a ponte 1.12.2 eleva o passageiro na lava em `3.9/16` além de `-.1`, mas o adaptador mantém `-.1` constante. Essas diferenças são de código, não resultado de teste em jogo.
4. Rever queda: `fall()` atual condiciona à variável `surface`, amostrada antes de `moveEntity`; uma aterrissagem AIR→LAND pode não satisfazer essa condição no tick de impacto. Reproduzir a queda antes de afirmar o comportamento.
5. Revisar precisão da animação longa: a hélice atual acumula ângulo sem módulo; o moderno aplica `% 360`. Nenhuma sessão longa mediu degradação.
6. Verificar colocação real com o item/raycast de cinco blocos, jogador remoto e integração vanilla de montaria/dismount, persistência de segundo passageiro, entrada em água/lava, limites de chunks e colisão. O probe servidor cria algumas entidades diretamente e não substitui essas provas.
7. Os limites do adaptador (caixa de consulta e velocidade por tick) e da tabela (256 definições, nome Forge sem `:`) são decisões de contenção explícitas ainda sem campanha de compatibilidade. Não anunciar equivalência irrestrita com todo mod externo.
8. Estado em quarentena permanece preservado e bloqueado, sem ferramenta de reidratação para jogador. Administradores precisam de procedimento validado de recuperação; não remover entidades/payloads automaticamente.
9. Revisar GUI/HUD moderno para confirmar se há indicador de combustível/controles ainda necessário além do tooltip e manual; esta família não implementou overlay de combustível.

## Coker: falha runtime conhecida do root

Não iniciar refactor antes de diagnosticar este gate. Resultado informado pelo root para o retry com timeout 900 s: `write` e ciclo PASS; **`verify-break` FAIL** em `CokerUnitProbe.breakAndRestore`, linha 150: `item persistence mismatch`.

Log exato: `run/coker-multiblock-campaign/20260912T195048Z-9846d6b788444127be91c0b4739a14db/probe-verify-break.log`.

Código nesse ponto primeiro exige as duas câmaras concluídas e `getOutputFluidAmount()==3406`, depois exige `count(world,X,Z,PetroleumItems.PETCOKE)==256`. O segundo requisito falhou. O ciclo anterior anuncia `COKER_DUAL_CYCLE_PASS input=256 petcoke=256 water=16000 residue=3456 cancelledDrop=1 restart=true`. Preservar mundo/região/logs, examinar entidades efetivamente persistidas e área/tempo da contagem. Não atribuir automaticamente a perda, despawn, deslocamento, chunk save ou fixture: a causa não foi investigada/confirmada por esta frente. O root decidiu registrar a reprodução e transferir sem corrigir nesta sessão.

## Próxima arquitetura do Coker customizado — proposta, não implementada

O domínio/TE atual usa receita moderna fixa; não anunciar MineTweaker `addRecipe` genérico enquanto continuar assim. A frente NEI/MT está descrita em `docs/HANDOFF-RECIPE-COMPAT.md`, de `/root/derrick_audit`.

Contrato proposto para revisão pelo próximo responsável:

- `CokerRecipeSpec` imutável: ID estável; ingrediente com identidade/quantidade validada; resultado com identidade/metadata/NBT/quantidade; fluido e volume de lavagem; fluido e volume de resíduo; energia total e duração. Definir explicitamente a unidade (receita versus item) para preservar o timing peculiar da receita moderna existente. Limites de inteiros e saída devem impedir overflow/quantidades impossíveis.
- `CokerRecipeBook`: ativos e arquivados por ID, revisão monotônica e APIs de registrar, desativar e reativar para undo/reload. Remoção impede apenas novas admissões; não altera jobs existentes. NEI enumera ativos; código de migração pode resolver definições antigas arquivadas.
- Cada câmara deve persistir snapshot completo do contrato admitido, identidade do input debitado, fases/contadores e outputs pendentes. Ao lavar, drenar ou publicar, usar esse snapshot; nunca reconsultar um ID mutável e transformar silenciosamente recursos já pagos.
- Migrar schema 1/default para schema 2 com validação estrita; payload futuro/inválido continua preservado em quarentena. Buffers fluidos devem carregar identidade real e rejeitar mistura incompatível entre câmaras, com backpressure sem descartar resíduo/lavagem. Reservas de itens pendentes e desmontagem precisam de identidade completa, não apenas contador de petcoke.
- Expor ao MT uma definição que já passou as mesmas validações de domínio; ações precisam de undo que restaure o conjunto ativo, sem mutar snapshots admitidos. Só depois plugar API Coker no binding e atualizar NEI.
- Regressões necessárias: receita default exatamente igual; duas receitas simultâneas com fluidos incompatíveis; script removal/reload durante cada fase; restart sem definição ativa; publicação cancelada/incerta com NBT; teardown de jobs custom; overflow; remoção e undo; mudança de receita sob o mesmo nome. Rodar a campanha Coker existente novamente após migração.

Nenhuma classe nova desse contrato, schema 2 do Coker ou alteração em seu TE foi iniciada nesta transferência.
