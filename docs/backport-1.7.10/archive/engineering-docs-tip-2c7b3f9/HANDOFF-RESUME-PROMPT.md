# Mensagem pronta para o próximo engenheiro

Assuma a responsabilidade pelo backport completo de Immersive Petroleum moderno para Minecraft Forge 1.7.10 em `C:\Users\User\Desktop\Codex\immersivepetroleum-backport\work\ImmersivePetroleum-1.7.10`.

Comece por `docs/HANDOFF-2026-09-12.md`, `docs/HANDOFF-VALIDATION.md` e pelos três relatórios especializados HANDOFF. Localize o pacote mais recente em `C:\Users\User\Desktop\Codex\immersivepetroleum-backport\engineering-handoff`; valide seu manifesto SHA-256 e a identidade Git antes de trabalhar. O pacote contém fonte, histórico, dependência IE exata, referências upstream e mundos/logs das campanhas, inclusive as falhas. Não descarte código WIP nem interprete um checkpoint como entrega do mod completo.

O último engenheiro parou por solicitação do cliente para preservar a continuidade antes do fim da cota. Há recursos implementados mas ainda sem hooks/runtime/cliente, e falhas explícitas no Coker e no cenário de lubrificação. Siga a fila de retomada documentada, reproduza as falhas, preserve as asserções de conservação e atualize a aprovação com evidência real. Confira o status final da compilação completa e dos testes no documento de validação; o antigo gate de 374 testes usava exclusões e não certifica o checkpoint inteiro.

Trabalhe autonomamente como responsável técnico, pesquise APIs nas fontes primárias e na dependência exata. Separe hipótese, teste de domínio, execução de servidor, inspeção de cliente e homologação do pack. Não prometa ganho de desempenho sem medições comparáveis, não altere produção durante testes e não instale dirty JAR. Conserve a qualidade visual e a funcionalidade. Use auditoria independente para mudanças de persistência, callbacks, rede, colocação/quebra e veículos.

O objetivo continua sendo o conjunto moderno completo e os critérios premium de DELIVERY-PLAN/FEATURE-MATRIX. Entregas parciais são marcos, nunca encerramento do pedido. Recalcule o percentual global apenas com um denominador explícito e evidência atual; os 35% registrados pertencem à baseline alpha.10.
