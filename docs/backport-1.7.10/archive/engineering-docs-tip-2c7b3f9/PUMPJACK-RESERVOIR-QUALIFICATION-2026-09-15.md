# Pumpjack + Reservoir — qualificação de extração e persistência

Data: 2026-09-15. Linha base versionada: `0b7ac71e19133c07c76d04235693b21ed5537ec7`.
Branch de trabalho: `feature/pumpjack-reservoir-qualification-20260915T0030`.
Digest final da fonte qualificada: `23e2e88adbbc32e91b86bfb8a8028ae4c159a0bba23e1ecd7fc7a6371f4a9f93`.
Evidência consolidada: `run/pumpjack-resumption-20260915T033556Z/final-qualification.json`.

## Gates finais

A mesma fonte passou nos seis gates finais, todos com `source_unchanged=true`:

- `pumpjack-visible-final-source-20260915T0130`: source-check integral.
- `reservoir-genesis-camera-final-20260915T0135`: gênese determinística e mutação controlada.
- `reservoir-persistence-camera-final-20260915T0140`: persistência, corrupção fail-closed e recuperação.
- `pumpjack-kernel-camera-final-20260915T0145`: kernel transacional do Pumpjack.
- `pumpjack-multiblock-camera-final-20260915T0145`: runtime, lifecycle e matriz estrutural.
- `pumpjack-visible-final-client-20260915T0130`: cliente Angelica e TESR real visível.

O source-check final contém **594 testes em 97 suítes**, com zero falhas, erros ou ignorados. Checkstyle main/test: zero apontamentos.

## Reservoir genesis

O cenário final criou e reabriu o mesmo reservatório no alvo `100079,100000`, com âncora `100053,99972`, tipo `immersivepetroleum:oil` e capacidade `20.450.302 mB`.

Após a mutação controlada, a quantidade persistida foi `20.449.068 mB`; o reservatório não foi regenerado nem reinterpretado como um depósito novo. O shard final possui SHA-256 `afecf49cb33f6c401f43f881e143eda6449beb7177831a3ad40c7a3709a61edc`.

A campanha exerceu `write`, `verify` e `verify-mutated` em boots separados. Os logs aceitos não contêm os marcadores fatais FML usados pelos runners.

## Reservoir persistence

A campanha final preservou o shard válido com SHA-256 `9e9d4b16e2a6600d7ec9b1256c0c917ce60eeb0cdcf1ae402c8d4a2198ec76f5`.

O arquivo foi então corrompido deliberadamente, produzindo hash `a186a1cea95d58343c5b056b18fef1c750a1612ef955e08bf6b426a75d3ef141`. Esse boot **deve falhar fechado** e contém `Caught exception from immersivepetroleum`; ele é evidência negativa esperada, não um PASS nem uma regressão aceita. O runner restaura a cópia válida e um boot posterior comprova recuperação.

Assim, a aprovação exige simultaneamente: estado válido legível, corrupção detectada, ausência de aceitação silenciosa do arquivo adulterado e recuperação posterior do shard válido.

## Pumpjack runtime e multiblock

O boot principal confirmou `30 mB` de óleo por dois ticks pagos e `2048 RF` debitados, com cache de taps construído uma única vez e bloqueio por redstone. O teste de tubo coberto foi rejeitado sem mutação nem drops adicionais.

A integração de lubrificação executou dez ticks efetivos contra oito ticks normais, consumindo `10.240 RF`, produzindo `150 mB` e debitando seis unidades de lubrificante, sem reconstruir o cache de taps.

A matriz estrutural aprovou **8 casos de orientação/espelhamento**, com **32 partes por caso**, incluindo desmontagem. Os boots separados `write`, `verify-break` e `verify-reform` também passaram.

A região final do mundo de prova possui SHA-256 `7dd2355e4ac1eaff648401616385e1fe15093956525e642705d1f04da6bccc0b`.

## Cliente e evidência visual

O cliente final passou com Angelica e `37` draws, verificando restauração de texture, cull, lighting, depth e blend.

Duas capturas anteriores foram rejeitadas durante a auditoria: a primeira nasceu dentro de folhas/terra e a segunda mostrava somente o mundo flat. A fixture foi corrigida para instalar um master Pumpjack real no mundo e deixar os draws sintéticos fora da frustum.

A captura final `pumpjack-renderer-probe-30ae4b7c-7bf3-4031-8c42-c8628437cf84.png` possui SHA-256 `1ab4e256207674f1493b09245183dfef09d8a25b6580520afe634c11e82a413a` e foi revisada visualmente: máquina completa visível, sem clipping evidente.

## Configuração e limites

`server.properties`, `eula.txt`, `options.txt` e `config/splash.properties` foram comparados por SHA-256 e retornaram byte a byte ao checkpoint anterior após as campanhas.

Nenhum JAR de dependência foi modificado, nenhum mundo de produção foi tocado e nenhum resultado negativo intermediário foi promovido retroativamente a PASS. Os artefatos e mundos de laboratório permanecem em `run/`, fora do commit de código.

Esta qualificação não demonstra ainda comportamento no pack completo sob Crucible/Java 21, multiplayer autenticado, mundo copiado de produção, shaderpacks arbitrários, soak prolongado ou benchmark de TPS/FPS. A inspeção foi realizada pelo mesmo agente; não há auditor independente externo.

Com esses limites, Reservoir genesis/persistence e Pumpjack deixam de ser apenas implementados e passam a **qualificados no laboratório da linha atual**.
