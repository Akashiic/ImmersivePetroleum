# Coker: diagnóstico da perda de itens na campanha

Base: `6339c7129c1a119f1d4022d6d95720e67688a4e3`. A campanha antiga de 12/09 permanece intacta. A inspeção binária solicitada ao conector não foi executada; a conclusão abaixo usa uma reprodução nova e a fonte Forge efetivamente presente no projeto.

## Reprodução com instrumentação, sem correção

Campanha: `run/coker-multiblock-campaign/20260913T042525Z-acc3586bd6f242feab33d87cd59e1298`.

| Instante | Chunk | Petcoke | isModified | needsSaving(true) | Tempo / último save |
|---|---|---:|---|---|---|
| Fim do ciclo | 6349,6250 | 128 | false | false | 0 / 0 |
| Fim do ciclo | 6350,6250 | 128 | true | true | 0 / 0 |
| Reinicialização | 6349,6250 | 0 | false | false | 0 / 0 |
| Reinicialização | 6350,6250 | 128 | false | false | 0 / 0 |

O ciclo produziu os 256 itens exigidos; exatamente o chunk sem elegibilidade de salvamento perdeu seus 128 itens. A asserção original de 256 na reinicialização falhou novamente. Energia, água, fases e resíduo mantiveram seus checks anteriores.

## Causa no ambiente de teste

A campanha executa loops manuais da TileEntity dentro de serverStarted e encerra o servidor antes de ticks normais do mundo. O relógio total permaneceu zero. Na fonte alvo, `Chunk.addEntity` define hasEntities, mas não isModified. `Chunk.needsSaving(true)` aceita o chunk se ele estiver modificado ou se tiver entidades e o relógio diferir do último salvamento. O chunk de saída sem mestre teve apenas novas entidades: não se tornou elegível nesse cenário artificial com relógio congelado.

Referências locais: `build/rfg/minecraft-src/java/net/minecraft/world/chunk/Chunk.java`, métodos addEntity e needsSaving; WorldInfo.incrementTotalWorldTime atribui o relógio total. A evidência não autoriza afirmar que qualquer perda de itens em gameplay teria essa mesma causa.

## Correção restrita à fixture

Antes do checkpoint do ciclo, o probe avança uma unidade do relógio total pela API WorldInfo, exige elegibilidade nativa de salvamento para ambos os chunks e verifica novamente os mesmos 256 itens. Não insere itens, não altera receitas, não marca chunks arbitrários como modificados e não reduz a asserção após o restart. A simulação de produção não foi alterada.

Uma primeira implementação chamou o nome SRG de World diretamente: compilou, mas a campanha `20260913T043456Z-9c791fec30b2401c80b0895943c1a188` falhou com NoSuchMethodError. Essa tentativa foi rejeitada; o acesso foi substituído pelo setter público verificado em WorldInfo. O resultado da campanha completa deve ser registrado separadamente após sua execução.

## Contraprova concluída — PASS da campanha de servidor

A campanha `run/coker-multiblock-campaign/20260913T044413Z-689a06f42a51465caf918d7c047de439` completou write, verify-cycle, verify-break e orientation-matrix e emitiu `COKER_UNIT_MULTIBLOCK_CAMPAIGN_PASS`, sem filtro de fonte.

A reinicialização registrou 128 petcoke em cada chunk, total 256, com tempo/último save 1/1. O gate de quebra/reforma conservou sete itens de inventário, uma cápsula, o NBT original do tubo e o cancelamento de publicação. A matriz de orientações foi concluída. Hash da região registrado pelo runner: `259ecc01524f3d8ad8975c1c1e7d163da83379111532a3e8c5308de497be4bd3`.

Isso fecha a falha reproduzida da campanha default de persistência e os subgates dessa execução. Não aprova receitas customizadas do Coker, qualificação Crucible/Java 21, cliente, arte final, mundo de produção ou atomicidade contra desligamento abrupto. Os mundos/logs das tentativas rejeitadas foram conservados e não substituídos pelo mundo aprovado.
