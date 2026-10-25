# Motorboat — integração e qualificação inicial, 2026-09-13

Base: `647531516fa5e4d395bbd5354d7262320aeb1834`; alterações de integração recebidas e preservadas em `run/premium-continuation-20260913T085509Z/incoming-source`.

## Resultado confirmado

- Hooks de registro, receitas, cliente, rede e encerramento integrados; seis receitas e cinco upgrades presentes.
- `cleanTest check --no-daemon`, sem filtros: **408 testes, 66 suítes, zero falhas/erros/ignorados; Checkstyle sem apontamentos**. Recibo `run/guarded-tasks/motorboat-head-safety-check-20260913`.
- Servidor: campanha `motorboat-multiblock-campaign/20260913T091354Z-be9a939f7e754e4a8938d766f325a8b0`, três boots, `MOTORBOAT_CAMPAIGN_PASS`. Combustível 1000→970, dois passageiros, entrada autorizada/replay, bancada, recipientes adversariais, cancelamento/reentrada de coleta, persistência/reinstalação e ré.
- Região conferida SHA-256: `429d24c43ec6dbdd27dff1fb82ca555cb18757698de1e16084064ad901a6d094`.
- Cliente: `motorboat-client-20260913T091814Z-3cc1421d68174b65b43f032b572a25dd.stdout.log`; `MOTORBOAT_CLIENT_CAMPAIGN_PASS`, 104 chamadas em 26 combinações/quatro orientações, lifecycle lógico do som.
- Captura inspecionada: `run/screenshots/motorboat-renderer-a26587a5-cd13-4bba-accd-159d40b0b7c5.png`. Seis modelos completos visíveis, sem cortes; a vista predominantemente traseira/distante não certifica detalhes de todos os upgrades nem arte final.

## Defeito real encontrado e corrigido

A campanha anterior falhou em montaria com `NoSuchMethodError: EntityLivingBase.setRotationYawHead(F)V`. O método na fonte Forge alvo (`build/rfg/minecraft-src/java/net/minecraft/entity/EntityLivingBase.java`, linhas 2263–2270) tem `@SideOnly(CLIENT)` e é removido no servidor. A implementação usa agora o campo público `rotationYawHead`, conservando o mesmo efeito sem invocar API removida. `MotorboatSideSafetyTest` impede a reintrodução dessa chamada na orientação do passageiro. A falha original permanece em `motorboat-multiblock-campaign/20260913T090459Z-d4633abf9b094423b2d95ff1218fcd8b`.

O ajuste anterior da receita usa `treatedStick`, registrado pelo IE fixado. O ator do probe usa EntityPlayer nativo sem conexão; não é uma sessão multiplayer autenticada.

## Limites preservados

O som foi exercitado logicamente pelo probe; não houve escuta humana nem certificação acústica. Reload/mute/unmute e multiplayer reais continuam exigindo campanha específica. A imagem aprova a fundação visível, não arte premium final ou shaderpacks ativos.
Os deltas de semântica anotados no handoff (colisão em modo remos, dano direto, altura em lava, queda e ângulo de hélice de longa duração) não foram encerrados por esta campanha. Não anunciar paridade irrestrita.
Não há aprovação de Crucible/Java 21, pack completo, benchmarks, mundo de produção ou release. A revisão desta rodada foi do próprio implementador com testes adversariais, não auditoria independente externa.

A continuidade segue para integrações de receitas e famílias ainda sem runtime; este documento não encerra o objetivo do projeto.
