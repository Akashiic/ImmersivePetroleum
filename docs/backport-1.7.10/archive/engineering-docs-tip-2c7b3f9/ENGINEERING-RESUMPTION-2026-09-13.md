# Retomada de engenharia — 13 de setembro de 2026

Base preservada: `db6b77d63c91696ed492b8d069d529cda450a9ee`.
Branch desta frente: `feature/hydro-persistence-hardening-20260913`.

## Mandato e produto

O usuário autorizou continuar o backport moderno completo e premium, não somente uma alpha industrial. Mantêm-se FEATURE-MATRIX, DELIVERY-PLAN e os contratos de conservação, persistência, autoridade do servidor e apresentação original. Não há autorização para modificar binários ou mundos de produção durante desenvolvimento.

## Ambientes que não podem ser confundidos

| Camada | Contrato de continuidade |
|---|---|
| Servidor de destino | Crucible 1.7.10 com Java 21, explicitamente confirmado pelo usuário. Exigir build/hash exatos do Crucible, JVM, bibliotecas e plugins no laboratório de homologação. |
| Build do addon | Preservar bytecode Java 8 e APIs Forge 10.13.4.1614; não elevar o requisito do cliente apenas porque o servidor usa Java 21. |
| Laboratório legado | Forge/Java 8 conserva valor como regressão e isolamento de defeitos; seu PASS não substitui Crucible/Java 21. |
| Cliente | Angelica 2.2.8, GTNHLib 0.11.41, Hodgepodge 2.7.189 e UniMixins 0.3.1 são referências do inventário congelado; qualificar a JVM efetivamente usada no cliente separadamente. |
| IE | Manter `ImmersiveEngineering-garden-cloche-test-2.jar`, SHA-256 `51cf081e5a7c9e92dc9ede65021ba2befbdd17971a070d7f26f8c83839c4ac2e`. |

A presença de uma biblioteca no ambiente não transforma automaticamente todas as suas APIs em dependências obrigatórias do addon. Não atualizar versões, adicionar mixins ou substituir o coremod estreito existente sem necessidade demonstrada e revisão de interferências.

Fontes primárias consultadas nesta retomada: README oficial de CrucibleMC/Crucible (suporte declarado Java 8–21); LegacyModdingMC/UniMixins (loader); GTNewHorizons/GTNHLib (biblioteca); GTNewHorizons/Hodgepodge (patches); GTNewHorizons/Angelica (renderização e compatibilidade). Esses documentos confirmam os papéis gerais, não aprovam a combinação deste modpack.

## Inspeção e aprovação

Toda alteração deve registrar problema/reprodução, fronteira responsável, hipótese explícita, teste negativo antes do patch, teste positivo depois e regressões aplicáveis. Uma hipótese orienta investigação; não é um resultado aprovado.
Revisão de código, testes automatizados e homologação são etapas distintas. Auto-revisão adversarial não deve ser descrita como auditoria independente. Revisão independente só é registrada quando outro revisor efetivamente examinar a alteração.
Uma falha conhecida de conservação, persistência, autorização, carga lateral ou lifecycle bloqueia a aprovação da frente. Não reduzir asserções para obter PASS. Ausência de defeitos conhecidos não constitui promessa de ausência de defeitos desconhecidos.

## Estimativa atual, não homologação

Estimativa de engenharia: aproximadamente **45%**, faixa comunicada **40–50%**, para o produto completo. Mantêm-se os pesos de TOTAL-PROGRESS; os intervalos abaixo são julgamentos de execução, não medições objetivas ou porcentagens de features aprovadas.

| Frente | Peso | Execução estimada | Evidência e limites |
|---|---:|---:|---|
| Infraestrutura, persistência e confiabilidade | 20% | 70–85% | Fundação testada; novos snapshots e caminhos de publicação ainda exigem regressão e mundo real. |
| Extração, refino e armazenagem | 35% | 50–60% | Máquinas base e campanhas adicionais existem; Coker falha e contratos/homologação da refinaria permanecem abertos. |
| Exploração e utilitários | 15% | 25–40% | Implementação e testes parciais; campanhas/colocação/cliente não concluídos. |
| Mobilidade e itens restantes | 10% | 10–20% | Motorboat escrito/testado em domínio, mas sem hooks/runtime; materiais e adaptações incompletos. |
| Apresentação, UX e documentação | 10% | 20–30% | Renderizadores iniciais e documentação; arte/som/NEI e inspeção final pendentes. |
| Homologação e desempenho | 10% | 5–15% | Probes de laboratório; Crucible/Java 21, pack/plugins, jogadores reais e benchmarks finais ainda não aprovados. |

Cálculo ponderado: mínimo 38,75%, máximo 50,5%, centro 44,625%; arredondamento deliberado para evitar falsa precisão. Restam aproximadamente 55% do escopo ponderado, não necessariamente 55% do tempo. O valor histórico de 35% pertence à alpha.10; esta é uma nova estimativa sobre o checkpoint posterior e não uma reescrita daquele histórico.
Não há previsão de calendário sustentada por velocidade histórica e gates estabilizados. O percentual não autoriza instalação do JAR em produção.

## Ordem de execução

1. Reproduzir e fechar o uso inválido de restorePending no Hydrotreater em camada de domínio; preservar o rollback de saídas realmente processadas e o schema existente.
2. Validar a colocação nativa Lube/Gas/Flare e diagnosticar Coker/lubrificação nos mundos preservados, sem enfraquecer asserções.
3. Integrar os hooks e lifecycle de Motorboat e NEI/MineTweaker, então executar ausência/presença de dependências e processos reais.
4. Fechar famílias restantes e demonstrar a jornada survival completa; completar apresentação/áudio e adaptações necessárias ao legado.
5. Homologar o mesmo artefato em Crucible/Java 21, cliente real e cópia do pack/mundo; testar plugins de proteção, multiplayer, shaders, reload, desempenho e soak.
6. Somente aprovar release após evidências por frente, build limpo, identidades, migração e rollback. Nenhum novo PASS de runtime é concedido neste plano.

A retomada usa operações locais limitadas e campanhas serializadas pelo mutex existente. Logs/evidências são preservados em `run/resume-hardening-20260913T032221Z`. O relatório de resultados desta frente deve discriminar execução de testes, cache Gradle, falhas esperadas e limites de auditoria.
