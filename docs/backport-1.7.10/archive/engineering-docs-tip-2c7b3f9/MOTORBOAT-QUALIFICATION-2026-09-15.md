# Motorboat — qualificação semântica e cliente final de laboratório

Base versionada anterior: `59e2d9c1491d501632ad021a4901805fb3b75f0e`.
Branch: `feature/motorboat-qualification-20260914T2300`.
Digest final qualificado: `ccbeb1b04985f381afba7a491ce03ba35d2cc4c1d454f67605de256f2c621afa`.
Evidência consolidada: `run/motorboat-resumption-20260914T2310/final-qualification.json`.

## Matriz final

- `cleanTest check`: **594 testes / 97 suítes**, zero failures/errors/skipped; Checkstyle main/test sem erros.
- Servidor dedicado: três boots no mesmo digest, com `source_unchanged=true`.
- Cliente: Angelica ativo, 104 renders (26 combinações × 4 orientações), item renderers e screenshot único hasheado.
- Região persistida SHA-256: `4513d2f574d3fc54edd835f319a8dea21e29625e078bf0af43255484a57338b5`.
- Screenshot SHA-256: `fe7a80b43ac61a64453970fb29f3c2abff0267e5c3c455509753599aad834957`.
- `server.properties`, `eula.txt`, `options.txt` e `splash.properties` retornaram byte a byte aos hashes anteriores.

A imagem final aprova a fundação visível dos seis estados mostrados sem clipping evidente; não certifica arte premium final ou shaderpacks arbitrários.
## Cinco deltas semânticos encerrados

A reprodução negativa `motorboat-semantic-red-20260914T2310` executou cinco testes e falhou cinco vezes, sem erro colateral. Cada failure correspondia a uma diferença já documentada no handoff e foi mantida como evidência.

1. **Icebreaker em modo emergency:** quebrar gelo continua bloqueado sem motor, como no moderno; o dano de colisão contra entidade, porém, não depende desse gate. O servidor nativo confirmou exatamente um hit de 4 no cenário de remos.
2. **Fonte direta de dano:** decisões player/creative usam `DamageSource.getSourceOfDamage()` (equivalente à entidade direta do moderno/bridge) e não confundem o shooter/responsável indireto.
3. **Passageiro na lava:** casco reforçado sincroniza estado de lava e usa offset `-0.1 + 3.9/16`, preservando o bridge 1.12.2.
4. **Queda AIR→LAND:** `fall(float)` confia no callback vanilla pós-aterrissagem em vez de reler o `surface` amostrado antes de `moveEntity`.
5. **Hélice longa:** o acumulador volta ao intervalo angular e a renderização usa interpolação angular curta equivalente ao `rotLerp` moderno.

O marcador permanente do servidor é:
`MOTORBOAT_SEMANTICS_PASS emergencyIcebreaker=true directDamage=true lavaOffset=true fallCallback=true propellerModulo=true`.

As falhas diagnósticas intermediárias de colisão/lava foram fixtures: primeiro o alvo ficava abaixo do barco após a transição para flutuação; depois a lava era criada dentro da piscina de água e solidificava antes da amostragem. Nenhuma dessas execuções foi promovida a PASS.
## Cliente e áudio

O cliente final usa o lifecycle real de `MotorboatClient.observe()` e não apenas uma instância isolada do som. A campanha comprovou recurso IE disponível, mute, saída de alcance, criação do loop, recarregamento de recursos, recriação posterior e parada após remoção da entidade. Marcador:
`MOTORBOAT_SOUND_LIFECYCLE_PASS resource=true mute=true range=true reload=true restart=true stop=true`.

O renderer verificou cinco estados GL, item renderer da lancha/upgrades, 104 renders e a interpolação angular curta após wrap da hélice. Marcador:
`MOTORBOAT_RENDERER_PROBE_PASS combinations=26 orientations=4 draws=104 angelica=true stateRestored=true propellerWrap=true item=true`.

## Limites que continuam externos

Esta aprovação não substitui Crucible/Java 21, pack completo, mundo copiado, sessão multiplayer autenticada, teste humano de áudio, shaderpacks arbitrários, soak/benchmark ou acabamento artístico final. O ator dos boots continua sendo `EntityPlayer` sintético sem conexão de rede; portanto controle real via pacote remoto e dismount multiplayer continuam gates separados.

O renderer/cliente e os boots aprovam comportamento e fundação visual, não garantem equivalência irrestrita com todos os mods de colisão, fluidos ou eventos externos. Estado em quarentena continua preservado e bloqueado em vez de ser reidratado automaticamente.
