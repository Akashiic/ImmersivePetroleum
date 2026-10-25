# Coker — receitas customizadas e contratos persistentes

## API opcional MineTweaker / CraftTweaker 1.7.10

A classe abaixo existe somente quando a integração opcional MineTweaker3 está disponível e habilitada. O addon não inclui o interpretador nem torna IC2, MineTweaker ou NEI obrigatórios.

```zenscript
mods.immersivepetroleum.Coker.addRecipe(
    "minharede:coqueamento_exemplo",
    <minecraft:dye:4> * 3,
    <liquid:lubricant> * 500,
    <minecraft:dye:1> * 4,
    <liquid:kerosene> * 13,
    50,
    5
);

mods.immersivepetroleum.Coker.removeRecipe("minharede:coqueamento_exemplo");
```

A ordem é: identificador, item de entrada, fluido de lavagem, item produzido, fluido residual, energia declarada e duração declarada. O exemplo acima é um cenário de diagnóstico de contabilidade, não uma recomendação de balanceamento para o modpack.

A receita padrão permanece `immersivepetroleum:coking/petcoke`. Para substituí-la no script, remova esse ID antes de adicionar a nova definição. A ambiguidade entre receitas simultaneamente ativas com a mesma chave de item, metadata e fluido de lavagem é rejeitada. O undo nativo restaura a definição que foi realmente removida, e não uma versão posterior encontrada pelo mesmo ID.

## Fronteira implementada

O contrato aceita identidades exatas de itens registrados, preservando inclusive maiúsculas de IDs legados como `IC2:...`. Não converte esses nomes para minúsculas. A receita possui ID próprio canônico minúsculo. Fluido usa o nome nativo Forge, que normaliza seu nome no construtor `Fluid`.

Metadados concretos vão de 0 a 32766. Quantidades vão de 1 a 64 e também precisam caber no limite nativo do item. Itens com NBT, metadata wildcard 32767, ingredientes OreDictionary e listas alternativas de itens não pertencem a esta API de contrato exato. Eles são rejeitados, não simplificados silenciosamente. O suporte a esses ingredientes mais gerais deve ser uma ampliação explícita, com armazenamento dos insumos realmente consumidos para desmontagem correta.

Cada quantidade de fluido por unidade deve estar entre 1 e 8000 mB. A energia declarada deve ser pelo menos a duração declarada. A divisão inteira energia/duração deve resultar entre 1 e 24000 RF/t. Overflow da duração efetiva é rejeitado antes de alterar o catálogo.

## Taxas preservadas do upstream fixado

A duração da câmara é a duração declarada multiplicada pela quantidade de itens exigida por unidade. O débito por tick usa a divisão inteira da energia declarada pela duração declarada. Portanto, energia declarada não deve ser confundida com a energia efetiva total de uma unidade.

No exemplo: 3 itens × 5 ticks = 15 ticks, a 10 RF/t; total efetivo 150 RF por unidade. Duas unidades produzem oito itens, usam 1000 mB de lavagem, geram 26 mB residuais e consomem 300 RF. Na receita padrão, 2 × 30 = 60 ticks a 512 RF/t, total de 30720 RF, preservando a implementação moderna congelada.

As cinco fases continuam STANDBY, PROCESSING, DRAIN_RESIDUE, FLOODING e DUMPING. Lavagem ocorre após o processamento e drenagem do resíduo. A água/fluido de lavagem não é debitada antecipadamente só por admitir o item.

Para receitas customizadas, a capacidade de cada câmara é `min(64, floor(8000/lavagem), floor(8000/resíduo))` unidades. Essa adaptação impede admitir um lote que nunca caberia nos dois estágios de fluido da câmara. A receita padrão permanece com 64 unidades. As duas câmaras e os dois buffers compartilhados preservam a identidade de fluido: uma mistura incompatível espera, não é convertida para água ou diesel por conveniência.

## Persistência, publicação e desmontagem

O schema 2 do estado contém uma cópia imutável do contrato de cada câmara. Remover ou substituir uma receita altera somente novas admissões. Uma câmara paga continua com a receita admitida, mesmo depois de reiniciar sem o script. O schema 1 antigo migra apenas para a definição padrão congelada; não busca a receita atual pelo ID e presume equivalência.

Um snapshot feito enquanto um callback de entrega ainda está em andamento recarrega em quarentena. A ausência de uma exceção não basta: identidade, quantidade, vínculo com o mundo e confirmação da publicação são verificados no adaptador. Recusa comprovada conserva a unidade; resultado incerto não recebe restituição automática nem repetição às cegas.

A desmontagem conserva os itens efetivamente armazenados e reconstrói as unidades cruas/processadas pelo contrato daquela câmara, incluindo metadata. Ela não substitui saídas customizadas por petcoke ou entradas por bitumen. Uma unidade é oferecida por vez; a contagem é limitada pelas capacidades das câmaras. Cancelamento de publicação impede a quebra normal até uma tentativa confirmada. A cápsula de recuperação mantém a política anterior: registro diagnóstico, sem API de reidratação automática de recursos.

## Navegador e interface da máquina

O NEI consulta o mesmo catálogo ativo utilizado pelo TileEntity. Cartões e buscas usam metadata exata, taxas efetivas e fluidos da receita. Remover/adicionar/substituir uma receita atualiza a tela já aberta. O navegador não altera o catálogo para esconder uma receita inválida.

A GUI da máquina mantém os cinco slots originais, mas recebe duração, progresso, capacidade e identidades de fluido variáveis. Temporizadores de 32 bits são enviados em partes de 16 bits pelo transporte vanilla existente, em vez de truncar valores acima de 65535. A barra limita sua geometria e usa multiplicação de 64 bits. Os clientes e o servidor devem utilizar a mesma versão do addon.

## Limites de qualificação

As evidências desta etapa constam em `COKER-CUSTOM-QUALIFICATION-2026-09-14.md`. Os testes não demonstram consistência atômica entre arquivos de chunks/jogadores em uma queda abrupta do host, nem comportamento correto de callbacks arbitrários de qualquer mod. A qualificação do pack completo, do Crucible/Java 21, de jogadores autenticados, de shaders e de desempenho continua separada.
