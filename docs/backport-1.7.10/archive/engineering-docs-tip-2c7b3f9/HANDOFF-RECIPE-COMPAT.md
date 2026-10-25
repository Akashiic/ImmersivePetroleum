# Transferencia: integracao NEI e MineTweaker 3 — WIP congelado

Atualização do root após o congelamento: o gate completo sem exclusões passou com 401 testes/64 suítes, incluindo os oito testes desta frente, e Checkstyle sem apontamentos. Consulte `HANDOFF-VALIDATION.md`. As declarações abaixo de “não executado pelo agente” descrevem o estado no congelamento; hooks, scripts em servidor real e cliente continuam pendentes.

Data: 2026-09-12. Responsavel desta frente: subagente `/root/derrick_audit`.
Checkout: `C:\Users\User\Desktop\Codex\immersivepetroleum-backport\work\ImmersivePetroleum-1.7.10`.

## Estado real e motivo do congelamento

O usuario pediu transferencia antes do limite de uso. O root ordenou congelar o escopo imediatamente, terminar apenas ajustes de compilacao e registrar todas as pendencias. Esta frente NAO esta aprovada nem completa. Nao executar automaticamente os probes em mundos de jogadores.

Foram escritos os adaptadores opcionais, a visualizacao NEI, os livros mutaveis e os snapshots de receitas de processos DT/Hydro. Ainda faltam hooks nos TEs e lifecycle compartilhado, runtime opcional, cliente visual, e receitas custom do Coker. Nenhum Gradle, JUnit ou cliente desta integracao foi executado por este agente. O root havia excluido temporariamente `common/compat/recipes` e `client/nei` de seu gate durante o desenvolvimento; confirmar como a exclusao foi aplicada antes de afirmar que compilou tudo. Build 22865 do root compilou outras familias, mas antecede os snapshots desta frente e nao os homologa.

Ultimo ajuste apos ordem de transferencia: imports wildcard de `RecipeReloadTest` substituidos por imports explicitos para Checkstyle. Nenhuma redefinicao nova de contratos foi iniciada. Nenhum TE de producao, proxy, linguagem ou registro compartilhado foi editado por esta frente.

## Arquivos escritos/alterados

Todos os caminhos abaixo sao relativos ao checkout acima; preservar inclusive arquivos untracked no checkpoint.

| Arquivo/pasta | Conteudo e estado |
| --- | --- |
| `dependencies.gradle` | Adiciona dois compileOnly, sem transitivos; ainda requer resolucao/compilacao no gate raiz. |
| `src/main/java/flaxbeard/immersivepetroleum/common/compat/recipes/PetroleumRecipeCompatibility.java` | Bootstrap opcional via Loader + reflexao; livros globais DT/Hydro e revision. Falta chamada lifecycle raiz. |
| `.../common/compat/recipes/PetroleumMineTweaker.java` | ZenClass DT e Hydro, add/remove com IUndoableAction nativo. Coker ainda NAO registrado. |
| `.../common/compat/recipes/PetroleumRecipeView.java` | DTO imutavel de visualizacao; DT/Hydro ativos, Coker fixo moderno. Resolve itens de registro e alias de enxofre. |
| `.../common/compat/recipes/RecipeCompatProbe.java` | Probe opt-in com compilacao real de ZenScript e rollback/reload; escrito, nao executado e sem hook ainda. |
| `src/main/java/flaxbeard/immersivepetroleum/client/nei/NEIImmersivePetroleumConfig.java` | Plugin client-only descoberto pelo NEI; registra tres handlers e IMC handlerInfo. |
| `.../client/nei/PetroleumRecipeHandler.java` | Cartao original com icones nativos de fluidos, quantidades, RF/t, duracao, chance, pesquisa item/fluido e revisao dinamica. Nao testado em cliente. |
| `.../common/machine/distillation/DistillationRecipeBook.java` | Registro sincronizado active/archive, deactivate/activate/isActive/revision; getRecipes retorna apenas ativos; getById preserva arquivados. |
| `.../common/machine/distillation/DistillationRecipeCodec.java` | NOVO snapshot completo de definicao, versao 1, tipos exatos e campos desconhecidos rejeitados. |
| `.../common/machine/distillation/DistillationTransactionEngine.java` | ProcessState guarda definicao imutavel admitida; construtor antigo por ID preservado; processo usa snapshot antes de consultar livro. |
| `.../common/machine/distillation/DistillationStateCodec.java` | Schema 2 com contrato no processo; le schema 1 pelo livro legado. Construtor ProcessState(id,tick) sem definicao ainda escreve schema 1 ate resolver. |
| `.../common/machine/hydrotreater/HydrotreaterRecipes.java` | Livro sincronizado active/archive; accepts usa apenas ativos; all preserva arquivo para NBT antigo, active para browser. |
| `.../common/machine/hydrotreater/HydrotreaterRecipeCodec.java` | NOVO snapshot completo e estrito de definicao. |
| `.../common/machine/hydrotreater/HydrotreaterState.java` | Schema 2; recipeContract do processo e pendingContract de item pronto. Le schema 1 pelo livro e migra ao escrever. |
| `src/test/java/flaxbeard/immersivepetroleum/common/compat/recipes/RecipeReloadTest.java` | Oito testes novos, ainda NAO executados. |

`HydrotreaterRecipes/State` aparecem em uma pasta untracked porque a familia inteira foi criada nesta sessao pelo root; preservar tambem os arquivos dos outros donos. Nao substituir pela versao de HEAD ao transferir.

## Dependencias opcionais e fontes verificadas

Adicoes existentes em `dependencies.gradle`:

```groovy
compileOnly("com.github.GTNewHorizons:NotEnoughItems:2.8.125-GTNH:dev") { transitive = false }
compileOnly("com.github.GTNewHorizons:CraftTweaker:3.4.8:dev") { transitive = false }
```

NEI real no inventario `../../evidence/runtime-mods-baseline.json`: `NotEnoughItems-2.8.125-GTNH.jar`, SHA-256 `91b032e0fc5336a93ead987df98e8d02d3185dbbe160d40ac2da5e605e1f2070`. Nenhum MineTweaker estava no inventario consultado. Nao tornar NEI nem MineTweaker dependencias obrigatorias do servidor.

Fontes primarias de APIs: releases oficiais [NEI 2.8.125-GTNH](https://github.com/GTNewHorizons/NotEnoughItems/releases/tag/2.8.125-GTNH) e [CraftTweaker 3.4.8](https://github.com/GTNewHorizons/CraftTweaker/releases/tag/3.4.8). JARs dev/sources baixados desses releases estao em `run/recipe-compat-research/` (IGNORADO pelo Git; copiar como evidencia se necessario ou baixar novamente pelas URLs oficiais).

| Artefato de pesquisa | SHA-256 |
| --- | --- |
| `NotEnoughItems-2.8.125-GTNH-dev.jar` | `B973EC44FEED92F6EA318804033D3A3703CA0EDCA6397F556556121807E29543` |
| `NotEnoughItems-2.8.125-GTNH-sources.jar` | `487F1A351B66954FBF8CB55B7EC0C6140CFD12B5CD72AF07B42CE26514F67FF7` |
| `CraftTweaker-3.4.8-dev.jar` | `43D361638DDAC6F3E22D822399237D26E7D5FCAF0D44FD89EE588536A595F589` |
| `CraftTweaker-3.4.8-sources.jar` | `5746A6DAAE8C5933508884D32517EB12B0A17956C6E8AA19EA65ED94C6C495DD` |

JAR deobf NEI ja instalado: `C:\Users\User\.gradle\caches\transforms-3\18daa166743058a0bf1cae661cea47ba\transformed\NotEnoughItems-2.8.125-GTNH-deobf.jar`.

`run/recipe-compat-research/` tambem contem fontes extraidas: MineTweakerAPI, MineTweakerImplementationAPI, MineTweakerMod, IUndoableAction, NEI, TemplateRecipeHandler, PositionedStack, IConfigureNEI, IRecipeHandler, GuiRecipe, GuiCraftingRecipe, GuiUsageRecipe, RecipeHandlerQuery, StackInfo, ItemInfo e IMCForNEI.

Verificacoes feitas por fonte e javap (nao sao teste runtime):

- Modid CT exato: `MineTweaker3`; pacotes `minetweaker.*`, anotacoes `stanhebben.zenscript.annotations.ZenClass/ZenMethod`.
- `MineTweakerAPI.registerClass`, `apply`, `logError`; `MineTweakerMC.getLiquidStack/getItemStack`; IUndoableAction possui apply/canUndo/undo/describe/describeUndo/getOverrideKey.
- ITweaker possui getScriptData, rollback, setScriptProvider e load. ScriptProviderMemory(byte[]) existe. IScriptProvider.getScripts retorna Iterator<IScriptIterator>; iterator possui getGroupName/next/getName/open. Javap em ambos jars dev confirmou essas assinaturas.
- NEI getHandlerId e getRecipeHeight(int) existem; TemplateRecipeHandler.newInstance foi sobrescrito para manter a familia porque nao temos construtor sem argumento.
- GuiRecipe.forceRefreshPage e currenthandlers sao publicos. getRecipePosition retorna coordenadas relativas; o handler obtem guiLeft/guiTop por ReflectionHelper com nomes de MCP/SRG comprovados.
- PositionedStack aceita (Object,int,int), chance em 0..10000 e tooltip; StackInfo.getFluid reconhece recipientes de fluido nas consultas.
- `FMLInterModComms.sendRuntimeMessage` usa instancia real do mod, nao String como source.
- APIs Minecraft alvo sao de `build/rfg/recompiled_minecraft-1.7.10.jar` e `build/rfg/minecraft-src/java`, nao outro mapeamento. Sem Block.barrier ou drawModalRectWithCustomSizedTexture nesta frente.

Oracle de paridade: `../../upstream/ImmersivePetroleum-1.21.1`, commit frozen `e6cb01df32d4adfd096d49c02bb91e60fef56a15`.
Defaults em `src/generated/resources/data/immersivepetroleum/recipe/distillationtower/{oil,kerosene}.json`, `hydrotreater/{sulfur_recovery,lubricant_cracking,naphtha_cracking}.json` e `coking/petcoke.json`.
Categorias modernas em `src/main/java/flaxbeard/immersivepetroleum/common/util/compat/jei/`; API Coker em `api/crafting/CokerUnitRecipe.java`. Interface NEI criada em codigo original; nenhum asset moderno restrito copiado.

## Hooks que o root/continuador ainda precisa implementar

1. Chamar `PetroleumRecipeCompatibility.register()` durante init/postInit, antes do serverAboutToStart que executa scripts MT. A classe bootstrap nao tem tipos MT/NEI em sua superficie de linkage; Loader.isModLoaded("MineTweaker3") precede reflexao. Se MT estiver instalado mas API quebrada, falha explicita em vez de suporte falso.
2. `TileEntityDistillationTower.java`: substituir somente inicializacao de `private static final DistillationRecipeBook RECIPES = DistillationRecipeBook.modernDefaults()` por `PetroleumRecipeCompatibility.distillation()`; preservar transacoes/portas/persistencia existentes.
3. `TileEntityHydrotreater.java`: inicializar RECIPES com `PetroleumRecipeCompatibility.hydrotreater()`; em `getTarget()` usar `m.state.currentRecipe(RECIPES)` em vez de `RECIPES.get(m.state.recipeId())`, para mostrar duracao de snapshot sobrevivente a restart sem script.
4. NEI deve descobrir `NEIImmersivePetroleumConfig` pelo loader proprio; NAO referenciar classe client/NEI em CommonProxy ou servidor. Confirmar descoberta real no log do cliente opcional.
5. O probe server tem propriedade `immersivepetroleum.recipeCompatProbe=server`. Ainda falta bootstrap reflexivo guardado no `PetroleumRecipeCompatibility` e chamada serverStarted pelo root. Nao referenciar diretamente `RecipeCompatProbe` em classe carregada sem MT porque esse probe liga tipos opcionais.
6. Nao ha canal proprio: sincronizacao de scripts usa lifecycle nativo MT. Confirmar disconnect/reconnect e reload remoto em servidor dedicado real antes de declarar listas corretas no cliente.
7. Inserir as traducoes abaixo nos arquivos reais de idioma (esta frente nao os editou).

## API ZenScript escrita (ainda sem homologacao)

```zenscript
mods.immersivepetroleum.Distillation.addRecipe(
    "pack:water_distillation_v1", [<liquid:water>*100], [<liquid:water>*40],
    [<minecraft:stone>], [1.0], 100, 5);
mods.immersivepetroleum.Distillation.removeRecipe("pack:water_distillation_v1");

mods.immersivepetroleum.Hydrotreater.addRecipe(
    "pack:water_hydro_v1", <liquid:water>*100, null,
    <liquid:water>*40, <minecraft:stone>*2, 100, 5);
mods.immersivepetroleum.Hydrotreater.removeRecipe("pack:water_hydro_v1");
```

DT inputs sao alternativas com quantia igual; outputs somam capacidade unica 24000 mB; energia/ticks inteira por divisao, como kernel existente. RF/t deve caber em storage real 16000. Hydro capacidade 12000 mB por tanque e storage 8000; secondary/item aceitam null. Construtores existentes validam limites numericos. Metadata nao zero, NBT em item ou fluido, itens sem ID representavel e stack acima do maximo sao rejeitados explicitamente; nao inventar equivalente meta0 para ingrediente incompatível. Erros logam no MineTweaker.

NEI usa tres IDs `immersivepetroleum.distillation`, `immersivepetroleum.hydrotreater`, `immersivepetroleum.coker`. Clique esquerdo/R em icone de fluido busca producao; direito/U busca uso via query nativa `ip_fluid`. Cartao mostra RF/t, ticks, quantidades mB e chance de subprodutos; o Coker mostra defaults com 60 ticks de coking (30 vezes dois inputs) e ressalva de fases de lavagem/drenagem. Nao ha probe visual ou screenshot NEI ainda.

## Testes escritos e gates ainda necessarios

`RecipeReloadTest` tem oito testes: DT remocao so bloqueia nova admissao; snapshot sobrevive livro vazio/restart; mesmo ID em outro livro nao muda processo pago; schema1 migra; ativacao ambigua e contrato alterado nao mutam livro; Hydro processo e item pendente sobrevivem ausencia de scripts; pendente legado migra; tipos/keys invalidos de snapshots rejeitados; arquivo/ativos e undo. Oito metodos @Test, nao confundir com oito casos internos.

`RecipeCompatProbe.run(server)` salva scripts originais, compila ZenScript real de duas receitas sinteticas de agua, verifica livros/views, recarrega removendo dois defaults, desfaz por script vazio, e no finally restaura ScriptProviderMemory(original). Ao concluir inicia shutdown. Marker esperado, AINDA NAO OBTIDO:
`RECIPE_COMPAT_SCRIPT_PASS zenScriptCompiled=true added=2 removed=2 undo=true activeViews=true`.
Assume perfil de laboratorio com apenas defaults (views 3 DT/4 Hydro apos add). Scripts de modpack preexistentes mudam contagens; nunca executar sobre mundo real. O probe verifica catalogos, nao forma/processa TEs.

Gates pendentes, nesta ordem:

1. Compilacao completa/Checkstyle e JUnit apos remover exclusoes temporarias; corrigir APIs reais sem trocar de jar alvo. Nenhum resultado desta frente deve ser inferido de gates anteriores.
2. Corrigir pendencias funcionais abaixo e adicionar regressao focada.
3. Integrar hooks, rodar servidor SEM NEI e SEM MT para side safety/no hard dependencies.
4. Rodar profile servidor com CT 3.4.8 e dependencias exigidas pelo proprio CT; compilar ZenScript, undo/reload, recusa meta/NBT, e TEs reais processando recipes custom antes/depois de restart sem arquivo script.
5. Criar e rodar probe de cliente real NEI, abrindo as tres familias, pesquisa de fluidos/buckets e itens, chance, receitas removidas/repostas com GUI aberta, GL-state, resize e screenshots. Ainda nao escrito.
6. Auditar/reexecutar DT/Hydro save/restore/rollback dedicados depois dos snapshots. Nao reusar PASS de schema1 como prova de schema2.
7. Completar contrato Coker e integrar MT/NEI nele, conforme proxima secao.

## Pendencias e reproducoes conhecidas (nao esconder na transferencia)

- **P1 integracao ausente:** TEs ainda usam livros privados modernDefaults, entao receitas de scripts atualmente mudam catalogo NEI mas nao as maquinas. Hooks acima sao obrigatorios antes da entrega funcional.
- **P1 contrato Hydro restorePending:** API publica antiga permite `new HydrotreaterState().restorePending("minecraft:stone",1)`; `write()` agora sempre escreve schema2, sem pendingContract porque nunca houve processo. `read()` rejeita o proprio resultado. Caminho de rollback normal de producao preserva pendingDefinition e tem teste; uso sintetico publico ainda quebra roundtrip. Proposta: fallback deliberado a schema1 quando pending>0 sem definicao (como construtor legado DT), validando pelo livro no reload, ou API explicita de reserva tipada. Tambem limpar/recusar pendingDefinition antigo se restorePending receber outro item. Nao alterado apos ordem de congelamento.
- **P1/funcional Coker custom ausente:** CokerRecipe ainda e conjunto fixo de constantes. NAO existe `mods.immersivepetroleum.Coker.addRecipe`; nao afirmar suporte completo. Root delegaria contrato ao runtime apos gate Motorboat/Coker; essa implementacao nao comecou nesta frente.
- **P2 reload redefinindo mesmo ID:** activate aceita somente definicao exatamente igual ao arquivo antigo; inativa com mesmo ID e dados diferentes e rejeitada. Repro: adicionar ID a, rollback, mudar output e reexecutar arquivo; novo contrato nao entra. Tambem pode afetar troca de servidor no mesmo cliente. Proposta ENVIADA mas NAO IMPLEMENTADA: permitir substituir definicao inativa preservando livro separado para schema1; processos schema2 ja guardam definicao imutavel. Cada action remove deve guardar o objeto removido para undo, em vez de consultar ultimo ID, caso permita redefinicao. Atualmente documentar IDs versionados como limitacao temporaria.
- **P2 NBT DT legado permissivo:** snapshot de definicao e estrito, mas envelope de DistillationStateCodec ainda tem coercoes herdadas (input/process de tipo errado ignorados, tick getInteger sem hasKey exato). Auditar com regressao sem apagar raw em erro; TE ja tem quarentena para excecao de codec. Nao descrever TODO envelope como estrito.
- **P2 schema1 e contrato embutido:** Hydro read aceita schema1 e resolve pelo livro mesmo se houver contract extra; caso cru do futuro/corrupcao precisa criterio explicito de rejeicao. Nao houve exposicao de escrita deste NBT ao cliente pela nova API.
- **P2 NEI itens ausentes:** fallback visual usa bedrock com tooltip explicito missing_item; evitar insinuar que bedrock e produto de receita. Pesquisa usa item real e nao fallback, mas UX precisa revisao. Itens fluidos sao desenho proprio e NAO slots NEI de fluido nativo, portanto validar bookmark/favorite/overlay para alcance honesto.
- **P2 GUI e listas:** forceRefreshPage implementado apenas quando handler atual esta presente; uma familia anteriormente sem resultados pode nao aparecer como nova aba ate refazer consulta. Criar probe e decidir comportamento. Checar altura dinamica acima do handlerInfo 118 em janelas pequenas.
- **P2 script thread/side lifecycle:** livros sao sincronizados; nao ha acesso a World/Netty no dominio. Isso nao substitui prova de reload MT integrado ou client/server scripts iguais. Sem coremod novo e sem protocolo de rede paralelo.

## Contrato Coker proposto ao runtime (pendente)

Implementar definicao imutavel para ingrediente item real, quantia, produto, fluido de lavagem, residuo, energia, duracao e multiplicador por quantidade de input conforme oracle. Registro de receitas ativas/removidas; snapshot de definicao em cada uma das duas camaras e nas reservas prontas. Preservar schema antigo, teardown, quarentena callback e output reservado. API publica para adapter obter snapshot, activate/deactivate/revision. So entao adicionar ZenClass Coker e mudar PetroleumRecipeView do default constante para livro ativo. Metadados/NBT precisam contrato real ou rejeicao explicita — nao suporte ficticio.

## Idiomas propostos para merge futuro

EN:
```properties
nei.immersivepetroleum.distillation=Distillation Tower
nei.immersivepetroleum.hydrotreater=Hydrotreater
nei.immersivepetroleum.coker=Coker Unit
nei.immersivepetroleum.inputs=Inputs
nei.immersivepetroleum.outputs=Outputs
nei.immersivepetroleum.coker_cycle=Plus washing and draining phases
nei.immersivepetroleum.alternatives=Accepted alternatives
nei.immersivepetroleum.fluid_help=Left/R: recipes; Right/U: uses
nei.immersivepetroleum.missing_item=Unavailable registered item
```

PT:
```properties
nei.immersivepetroleum.distillation=Torre de Destilacao
nei.immersivepetroleum.hydrotreater=Hidrotratador
nei.immersivepetroleum.coker=Unidade de Coque
nei.immersivepetroleum.inputs=Entradas
nei.immersivepetroleum.outputs=Saidas
nei.immersivepetroleum.coker_cycle=Mais fases de lavagem e drenagem
nei.immersivepetroleum.alternatives=Alternativas aceitas
nei.immersivepetroleum.fluid_help=Esquerdo/R: receitas; Direito/U: usos
nei.immersivepetroleum.missing_item=Item registrado indisponivel
```

Corrigir acentos conforme convencao de encoding dos langs no merge. Validar comprimento de coker_cycle no cartao; pode precisar quebra de linha.

## Outros trabalhos anteriores desta frente

Seismic, Gas Generator, Flarestack e Projector foram congelados e integrados pelo root em etapas anteriores; seus resultados de campanha pertencem aos logs/relatorio raiz, nao a este documento. Nao sobrescrever correcoes posteriores do root. Lube identity hotfix em `common/lubrication/LubricationWorldData.java` usa Forge ChunkData.Save/Load e WeakHashMap de identidade por TE, sem getTileData inexistente; ver `docs/ADR-LUBRICATION-IDENTITY.md` e `LubricationIdentityTest`. Root registrou Forge bus. Nao editar `common/compat/drilloil`, que e ownership raiz. Revisoes read-only de Motorboat e Molotov foram parciais, nunca aprovacoes finais.
