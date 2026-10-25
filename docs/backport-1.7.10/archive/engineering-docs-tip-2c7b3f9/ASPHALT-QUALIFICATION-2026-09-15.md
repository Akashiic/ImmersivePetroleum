# Asphalt — qualification checkpoint 2026-09-15

Base versionada: `9879cdcd91f7bd9b3fc650024b04adebe5ff8fe3` (Catalyst Refinery).
Branch: `feature/asphalt-qualification-20260915T1840`.
Digest final qualificado: `05624b1386ace3c8ff7ff56c659b0db7d3f2a9f521fca857998a84df779df09b`.
Evidência consolidada: `run/asphalt-resumption-20260915T1950/final-qualification.json`.

## Escopo fechado

A família Asphalt mantém os quatro formatos de superfície já existentes: bloco, slab inferior/superior/double slab e stairs. O comportamento de movimento continua server-authoritative pelo atributo vanilla `movementSpeed`, com modifier transitório não salvo e UUID único para impedir empilhamento.

Com `asphaltSpeed=true`, todas as superfícies Asphalt produzem fator efetivo **1.20×**. O probe servidor repetiu a atualização 1.000 vezes em cada um dos quatro formatos sem acumular modificadores. Com `asphaltSpeed=false`, o modifier é removido. Sair do chão também remove o modifier. Paraffin Wax preserva o contrato independente de **0.95×** e `slipperiness=1.05`.

A alteração desta frente não mudou a matemática da velocidade: o valor `0.20D` foi apenas centralizado em `ASPHALT_SPEED_FACTOR=1.20D` para compartilhar a mesma fonte de verdade com a apresentação cliente.
## ItemBlocks e tooltip moderno

A reprodução negativa `asphalt-client-tooltip-red-20260915T1902` mostrou o defeito cliente real: o bloco “Asfalto” não exibia a informação moderna de velocidade. A execução falhou com fonte inalterada e a mensagem `modern Asphalt speed tooltip missing for Asfalto` foi preservada.

O bloco completo e as stairs agora usam `ItemAsphaltBlock`; a slab usa o seu `ItemAsphaltSlab`. Os três delegam a `AsphaltItemTooltip`, que mostra a percentagem derivada de `ASPHALT_SPEED_FACTOR`, não uma constante duplicada. O tooltip desaparece quando `asphaltSpeed=false`.

As traduções PT-BR e EN-US usam `desc.immersivepetroleum.flavour.asphalt` e interpolação formatada. O probe cliente validou os três ItemBlocks, seis formas renderizáveis, config ON/OFF, seis draws e restauração de cinco flags GL com Angelica ativo.

## Gates finais

A mesma fonte passou `611 testes / 100 suítes`, zero failures/errors/skipped e Checkstyle main/test zero. A campanha Derrick/material de quatro boots repetiu `PETROLEUM_MATERIAL_RUNTIME_PASS roadForms=4 stableUpdates=4000 wax=.95` e os gates de lifecycle/orientação já existentes. O cliente premium repetiu `ASPHALT_CLIENT_PASS forms=6 items=3 tooltip=true disabledTooltip=true draws=6 angelica=true glRestored=true`.

A região final possui SHA-256 `405362e0fe27017f18153fb2fa01b57b74cb1c488928ad307d12dd0f66ace0c4`. A captura cliente possui SHA-256 `5cc81f1ba1445932c12ab614867ad3f29ee720e6f48ff5cbbcd4e2d6c12d4bfd`. `server.properties`, `eula.txt`, `options.txt` e `splash.properties` retornaram byte a byte aos hashes qualificados anteriores. Nenhum marcador fatal FML apareceu nos logs finais.

A captura é qualificada como fundação visual funcional: o item está legível e as seis formas foram verificadas pelo probe/GL, mas não se declara arte/textura premium final. Crucible/Java 21, pack/mundo reais, multiplayer autenticado, shaderpacks arbitrários, soak, benchmark e acabamento visual final continuam fora deste checkpoint.
