# Hipóteses, teorias, incidentes e evidências rejeitadas

> Registro de **o que se achou que era o problema, o que se provou e o que ficou sem resposta**, extraído dos documentos de engenharia do projeto. Todo item cita o documento de origem em [`archive/engineering-docs-tip-2c7b3f9/`](archive/engineering-docs-tip-2c7b3f9/). Convenção: **Provado** = causa demonstrada por reprodução/contraprova; **Parcial** = causa provável sem prova conclusiva; **Aberto** = nunca determinada.

## 1. Princípio que governa tudo aqui

O projeto manteve uma regra que explica por que esta lista existe: **evidência rejeitada é preservada, nunca apagada nem reclassificada retroativamente**. Tarefas que falharam, foram invalidadas por mudança de fonte ou pararam no menu *permanecem FAIL*; mundos e logs de tentativas rejeitadas são conservados ao lado do mundo aprovado.

## 2. Incidentes com causa-raiz demonstrada

### I-01 · Hashes do pack omitindo 8 JARs (G0)
- **Sintoma:** o primeiro snapshot de hashes do modpack não continha 8 JARs.
- **Hipótese → prova:** nomes com `[` / `]` eram tratados como curinga pelo PowerShell.
- **Correção:** coletor passou a usar `Get-FileHash -LiteralPath`; o snapshot **161/161** substituiu o anterior, que ficou **REJEITADO**.
- **Fonte:** `AUDIT-STATUS.md`, `ROADMAP.md` (G0).

### I-02 · Corrupção de GZIP "passava" como arquivo encontrado (G3A)
- **Sintoma:** a primeira campanha de corrupção classificou o shard corrompido como `FOUND` e só falhou depois com `record missing`.
- **Causa provada:** `MapStorage.loadData` do Forge 1.7.10 instancia o `WorldSavedData` **antes** de decodificar o GZIP e, se a descompressão falha, pode devolver um objeto-casca vazio em vez de `null`.
- **Reparo 1:** estado explícito de inicialização em `ReservoirRegionData`; arquivo existente + casca não inicializada ⇒ `UNREADABLE`; o hash do arquivo corrompido permaneceu idêntico (prova de que não foi sobrescrito).
- **Reparo 2 (rejeitado antes do commit):** usar só `readFromNBTWasInvoked` rejeitaria falsamente um shard recém-criado, salvo e reaberto na mesma JVM. O modelo final usa `initializedForUse`, e a sonda salva e reabre o shard no mesmo processo antes de declarar PASS.
- **Evidência:** `evidence/g3a-reservoir-final` — shard válido SHA-256 `9e9d4b16…76f5`; payload corrompido `a186a1ce…f141`.
- **Fonte:** `AUDIT-STATUS.md`, `G3A-EVIDENCE.md`.

### I-03 · Primeira campanha do Derrick: `source_protocol_error`
- **Campanha rejeitada:** `20260912T161158Z-376ba5a0…`.
- **Causa provada:** o id canônico do fluido ainda não era convertido para o **nome de registro do Forge**; o adaptador passou a resolver `ReservoirFluidBinding`.
- **Achados correlatos da revisão:** a extração continuava pelo piso de fluxo mínimo (15 mB) com pressão zero — corrigido, com 4 testes diretos de limiar; a expectativa do cano diagnóstico foi ajustada ao limite observado do IE (**50 mB por chamada**, com *spill* explícito).
- **Fonte:** `AUDIT-STATUS.md`, `G6-EVIDENCE.md`.

### I-04 · Duplicação por cano coberto do IE (achado na revisão do Derrick)
- **Sintoma/risco:** coberturas de scaffold do IE permitiam duplicar itens.
- **Resolução:** Derrick, Pumpjack e Distillation rejeitam coberturas sem alterar NBT nem gerar drops extras; **os três** tiveram campanhas de quatro boots de regressão — isto ilustra a regra "achado tardio reabre gate já aprovado".
- **Fonte:** `AUDIT-STATUS.md`, `DELIVERY-PLAN.md`.

### I-05 · Coker perdia 128 de 256 petcoke após reiniciar
- **Reprodução instrumentada:** campanha `20260913T042525Z-acc3586b…` (base `6339c71`). Dois chunks, 128 itens cada; só o chunk com `needsSaving(true) = false` perdeu os itens.
- **Causa provada (no ambiente de teste):** a campanha rodava laços manuais da TileEntity dentro de `serverStarted` e desligava o servidor antes de ticks normais; o **relógio do mundo ficou em zero**. No código-alvo, `Chunk.addEntity` não marca `isModified`; `needsSaving(true)` só aceita o chunk se estiver modificado **ou** tiver entidades com relógio diferente do último save — o chunk de saída ficou inelegível.
- **Correção apenas da fixture:** avançar 1 unidade do relógio via API `WorldInfo` antes do checkpoint, exigir elegibilidade nativa de salvamento nos dois chunks e manter a asserção de 256 após o restart. **A simulação de produção não foi alterada.**
- **Tentativa rejeitada:** uma primeira implementação chamou o nome SRG de `World` diretamente → `NoSuchMethodError` (campanha `…043456Z-9c791fec…`).
- **Contraprova:** campanha `20260913T044413Z-689a06f4…` — `COKER_UNIT_MULTIBLOCK_CAMPAIGN_PASS`; 128 + 128 = 256 petcoke; região SHA-256 `259ecc01…e8bd`.
- **Limite honesto do documento:** *a evidência não autoriza afirmar que qualquer perda de itens em gameplay teria a mesma causa*; também não aprova atomicidade contra desligamento abrupto.
- **Fonte:** `COKER-PERSISTENCE-DIAGNOSIS-2026-09-13.md`.

### I-06 · Colisão de IDs de poção do IE (lubrificante)
- **Sintoma:** a campanha de fluidos falhava em *lubricant contact*; antes da correção, `Flammable=24` e `Slippery=24` (objetos distintos, mas mesmo ID — o config dizia 24/25) — o efeito do lubrificante se misturava ao anterior.
- **Causa provada (por `javap`):** no JAR do IE fixado, `IEPotions.getPotionID(int,String)` recebe o ID resolvido por `Config.getPotionID` no **local 2**, mas **retorna o argumento do local 0**.
- **Correção:** `PetroleumPotionIdTransformer` (no core plugin) troca, apenas, o local carregado antes do `IRETURN` de 0 para 2 — só se nome da classe, assinatura e sequência de instruções baterem; forma já corrigida é *no-op*; forma inesperada é rejeitada, não "remendada". O JAR do IE **não** é reescrito. 14 testes novos (suíte foi a 489/74): 11 falhas esperadas antes da correção, todas as 475 anteriores continuaram verdes.
- **Limite:** não migra IDs já gravados com colisão; exige ensaio em cópia de mundo/pack.
- **Fechamento:** fonte `3ee00310…aae6c` — 489/74 testes, fluidos, lubrificação e cliente Angelica PASS (2026-09-14); integrado como `a4182f9` sobre a linha consolidada: **562/88**.
- **Fonte:** `IE-POTION-ID-QUALIFICATION-2026-09-13.md`.

### I-07 · Catalyst Refinery: `NoSuchMethodError` (nomes MCP vs. SRG)
- **Sintoma:** a campanha negativa `catalyst-refinery-native-v3-20260915T1810` gerou `NoSuchMethodError` quando a fixture emitia `func_75146_a` (SRG) contra o Container em nomes MCP.
- **Resolução:** o transformer estrito da Refinery do IE 17 passou a aceitar **explicitamente os dois nomes** (`updateEntity`/`func_145845_h` e `addSlotToContainer`/`func_75146_a`); **qualquer terceiro nome é rejeitado**. Suítes RED exigiram isso antes da correção: `…dual-name-red-20260915T1800` (609 testes, 1 falha) e `…slotname-red-v2-20260915T1820` (611 testes, 2 falhas). Commit `9879cdc`.
- **Fonte:** `CATALYST-REFINERY-QUALIFICATION-2026-09-15.md`.

### I-20 · Motorboat: `NoSuchMethodError` em `setRotationYawHead`
- **Causa provada:** `EntityLivingBase.setRotationYawHead(F)V` é `@SideOnly(CLIENT)` e é **removido no servidor**; a montaria quebrava em servidor dedicado.
- **Correção:** usar o campo público `rotationYawHead`; `MotorboatSideSafetyTest` impede a reintrodução da chamada. A campanha que falhou foi preservada.
- **Fonte:** `MOTORBOAT-QUALIFICATION-2026-09-13.md`.

## 3. Incidentes de ambiente, fixture e ferramentas

| ID | Sintoma | Causa / decisão | Status | Fonte |
|---|---|---|---|---|
| I-08 | Lubrificação: colisão do Crusher na fixture | A fixture **FLAT** (escrita antes do handoff) foi enfim executada sem a colisão — era o terreno do mundo de teste | Provado · PASS | `RUNTIME-QUALIFICATION-2026-09-13.md` |
| I-09 | Gas Generator: medição na fronteira de fio/chunk | A montagem da fixture carregava o **chunk vizinho** antes da medição; a fixture passou a descarregá-lo pela API nativa e exigir sua ausência. Nenhuma regra do gerador mudou. Resultado final: `chunkLoads=0` | Provado | `RUNTIME-QUALIFICATION-2026-09-13.md`, `GAS-GENERATOR-QUALIFICATION-2026-09-14.md` |
| I-10 | Flarestack: `NullPointerException` ao notificar `FakePlayer` | Usava `addChatMessage`; o `FakePlayer` sobrescreve `addChatComponentMessage` (jogadores reais enviam o mesmo `S02PacketChat` nos dois caminhos) | Provado · corrigido | `RUNTIME-QUALIFICATION-2026-09-13.md` |
| I-11 | Runners devolviam `ExitCode` vazio | `Start-Process` sem preservar `$proc.Handle`; com o handle preservado, códigos 0 e 7 foram recuperados. Runners Coker, Lube, Gas e Flare corrigidos, mantendo todos os marcadores | Provado · corrigido | `RUNTIME-QUALIFICATION-2026-09-13.md` |
| I-12 | Well (e Seismic) com `markDirty` no caminho quente | `TileEntity.markDirty()` do Forge 1.7.10 marca o chunk **e** dispara atualização de comparadores; o timer de autodestruição o chamava a cada tick. Substituído por `markTileEntityChunkModified`; teste de bytecode exige zero `markDirty` ali (teste vermelho `well-hotpath-red-20260914T1640`) | Provado · corrigido | `WELL-INFRASTRUCTURE-QUALIFICATION-2026-09-14.md`, `SEISMIC-SURVEY-QUALIFICATION-2026-09-14.md` |
| I-13 | `BlockSnapshot.restore` inadequado como rollback | No Forge 17 fixado, `restore` confere o metadado em `(x&15, y, z&15)` e **não valida de forma confiável a substituição absoluta**; rollback genérico é impróprio para tiles próprios. O Projector congela a posse anterior e só restaura a célula que ainda identifica como sua (teste vermelho `projector-placement-red-20260914T033754Z`) | Provado | `HANDOFF-PLACEMENT-MATERIALS.md`, `PROJECTOR-QUALIFICATION-2026-09-14.md` |
| I-14 | CraftTweaker 3.4.8 falha sem IC2 | O registro-base gerado referencia `SyntheticCrop` (herda `ic2.api.crops.CropCard`) **antes** de filtrar `@ModOnly`; sem IC2 a lista falha e handlers não registram. A campanha aceita usa o IC2 exato do inventário do pack, em cópia de laboratório; **IC2 não virou dependência** | Provado | `RECIPE-INTEGRATION-2026-09-13.md` |
| I-15 | Envelope do Hydrotreater rejeitava campos legítimos | Whitelist final distingue campos de posse vanilla/IE (`id/x/y/z`, `formed/pos/offset/mirrored`) de campos futuros desconhecidos, que são preservados por `invalidEnvelope` completo | Provado · corrigido | `HYDROTREATER-QUALIFICATION-2026-09-14.md` |
| I-16 | Renderer de inventário da vela vazava `GL_LIGHTING` (2896) | Estado GL não restaurado; campanha `material-chain-final-client-20260915T1030` **rejeitada e preservada**; só a v2 entra na aprovação | Provado · corrigido | `MATERIAL-CHAIN-QUALIFICATION-2026-09-15.md` |
| I-17 | Bloco "Asfalto" sem informação moderna de velocidade no tooltip | Reprodução negativa `asphalt-client-tooltip-red-20260915T1902` (`modern Asphalt speed tooltip missing for Asfalto`); `ItemAsphaltBlock`/`ItemAsphaltSlab` delegam a `AsphaltItemTooltip` (percentual derivado de `ASPHALT_SPEED_FACTOR`, some com `asphaltSpeed=false`) | Provado · corrigido | `ASPHALT-QUALIFICATION-2026-09-15.md` |
| I-18 | `BUILD SUCCESSFUL` mesmo com exceção de mod | `runServer`/Gradle pode sair 0 depois de o FML reportar erro; regra: julgar só por marcadores e conteúdo de erro do FML | Regra permanente | `AUDIT-STATUS.md` |
| I-19 | Supervisor retornou 74 numa campanha de lubrificação | Duas linhas de diagnóstico mudaram a fonte; o recibo **não foi aprovado** — repetição com a fonte congelada passou depois | FAIL mantido + repetição PASS | `IE-POTION-ID-QUALIFICATION-2026-09-13.md` |

## 4. O que ficou sem causa-raiz (Aberto)

### A-01 · Cliente NEI preso no menu
- **Fato:** na matriz de qualificação do NEI, o **segundo perfil permaneceu no menu** depois de iniciar o servidor integrado. Dump de threads e captura de janela foram preservados; o Desktop Commander respondia.
- **O que se descartou:** falha de socket não foi concluída; causa definitiva do cliente não foi concluída.
- **Tratamento:** encerramento do processo próprio do diagnóstico; o perfil foi reexecutado isoladamente e passou; **a matriz rejeitada continua FAIL**. Uma matriz nova exigida e aprovada: `nei-certified-20260913T235224Z`, **seis etapas** PASS, digest `003298ea…5eff`.
- **Hipóteses não testadas** [inferência]: corrida de inicialização do cliente sob a carga do harness; interação com a restauração de opções do laboratório. Nenhuma foi confirmada nos documentos.
- **Fonte:** `REMOTE-EXECUTION-RECOVERY.md`, `NEI-CLIENT-QUALIFICATION-2026-09-14.md`.

### A-02 · Alcance real do achado do Coker
Se perdas de itens poderiam ocorrer em gameplay por outro mecanismo é **explicitamente não afirmado** (ver I-05).

### A-03 · Transporte MCP não é dono da conclusão
Chamadas MCP grandes podem não devolver o controle; o projeto responde com heartbeat/recibo local (`run/guarded-tasks`) e **não** com reconexão automática. Não há operação explícita de reconexão de socket. **Fonte:** `REMOTE-EXECUTION-RECOVERY.md`.

## 5. Teorias de projeto (decisões e alternativas descartadas)

| Decisão | Alternativa descartada | Razão registrada |
|---|---|---|
| Semântica **moderna 1.21.1** do Pumpjack | Laço de extração legado 1.12 | Alvo declarado é o conjunto moderno; 1.12 é só ponte |
| Addon **separado** + coremod ASM cirúrgico | Reescrever o JAR do IE / poluir o núcleo do IE | Preservar registros e mundos; só tocar o núcleo com deficiência de API provada |
| Cache de reservatório **descartável**, dado persistido autoritativo | Cache como fonte | Corrupção/restart seguros |
| Persistência **fail-closed** com quarentena | Reescrever versão desconhecida | Nunca destruir dados que o código não entende |
| `initializedForUse` | `readFromNBTWasInvoked` | Falso positivo em shard recém-criado (I-02) |
| Nunca *force-load* de chunk para consulta | Carregar chunk para responder GUI | Custo/risco de servidor |
| Transformer verifica a forma exata da classe | Heurística "tolerante" | Falhar alto em vez de remendar (I-06) |
| Assets **clean-room** | Reutilizar modelos/texturas do upstream | Licença *All Rights Reserved* |
| Progresso por **denominador fixo ponderado** | Derivar % de testes/linhas | Evitar métricas de vaidade |
| Judge por **marcadores** | Judge por exit code | I-18 |

## 6. Como reproduzir a verificação de qualquer item

1. Abra o documento de origem em `archive/engineering-docs-tip-2c7b3f9/`.
2. Localize o id da campanha (`run/<tipo>/<timestamp>-<hash>`) e o SHA-256 da região/fonte citados; esses artefatos vivem **só no disco do autor** (`run/` não foi arquivado aqui).
3. Rode a campanha com `tools/guarded_task.py` e compare os marcadores `*_PASS` e o hash da região.
