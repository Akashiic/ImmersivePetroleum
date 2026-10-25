# Well / WellPipe — qualificação de infraestrutura

Data: 2026-09-14. Base versionada: `58f7b7bd03c1894a95c35a4481673a448754b46e`.
Fonte final qualificada: `fe995100744cc30189c798f4f630a1a3258a247c7ab50e76072ff664e2165316`.
Evidência consolidada: `run/well-resumption-20260914T1640/qualification.json`.

## Escopo aprovado no laboratório

O Well continua sendo o dono persistente da topologia e do progresso de perfuração. WellPipe permanece um conector vertical sem estado próprio e não cria ItemBlock ou drops. Um item IE pipe mantém seis unidades virtuais, o alvo base permanece 384 e o grid máximo continua 69×69.

A campanha final cria o Well e três segmentos físicos, preserva três taps com ordem e duplicata intencional, reinicia, remove o segmento intermediário e prova que o segmento superior não atravessa a lacuna para obter conectividade. Um terceiro boot confirma que a remoção persiste.

A sequência de autodestruição mantém a semântica moderna `timer-- <= 0`: são 6.001 avanços até o gatilho. Os dois segmentos ainda conhecidos passam para metadata broken e o anchor Well é restaurado para bedrock. O cenário não concede drops aos blocos internos.

## Integridade de persistência

O schema 1 agora recusa campos desconhecidos no envelope e nos elementos de `tappedColumns`, em vez de aceitar informação que seria silenciosamente descartada no próximo save. Os três booleanos persistentes exigem byte canônico 0 ou 1. Schema futuro continua falhando fechado e o TileEntity conserva o payload opaco em quarentena.

A reprodução negativa `well-envelope-red-20260914T1640` teve seis testes e cinco falhas esperadas: os cinco contratos acima eram aceitos pela implementação anterior. O gate positivo preservou também os diagnósticos específicos para campos obrigatórios ausentes ou com tipo incorreto.

## Custo de persistência do self-destruct

O `TileEntity.markDirty()` de Forge 1.7.10 marca o chunk e também executa a atualização de comparadores. O timer de autodestruição chamava esse método uma vez por tick durante toda a janela. O teste negativo `well-hotpath-red-20260914T1640` confirmou uma chamada no caminho quente.

Somente `advanceSelfDestructTimer()` passou a usar `markTileEntityChunkModified` diretamente. As mutações esporádicas do Well continuam usando a semântica anterior. O teste bytecode exige zero `markDirty` nesse método, presença do helper local e uma única chamada de marcação do chunk proprietário.

## Gates finais

`well-final-source-20260914T1640` e `well-final-native-20260914T1640` terminaram com exit code zero, `source_unchanged=true` e o mesmo digest final.

`cleanTest check --no-daemon`: **572 testes em 92 suítes**, zero falhas, erros ou ignorados; Checkstyle main/test zero. Os relatórios finais foram preservados em `run/well-resumption-20260914T1640/qualified-junit` e `qualified-checkstyle`.

Campanha nativa: `20260914T201243Z-e578a4f57df34cd78d5e16832d93abb7`. Marcadores: `WELL_WRITE_PASS`, `WELL_BREAK_PASS`, `WELL_SELF_DESTRUCT_PASS` e os três `WELL_INFRASTRUCTURE_PROBE_PASS`. SHA-256 da região: `4e275595be3c895ae7b1f39b958682df43345ba673796978d641df88bd389042`.

`server.properties`, `eula.txt` e `options.txt` retornaram exatamente aos hashes do checkpoint anterior. Nenhum marcador FML fatal exigido pela auditoria apareceu nos logs finais.

## Limites

Well e WellPipe são infraestrutura escondida, sem ItemBlock ou renderer público; por isso não existe gate cliente próprio desta família. Sua apresentação é exercitada indiretamente pelas máquinas que os controlam, especialmente Derrick/Pumpjack.

A campanha certifica os cenários registrados, não atomicidade entre todos os arquivos numa queda abrupta do host. Crucible/Java 21, pack completo, cópia de mundo real, multiplayer autenticado, soak e benchmarks continuam separados. A revisão foi realizada pelo mesmo assistente; não há auditor externo independente alegado. Nenhum JAR ou mundo de produção foi alterado e nenhuma release foi emitida.
