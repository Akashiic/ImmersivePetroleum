# Integração de receitas — 13 de setembro de 2026

Base: `9ad549ca79b4faf4f174e5188c1d892438661017`. Escopo: hooks DT/Hydro, API opcional MineTweaker e diagnóstico de processos reais. Não é aprovação de Coker customizado ou cliente NEI.

## Conexões implementadas

Os TileEntities de Distillation Tower e Hydrotreater agora usam os mesmos livros da API e do navegador. Dois testes de identidade impedem a regressão para defaults privados. O Hydrotreater consulta o contrato do processo para exibir a duração após reiniciar sem script. O bootstrap comum usa Loader/reflexão e não referencia tipos opcionais diretamente; configurações `compatibility.enableMineTweaker` e `enableNEI` controlam o registro na inicialização. Traduções EN/PT do navegador foram integradas.

Gate integrado `recipe-machine-check-getterfix-20260913`: 410 testes/67 suítes, zero falhas/erros/ignorados, sem filtros. A primeira compilação do novo diagnóstico identificou um nome de getter incorreto; a chamada foi alinhada à API real `isTransactionQuarantined` antes do gate aceito.

## Execução de servidor

Campanha `run/recipe-compat-campaign/20260913T103508Z-d6ef8d8103464e53b3a245866cade4dc`, dois boots, fonte estável e exit code 0.

Primeiro boot compila ZenScript real, adiciona duas receitas, forma as estruturas completas (137 + 32 partes), fornece água/RF pelas portas reais e salva no tick 2/5. Remove/undo de receitas atualiza os catálogos; a fonte original de scripts é restaurada. Segundo boot começa sem as receitas sintéticas e completa ambos os contratos já admitidos: 200 mB de entrada, 80 mB de saída, três pedras entregues em baús e 200 RF gastos. A duração de cinco ticks no painel do Hydro permanece disponível pelo snapshot.

Marcadores exigidos: `RECIPE_COMPAT_SCRIPT_PASS`, `RECIPE_MACHINE_WRITE_PASS`, `RECIPE_MACHINE_RESTART_PASS`. Logs por boot, log nativo MT, perfil Gradle e propriedades anteriores estão no diretório da campanha. Esse perfil acrescenta dependências de laboratório; não exclui famílias de fonte. Os runners só publicam resumo PASS após restaurar propriedades e ambiente.

## Limitações demonstradas do CraftTweaker fixado

O registro-base gerado do CT 3.4.8 referencia `SyntheticCrop`, que herda `ic2.api.crops.CropCard`, antes de filtrar `@ModOnly`. Sem IC2, a construção da lista falha e os handlers de ingredientes não são registrados. Confirmado em servidor e nas fontes/bytecode. O registro-base tem bytes idênticos nos JARs dev e de produção; nenhum embute a API IC2. A campanha aceita usa o IC2 exato já presente no inventário do pack, em cópia de laboratório. **IC2 não foi adicionado como dependência do Petroleum.** O perfil CT isolado sem IC2 permanece rejeitado por esse problema externo.

Também foi confirmado nas fontes que WeightedItemStack e WeightedLiquidStack declaram o mesmo `@ZenClass("minetweaker.item.WeightedItemStack")`. O diagnóstico nativo exato dessa duplicação é preservado/classificado separadamente; qualquer outro ERROR do log MT falha a campanha. A API Petroleum aqui usa stacks e arrays/chances comuns, não o tipo WeightedLiquidStack. Não se afirma que o ambiente está isento de avisos/defeitos de terceiros.

## Próximas verificações

Reload redefinindo ID inativo, envelopes NBT estritos, cancelamento/publicação de subprodutos, regressões completas das máquinas sem dependências opcionais, cliente NEI e scripts remotos continuam como gates separados. A ausência de perda no cenário de baú não homologa todos os callbacks externos. Sem aprovação Crucible/Java21, multiplayer autenticado, shaders, desempenho ou release nesta etapa.
