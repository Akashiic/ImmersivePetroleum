# Gas Generator — qualificação de runtime, wire e cliente

Base versionada: `7672529` (Hydrotreater qualificado). Frente: `feature/gas-generator-qualification-20260914T2100`.
Evidência consolidada: `run/gas-resumption-20260914T2110/final-qualification.json`.

## Fonte final

O digest qualificado é `1955232433ffbe348a6c47e14090c528db146a8c946efabd4ceee70829c716d2`. A suíte completa passou com **585 testes em 95 suítes**, zero falhas, erros ou ignorados e Checkstyle main/test sem apontamentos.

A campanha dedicada de três boots usa mundo UUID próprio e preserva todos os logs. `write` comprovou a receita survival, jerrycan IE real, placement pelos hooks Forge, 994 mB após o primeiro débito, 19 ticks pagos e 256 RF. `verify-break` comprovou reload, redstone, buffer cheio, conservação de RF, cancelamento de publicação e zero duplicação. `verify-reform` comprovou solver IE nativo, pickup, retomada e fronteira de chunk sem carregamento implícito (`chunkLoads=0`).

A região final tem SHA-256 `eec2196fd8206e3e25fc23aed473b5d0790d702b9b0a11eeda3108cf0da5e56f`. Nenhum marcador fatal FML ocorreu nos logs aprovados.

## Persistência fail-closed

Uma reprodução negativa mostrou que campos futuros do schema atual podiam ser aceitos e depois normalizados. `GasGeneratorState` agora rejeita campos top-level desconhecidos, preservando `fluidTag` como payload opaco do fluido.

O TileEntity preserva o envelope runtime completo em `invalidEnvelope` quando encontra dados incompatíveis. A whitelist contempla os campos vanilla de TileEntity e os campos herdados do conector IE (`prevPos`, `connectionList`, `limitType`) com tipos estritos. Booleanos runtime aceitam apenas bytes 0/1. Dados inválidos entram em quarentena e não autorizam geração, publicação ou wire output.

## Cliente Angelica

O cliente final passou com Angelica sobre o mesmo digest. O probe exercitou quatro orientações em estados ativo/inativo, item renderer, overlay e lifecycle do loop `immersiveengineering:dieselGenerator`. Cinco flags GL foram comparadas antes/depois da renderização. A captura final é única por UUID e foi revisada visualmente como fundação funcional, sem clipping evidente.

Screenshot final: `gas-generator-renderer-probe-a4add118-05cb-4d8b-8013-a512ba482bff.png`, SHA-256 `7c1dd6d797c21da11d453bf10b3666380ef96721f39eba338bc5757328802a8d`.

Duas campanhas cliente anteriores foram rejeitadas. A primeira falhou antes do probe em `SplashProgress`/Angelica; o runner agora desativa o splash somente durante o gate e restaura `splash.properties` byte a byte. A segunda chegou ao probe, mas a fixture posicionava a máquina na borda do raio auditivo de oito blocos; o teste foi corrigido para uma posição inequivocamente dentro do raio e verifica essa precondição antes de testar o som. Nenhuma dessas duas falhas foi promovida a PASS de produto.

`server.properties`, `eula.txt`, `options.txt` e `config/splash.properties` retornaram exatamente aos hashes anteriores à matriz final.

## Limites

Esta aprovação é de laboratório e não é release. Não foi executado Crucible/Java 21 com o modpack completo, multiplayer autenticado, mundo de produção copiado, shaders arbitrários, soak ou benchmark final. A captura valida a apresentação funcional inicial; não representa aprovação do acabamento audiovisual premium definitivo.

O solver de wire permanece o solver IE 0.7.9. A proteção adicionada evita carregamento de chunk causado pelo caminho Petroleum antes da reconstrução nativa, mas não converte callbacks de mods terceiros em transações atômicas nem promete custo constante para grafos arbitrários.
