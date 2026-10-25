# Homologação do checkpoint de transferência

Data: 2026-09-12. Este documento qualifica a fonte e delimita o que o sucessor pode considerar aprovado. **Não certifica o mod completo para produção.**

## Gate final da fonte — PASS

Com todas as frentes congeladas, o root executou no checkout principal:

```powershell
$env:JAVA_HOME = 'C:\Program Files\Java\jdk-1.8'
.\gradlew.bat check --no-daemon
```

- **Nenhum init script de exclusão foi usado.** Motorboat, os adaptadores NEI/MT, snapshots DT/Hydro, correção de colocação e lifecycle de áudio foram compilados.
- Resultado: **BUILD SUCCESSFUL**, exit code 0, duração reportada de 1m13s.
- **401 testes, 64 suítes; 0 falhas, 0 erros, 0 ignorados.** Totais calculados dos XMLs JUnit, não do número de arquivos Java.
- Checkstyle main/test: **0 apontamentos**, apurados dos relatórios XML.
- `compileJava`, `compileTestJava`, `test`, `checkstyleMain`, `checkstyleTest`, `jar` e `reobfJar` executaram. Tarefas de Minecraft/API sem fonte aparecem SKIPPED/NO-SOURCE pelo funcionamento normal do plugin; isso não é a exclusão temporária de famílias.
- Log: `run/handoff-full-check.log`, SHA-256 `afaea4ac837b6a51e2e50096f16a9db6cc918d04e320090764a05841fe1e0f69`.
- XMLs: `build/test-results/test`; relatórios HTML: `build/reports/tests/test`; Checkstyle: `build/reports/checkstyle`.
- Os resultados anteriores de 374 testes foram preservados em `run/handoff-prior-test-results-374`, pois o gate final sobrescreve o diretório padrão do Gradle.

Os avisos de APIs deprecated/unchecked e instalações Java antigas descobertas pelo Gradle não falharam o gate. O JDK da execução foi explicitamente selecionado. Não houve atualização automática do plugin Gradle ou troca da dependência IE.

## O que este PASS não demonstra

Compilar as classes opcionais não chama seus hooks, registra receitas, testa um cliente NEI ou valida MineTweaker em servidor. Compilar Motorboat não registra a entidade no bootstrap que ainda está pendente. Os testes de domínio não substituem eventos Forge, desenho na GPU, escuta ou jogadores conectados.

O gate final não executou `runServer` nem `runClient`. Portanto continuam abertos:

| Gate | Estado na transferência |
|---|---|
| Coker, campanha de quatro boots | **FAIL** no terceiro boot: `item persistence mismatch`; escrita/ciclo anteriores PASS. |
| Lubrificação, campanha completa | **FAIL** na montagem do Crusher; ajuste para mundo flat ainda sem rerun. Furadeira/NBT de fluido passaram antes da falha. |
| Colocação transacional Lube/Gas/Flare | Código/probes compilados; seis casos por família escritos; **runtime não executado**. |
| Novos codecs/snapshots DT/Hydro | Testes automatizados PASS; campanhas anteriores das máquinas precisam ser repetidas. API pública sintética `restorePending` tem lacuna documentada. |
| Motorboat/upgrades | 19 testes incluídos no total; hooks e campanhas de servidor/cliente pendentes. |
| NEI/MT | 8 testes incluídos no total; hooks de produção, scripts reais e cliente pendentes. Coker custom ainda ausente. |
| Seismic/Gas/Flare/World Fluids/Projector/Molotov | Probes disponíveis; campanhas novas completas não executadas nesta transferência. |
| Áudio Gas/Flare | Correção compilada; reload/mute/unmute/unload e escuta pendentes. |
| Cliente/arte/shaders/manual/pack/multiplayer/performance | **Sem aprovação final**; consultar plano e relatórios especializados. |

As falhas são parte da transferência e foram preservadas para reprodução. Não editar os marcadores esperados, retirar asserções ou substituir o JAR alvo para ocultá-las.

## Integridade e restauração do pacote

`tools/prepare-engineering-handoff.ps1` exige Git limpo, cria `repository.bundle` com histórico/refs, verifica o bundle e exporta `source-code.zip`. Copia documentos, dependência local, logs/mundos de laboratório, relatórios de teste e versões históricas. Os clones upstream são arquivados em suas revisões exatas para pesquisa local; isso não concede licença de redistribuição.

O preparador também restaura o bundle em um checkout separado, verifica HEAD, árvore limpa e objetos Git. O resultado e a identidade ficam em `handoff-manifest.json` e `restoration-verification.txt` no pacote. O SHA-256 de cada arquivo copiado é registrado em `SHA256SUMS.json`; `Verify-Handoff.ps1` confere tamanho, hash, caminhos e quantidade de arquivos. Somente após esse procedimento o root declara o pacote pronto.

O pacote é uma cópia **local**. Não foi solicitado nem realizado push/upload. Preserva fonte e evidência contra perda de contexto ou substituição acidental do checkout, mas não é uma cópia em outro dispositivo.

Os JARs de desenvolvimento copiados estão explicitamente sob `development-jars-NOT-FOR-PRODUCTION`. O checkpoint de engenharia não incrementa versão nem cria uma tag de release. Não usar esses JARs como substitutos da alpha.10 homologada anteriormente.

## Estado operacional no encerramento

As frentes foram instruídas a parar de editar Java/Gradle/testes antes do gate. Não há campanha de servidor/cliente iniciada para continuar automaticamente após o handoff. Os runners encerrados restauraram suas configurações pelo bloco finally. Não há automação, meta agendada ou delegação que deva continuar alterando este checkpoint.

O relatório principal contém a ordem de retomada; `HANDOFF-RESUME-PROMPT.md` é a mensagem pronta para entregar ao sucessor.
