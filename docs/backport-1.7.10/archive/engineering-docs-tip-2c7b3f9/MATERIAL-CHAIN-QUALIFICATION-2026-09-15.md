# Material Chain qualification — 2026-09-15

Base versionada: `e898344286bcaae23bbcd783cf66ef4c7bae3aa4` (Pumpjack/Reservoir qualificado).
Branch: `feature/material-chain-qualification-20260915T0150`.
Digest final da fonte: `d6daae003825b7168bf5d2220338d21bfb4afabd3ab62a50e1ceed977fab2a3f`.
Evidência consolidada: `run/material-chain-resumption-20260915T1200/final-qualification.json`.

## Escopo fechado

A frente fecha as adaptações 1.7.10 de materiais que ainda estavam explicitamente abertas no handoff antigo: Petroleum Candle original, Ersatz Leather, recipes de couro auditadas, concrete bucket físico e placement metadata transacional. O paraffin wax, petcoke, asphalt, steel/refinery/squeezer já existentes continuam usando os registros anteriores; esta frente não muda seu balanceamento.

Petroleum Candle usa apenas metadata: contagem 1–4 e bit de aceso, sem TileEntity/tick persistente. Cada vela acesa fornece 3 de luz, quatro velas fornecem 12; flint and steel e fire charge acendem, mão vazia apaga, e o drop conserva a quantidade empilhada. A colocação inicial e o stacking de metadata usam transações Forge canceláveis e rejeitam reentrada.

Ersatz Leather é um item IP próprio. O crafting auditado é oito IE hemp fabric ao redor de paraffin wax -> oito ersatz leather. `leather` registra couro vanilla e ersatz sem substituir metas IE existentes. Recipes explícitas permitem livro, item frame, quatro armaduras vanilla e oito conveyor belts IE; não há mutação global de recipes externas.

## Concrete e química material já suportada

A integração de concrete não se limita mais a lookup de recipe. O servidor executou o IE Bottling Machine nativo: dry concrete bucket + 1.000 mB de água -> 1.000 mB de concrete em 73 ticks e 584 RF no fixture fixado. O caminho survival também comprovou receita do balde seco e transferência parcial no Derrick: 250 mB consumidos, 750 mB retidos, sem duplicação.

O marker material existente permaneceu obrigatório e passou no mesmo mundo: quatro formas de asphalt, 4.000 updates estáveis, wax, graphite 8:1, Arc Furnace steel 400×512 e refinery gasoline 15+10 -> 25. Esses números são evidência do adaptador legado, não uma afirmação de equivalência energética total ao moderno onde IE17 não expõe os mesmos parâmetros.

## Gates finais

`material-chain-final-source-v2-20260915T1040`: `cleanTest check --no-daemon` completo, **598 testes em 98 suítes**, zero failures/errors/skips e Checkstyle main/test zero.

`material-chain-final-server-v2-20260915T1040`: campanha Derrick de quatro boots. O `write` confirmou recipes/placement/candle, concrete bottler, material runtime e integração Derrick. `verify-break` confirmou a vela persistida (`count=4`, `lit=true`, `light=12`, quatro drops, sem TileEntity) junto do drilling/pressure. Recovery/quarantine/handoff e orientação Derrick continuaram verdes. Região final SHA-256: `a30c5ead49df37126d7ca02ae61307cbfd1e00a8be71ed8f2486ad147970cf29`.

`material-chain-final-client-v2-20260915T1040`: cliente Angelica, marker `MATERIAL_CHAIN_CLIENT_PASS candles=8 counts=4 lit=true angelica=true glRestored=true item=true ersatz=true draws=3`. Screenshot final SHA-256 `f22ebc9ce6cfc42fdffbade9721262ce8aa69693a4471cf074039e42cdb3c9e4`, revisada sem clipping evidente. É fundação visual, não arte premium final.

A primeira campanha cliente (`material-chain-final-client-20260915T1030`) foi rejeitada: o renderer de inventário vazava `GL_LIGHTING` (2896). A correção restaurou o estado GL e somente a campanha v2 entrou na aprovação. A execução rejeitada permanece preservada; não foi promovida retroativamente a PASS.

## Regressões do helper compartilhado

`OwnedItemPlacement` passou a permitir stacks onde o chamador explicitamente usa `placeStackable` e ganhou exclusão mútua com `OwnedMetadataPlacement`. Por ser helper compartilhado, a frente reabriu três famílias previamente qualificadas. Todas foram repetidas sobre o mesmo digest `d6daae...`:

- Lubrication: `OWNED_ITEM_PLACEMENT_PASS ... cases=6 nativeForgeHooks=true packed=true`, fluid NBT, processo nativo, restart/break/reform e oito orientações.
- Gas Generator: o mesmo gate de placement em seis casos, survival/fuel/RF, pack/reload e wire solver com `chunkLoads=0` na fronteira descarregada.
- Flarestack: o mesmo gate de placement, survival/tank, 16 níveis analógicos, recovery/envelope exato e `boundaryChunkLoads=0`.

Os hashes finais de `server.properties`, `eula.txt`, `options.txt` e `config/splash.properties` voltaram byte a byte aos valores do checkpoint anterior. Nenhum JAR de dependência foi alterado.

## Limites

A adaptação de candle é deliberadamente não colorida e não implementa cake/waterlogging/dye variants inexistentes no target 1.7.10. Ersatz Leather cobre apenas as recipes explicitamente auditadas; não se afirma compatibilidade automática com todo mod externo que use couro. Phenol/acetaldehyde/phenolic-resin permanecem fora desta frente porque IE17 não fornece o catalyst/energy contract moderno necessário para uma porta fiel.

Crucible/Java 21, pack/mundo copiados, multiplayer autenticado, shaderpacks arbitrários, soak/benchmark e acabamento visual final continuam como gates externos. Não houve push, release ou instalação em produção.
