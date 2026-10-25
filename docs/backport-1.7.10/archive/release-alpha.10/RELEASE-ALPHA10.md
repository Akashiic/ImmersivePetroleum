# Immersive Petroleum 0.1.0-alpha.10

O Derrick passa a ter uma implementação funcional de perfuração e extração sob pressão para Forge 1.7.10, com painel de operação, render original e persistência. Esta é uma entrega de desenvolvimento com escopo aprovado por campanhas; a versão premium completa continua em construção.

## Entregue

- Estrutura moderna de 59 blocos, quatro orientações e espelhamento, formação e desmontagem com preservação do NBT original.
- Perfuração física e virtual, consumo de tubos/concreto/água/energia e liberação de pressão com contabilização de entrega e derramamento.
- Poço concluído reutilizável pela Pumpjack, tanque de 8.000 mB e buffer de 16.000 RF.
- Painel para tubos, energia, fluido, profundidade e estado; validação de distância e transações de inventário no servidor.
- Render original com geometria construída uma vez, animação da perfuração e desenho somente pelo mestre.
- Quarentena para dados inválidos, preservação de payloads futuros e registro de recuperação para diagnóstico.
- Controles de configuração para a operação de Derrick, Pumpjack e Distillation Tower.
- Correção de duplicação de coberturas de tubos IE nas três estruturas. Remova as coberturas antes de formar; cor e configuração das faces continuam preservadas.

## Evidência de aprovação

245 testes JUnit passaram, sem falhas, erros ou testes ignorados. Os testes dedicados incluíram 12 inicializações para as três máquinas, mais duas para registro normal/colisão do concreto. A revisão independente conferiu os resultados, os hashes dos mundos e os 138 arquivos usados na campanha final.

O cliente com Angelica passou por 21 chamadas de render verificadas e pelas capturas do modelo e do painel. O painel foi inspecionado com dados sintéticos; o teste de inventário no servidor foi separado. Isso ainda não homologa uma sessão multiplayer real.

Identidade do commit, tag, JAR e hashes finais ficam no `BUILD-AUDIT.md` e em `SHA256SUMS.txt` do pacote. Os detalhes dos cenários, falhas rejeitadas e correções estão em [G6-EVIDENCE.md](G6-EVIDENCE.md).

## Limites desta alpha

Ainda faltam editor direcional da grade, produção survival de concreto, exploração sísmica, Oil Tank, restante da refinaria e utilidades, veículos, integrações de manual/NEI/CraftTweaker, arte e áudio finais. Migração de um mundo do modpack, multiplayer, shaders ativos e medições comparáveis de desempenho também estão pendentes. A transição de pressão para Pumpjack foi preparada pela API na fixture; a campanha não mede todo o tempo natural de esgotamento.

O ambiente de referência usa Forge 10.13.4.1614, o JAR IE 0.7.9 congelado do projeto, GTNHLib 0.11.41, Angelica 2.2.8 e UniMixins 0.3.1. O artefato tem bytecode Java 8. A aprovação de uma feature completa dependerá também dos cenários reais ainda abertos.

[Guia de montagem e operação](DERRICK-ALPHA10-OPERACAO.md) · [Plano de entrega](DELIVERY-PLAN.md) · [Roadmap](ROADMAP.md)
