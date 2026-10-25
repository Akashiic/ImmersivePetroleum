# Reload de receitas e integridade de NBT — 13/09/2026

Base: `c23571f551680a50b1a9f0b14adb52f0a86c61f7`. Escopo: Distillation Tower e Hydrotreater, livros de receitas, codecs de estado e undo MineTweaker. Não é uma release do mod completo.

## Decisões implementadas

Receitas inativas podem receber nova definição sob o mesmo ID. Alterar um contrato ainda ativo exige desativá-lo primeiro. Ambiguidade de entrada é verificada antes de modificar o catálogo. Novas admissões usam a definição atual; processos schema 2 conservam o snapshot imutável já admitido.

Cada livro mantém separadamente sua primeira definição por ID para interpretar schema 1. Não é uma lista ilimitada de revisões: o histórico retido é uma definição inicial por ID, além da definição atual. Os snapshots schema 2 são independentes da disponibilidade dos scripts no próximo boot.

Limite da migração: schema 1 contém somente ID, não uma definição completa. O arquivo inicial do catálogo preserva o comportamento conhecido no mesmo ciclo de vida e os defaults congelados. Não reconstrói arbitrariamente um script histórico desconhecido que tenha sido alterado antes da criação desse catálogo. Não anunciar recuperação universal de contratos antigos sem informação persistida.

O undo do adaptador MineTweaker retém o objeto removido, em vez de procurar novamente o ID depois que outro contrato foi registrado. A reversão de uma adição recusa retirar uma definição substituída fora da ordem de undo. Captura e mutação usam o mesmo monitor do livro.

Os codecs rejeitam tipos incorretos, campos desconhecidos nos envelopes, saídas duplicadas, excesso de capacidade e mistura de snapshots schema 2 dentro de schema 1. Listas vazias nativas permanecem válidas. O codec não modifica o NBT rejeitado; o tratamento de quarentena da TileEntity continua sendo a fronteira de preservação.

## Reprodução e check integrado

A suíte inicial tinha 419 testes e sete falhas. Um dos testes usava por engano `distillation/oil`; o ID real é `distillationtower/oil`. Corrigido somente o ID do teste, a reprodução voltou a apresentar sete falhas, agora sem o NullPointerException desse erro de fixture. Nenhuma mudança de produção existia na reprodução corrigida.

O primeiro check após o patch encontrou uma falha de compatibilidade na mensagem de overflow esperada pela suíte antiga. O diagnóstico voltou a conter `invalid output tank`; a asserção existente não foi removida.

Gate final `recipe-integrity-sourcecheck-v2-20260913`: **419 testes / 69 suítes, zero falhas, erros ou ignorados; Checkstyle main/test zero**. `cleanTest check --no-daemon`, sem filtros, exit code 0 e digest de fonte inalterado. São nove métodos novos em relação ao checkpoint de 410 testes; não se contabilizam cenários internos como testes adicionais.

## Campanha real com MineTweaker

Campanha aprovada: `run/recipe-compat-campaign/20260913T114925Z-dd78a7dd2c894757921af68d50905213`, tarefa durável `recipe-integrity-runtime-20260913`. Dois boots, exit code 0, fonte inalterada, perfil CT 3.4.8 com o IC2 fixado do pack.

No primeiro boot, as duas máquinas formadas iniciam contratos de cinco ticks. Um reload troca os mesmos IDs por definições de dez ticks com 70 mB de saída e diamantes. As máquinas conservam seus contratos admitidos de 40 mB e pedras, no progresso 2/5. Outro script substitui os IDs de duas receitas nativas; o undo restaura os objetos originais e suas entradas, sem deixar admissão de água indevida.

No segundo boot, sem os scripts sintéticos, as máquinas concluem os contratos originais: 200 mB de entrada, 80 mB de saída, três pedras e 200 RF consumidos. Foram exigidos os marcadores antigos e os novos `RECIPE_REPLACEMENT_SNAPSHOT_PASS` e `RECIPE_REPLACEMENT_UNDO_PASS`; os logs brutos foram conferidos após a execução.

`server.properties` e `eula.txt` correspondem aos hashes anteriores. O driver não mudou durante a campanha. Onze arquivos de região do mundo novo foram hasheados como evidência desta execução, não como invariantes entre execuções. O recibo consolidado está em `run/recipe-integrity-20260913T110439Z/qualification.json`.

O defeito externo de nomes duplicados de tipos no CT permanece explicitamente classificado; os demais erros de script reprovam a campanha. IC2 continua sendo requisito desse perfil de laboratório por falha da descoberta de classes do CT fixado, não dependência obrigatória do Petroleum.

## Limites e continuidade

Revisão adversarial e inspeção realizadas pelo mesmo assistente; não houve auditor independente externo nesta rodada. A campanha prova os cenários de receita, undo e persistência descritos, não todo callback externo possível.

Regressões completas de DT/Hydro sem as dependências opcionais, cliente NEI, contratos customizados do Coker e demais frentes permanecem necessários. Não há aprovação adicional de Crucible/Java 21, pack completo, multiplayer autenticado, shaders, áudio final ou desempenho. Nenhum JAR ou mundo de produção foi alterado; nenhum push ou release foi realizado.
