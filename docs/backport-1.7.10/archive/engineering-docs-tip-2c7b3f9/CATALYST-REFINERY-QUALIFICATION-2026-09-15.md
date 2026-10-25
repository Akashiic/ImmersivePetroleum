# Catalyst Refinery — qualificação 2026-09-15

Base versionada anterior: `1ec598d` (`Qualify legacy material chain and transactional placement`).
Branch de trabalho: `feature/catalyst-refinery-20260915T1300`.
Digest final qualificado: `268efe6c65afbea0ef5cdae8290408b189d998703afb50df7c873259ca534120`.

## Escopo fechado

A Refinery do IE 0.7.9 foi adaptada para os contratos modernos congelados em
`upstream/ImmersivePetroleum-1.21.1/src/datagen/.../IPRecipes.java`:

- gasolina: 15 mB naphtha + 10 mB benzol -> 25 mB gasoline, energia 80;
- `refinery/phenol`: 5 mB benzol + 5 mB petroleum_gas -> 10 mB creosote IE,
  energia 240, catalisador redstone;
- acetaldeído: 15 mB petroleum_gas -> 15 mB acetaldehyde, energia 120,
  catalisador plateConstantan.

O nome `phenol` é o ID moderno da receita. O resultado moderno congelado é o
creosote do IE; o backport não inventa um novo fluido phenol para 1.7.10.
Catalisadores participam da admissão da receita e não são consumidos pelo processamento.

A adaptação adiciona o fluido acetaldehyde, seu bloco/balde/localização e mantém
as receitas IE legadas disponíveis depois de testar primeiro os contratos modernos.

## Transformer IE 0.7.9

`PetroleumRefineryTransformer` reconhece apenas as classes e formatos congelados.
No TileEntity ele transforma a inventory de 6 para 7 slots, o `readInventory`,
a consulta de receita, custo de energia e as duas comparações de FluidStack.
No Container ele adiciona o slot 6 em `(73,26)` e atualiza `slotCount` para 7.

O transformer é idempotente para o bytecode já transformado e falha fechado quando
a forma da classe não corresponde ao artefato fixado. Ele aceita explicitamente as
formas MCP/SRG usadas no laboratório, incluindo `updateEntity`/`func_145845_h` e
`addSlotToContainer`/`func_75146_a`; qualquer terceiro nome é rejeitado.

A campanha negativa `catalyst-refinery-native-v3-20260915T1810` demonstrou um
`NoSuchMethodError` quando a fixture emitia `func_75146_a` contra o Container MCP.
As suítes RED seguintes exigiram suporte explícito aos dois nomes:

- `catalyst-refinery-dual-name-red-20260915T1800`: 609 testes, 1 failure;
- `catalyst-refinery-slotname-red-v2-20260915T1820`: 611 testes, 2 failures.

Somente os checks GREEN posteriores e a campanha final entram na aprovação.
Nenhuma dessas execuções negativas foi promovida retroativamente a PASS.

## Matriz final aprovada

O source-check `catalyst-refinery-final-source-v2-20260915T1842` passou com
**611 testes em 100 suítes**, zero failures, errors ou skipped, com fonte inalterada.

A campanha `20260915T213254Z-44d11dd60f4f4fe3810e0d8d060b0c0d` executou dois
boots dedicados no mesmo digest. O primeiro confirmou acetaldehyde, catálogo moderno,
slot catalisador, execução nativa, custos 80/240/120 e persistência do catalisador.
O segundo confirmou restart com inventory de 7 slots, energia 1234, tank 7,
catálogo estável e operação pelo tanque oposto.

O cliente `catalystrefinery-20260915T213052Z-42b3877738344882ab45ab098cb6c7b9`
passou no mesmo digest com Angelica: Container/GUI nativos com 43 slots totais,
slot catalisador index 6 em `(73,26)`, acetaldehyde registrado/localizado e bucket/bloco
presentes. A captura UUID foi hasheada como
`5da5bf5338321e6096ff9f5509bce3ac0f07d875b2775c1bd0ada8c94b4777e9`
e foi inspecionada sem clipping evidente.

`server.properties`, `eula.txt`, `options.txt` e `config/splash.properties` retornaram
byte a byte aos hashes anteriores. Nenhum fatal FML esperado apareceu nos gates finais.
Os arquivos de região do mundo dedicado foram preservados e hasheados.

## Limites

Esta é qualificação de laboratório da compatibilidade Catalyst Refinery. Não comprova
Crucible/Java 21, pack/mundo copiados de produção, multiplayer autenticado, shaderpacks
arbitrários, soak/benchmark ou acabamento visual final. O JAR IE original não é editado;
a adaptação ocorre pelo transformer estrito do addon.
