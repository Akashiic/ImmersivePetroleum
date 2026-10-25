# Build em uso pelo autor — `0.1.0-alpha.10-feature-catalyst-refinery-20260915T1300.24+1ec598dd1c-dirty`

> O autor informou que **este é o JAR que ele está usando** e que o considera "o mais recente que já foi trabalhado". Este documento identifica o JAR por hash, determina **de qual ponto do git ele realmente vem** e diz como retomar a partir dele. A análise foi feita sobre o JAR anexado (hash, entradas, classes, versões de bytecode, datas) e cruzada com os conjuntos de classes de cada commit do histórico.

## 1. Identidade do artefato

| Campo | Valor |
|---|---|
| Nome (como informado) | `immersivepetroleum-0.1.0-alpha.10-feature-catalyst-refinery-20260915T1300.24+1ec598dd1c-dirty.jar` |
| SHA-256 | `d5065d03a3e4ea65b518e523a5809161c486ccd4ad5c456ffc91a9770ce1c72c` |
| Tamanho | 1.583.283 B (≈ 1,51 MiB) — a alpha.10 oficial tem 452.282 B |
| Conteúdo | 716 entradas (654 `.class`; arquivos não-classe: `META-INF/MANIFEST.MF`, `mcmod.info`, `lang/en_US.lang`, `lang/pt_BR.lang`); 318 classes de topo; 3.284.613 B descomprimidos |
| Bytecode | class file major **52** (Java 8) em todas as classes |
| Coremod | `FMLCorePlugin: flaxbeard.immersivepetroleum.common.compat.drilloil.asm.PetroleumDrillCorePlugin` (+ `FMLCorePluginContainsFMLMod: true`) |
| `mcmod.info` | `modid immersivepetroleum`, nome "Immersive Petroleum - Forbidden Backport", **versão `0.1.0-alpha.10`** (texto fixo — não acompanha o sufixo do nome do arquivo), dependência `ImmersiveEngineering` |
| Data de build (carimbo das entradas) | **2026-09-15 18:25** (horário local do build, UTC−03:00 presumido) |

## 2. Como ler o nome da versão

`0.1.0-alpha.10` — última tag  ·  `feature-catalyst-refinery-20260915T1300` — branch/worktree de origem  ·  `.24` — **24 commits depois da tag alpha.10** (confirmado: `git rev-list --count 0.1.0-alpha.10..1ec598d = 24`)  ·  `+1ec598dd1c` — commit-base `1ec598dd1ce6f4236aefd96d7d8c41b07c8aecd8` ("Qualify legacy material chain and transactional placement", 15/09 12:29)  ·  `-dirty` — **havia alterações não commitadas** na árvore quando o JAR foi construído.

## 3. De onde esse JAR realmente vem

Comparei o conjunto de classes de topo do JAR com `src/main/java` de cada commit:

| Commit comparado | Classes no código-fonte | No JAR e não no commit | No commit e não no JAR |
|---|--:|--:|--:|
| `dc6587d` (alpha.10) | 95 | 223 | 0 |
| `db6b77d` (handoff 12/09) | 272 | 46 | 0 |
| `1ec598d` (base declarada) | 314 | **4** | 0 |
| **`9879cdc`** (Catalyst Refinery, 15/09 18:42) | 318 | **0** | **0** |
| `2c7b3f9` (ponta, Asphalt, 15/09 20:16) | 321 | 0 | **3** |

**Conclusão:** o JAR = **`1ec598d` + o trabalho de Catalyst Refinery ainda não commitado**. As 4 classes extras em relação à base são:

- `common/compat/drilloil/asm/PetroleumRefineryTransformer` (transformer ASM da Refinery do IE 17)
- `common/compat/refinery/PetroleumCatalystRefinery`
- `common/compat/refinery/CatalystRefineryProbe`
- `client/diagnostics/CatalystRefineryClientProbe`

Com elas, o conjunto de classes fica **idêntico ao do commit `9879cdc`**, que só foi gravado **17 minutos depois** do carimbo de build (18:25 → 18:42). Ou seja, o JAR é uma **versão intermediária (rascunho) do Catalyst Refinery** — a mesma lista de classes que virou o commit `9879cdc`, mas **o conteúdo interno delas pode diferir** (os arquivos desse worktree que continuaram sem commit diferem, por hash, dos da ponta; ver [`ESTADO-ATUAL-E-RETOMADA.md` §3.3](ESTADO-ATUAL-E-RETOMADA.md#33-worktrees-e-trabalho-não-commitado)).

O JAR **não contém** as 3 classes que o commit seguinte (`2c7b3f9`, Asphalt, 20:16) adicionou: `ItemAsphaltBlock`, `AsphaltItemTooltip` e `AsphaltClientProbe`. Portanto **não tem a correção do tooltip moderno do Asphalt** (incidente I-17 em [`HIPOTESES-E-INCIDENTES.md`](HIPOTESES-E-INCIDENTES.md)) nem a qualificação final do Asphalt.

## 4. Posição na cronologia

```text
… 0b7ac71 Motorboat (09-15 00:26) → e898344 Pumpjack+Reservoir (01:40) → 1ec598d Material chain (12:29)
                                                                              │
                              [18:25  JAR do autor = 1ec598d + Catalyst não commitado  ◄── "build em uso"]
                                                                              │
                                  9879cdc Catalyst Refinery (18:42) → 2c7b3f9 Asphalt (20:16, ponta do git)
```

- Em **tempo de build**, o JAR é o artefato **mais recente que o autor realmente construiu e está usando** (nenhum JAR foi gerado em `dist/` depois da alpha.10 — o último JAR de `dist/` é de 12/09).
- Em **conteúdo**, o git tem uma ponta **posterior e mais completa** (`2c7b3f9`), que contém tudo o que o JAR tem **como código commitado** (a menos das diferenças internas do rascunho) **mais** o Asphalt qualificado.
- Nenhum commit é exatamente o JAR: ele **só pode ser reproduzido a partir do worktree sujo** `ImmersivePetroleum-catalyst-20260915T1700` (ver abaixo).

## 5. Como retomar a partir dele (receita)

1. **Preserve o worktree `…\work\ImmersivePetroleum-catalyst-20260915T1700` exatamente como está** (10 arquivos modificados + novos, @`1ec598d`). É a **única fonte** do JAR em uso. Antes de qualquer limpeza: `git diff > catalyst-wip.patch` e `git stash`/cópia da pasta.
2. **Arquive o JAR e seu hash** fora do git (ex.: Release privado) — `d5065d03…2c72c`.
3. **Para continuar trabalhando, parta de `2c7b3f9`** (ponta): ela inclui a versão **commitada e qualificada** do Catalyst Refinery (`9879cdc`; 611 testes / 100 suítes) e o Asphalt. Reconstrua o JAR **limpo** dessa ponta (`gradlew build` com JDK 1.8) — será o sucessor do "dirty" e terá sufixo `…+<hash>` sem `-dirty`.
4. **Compare comportamento** entre o JAR em uso e o build da ponta (principalmente Catalyst Refinery: contratos, GUI, transformer) antes de substituí-lo no pack; diferenças entre rascunho e commit estão nos 4 arquivos listados e nos testes `PetroleumCatalystRefineryTest` / `…TransformerTest`.
5. **Tagueie** (hoje só existem tags até alpha.10), por exemplo `0.1.0-alpha.11` em `2c7b3f9`, e registre o build de produção/teste dele num `SHA256SUMS`.

## 6. Verificação

```powershell
Get-FileHash -Algorithm SHA256 "<caminho>\immersivepetroleum-0.1.0-alpha.10-feature-catalyst-refinery-20260915T1300.24+1ec598dd1c-dirty.jar"
# esperado: D5065D03A3E4EA65B518E523A5809161C486CCD4AD5C456FFC91A9770CE1C72C
git -C work\ImmersivePetroleum-1.7.10 rev-list --count 0.1.0-alpha.10..1ec598d   # 24
```

A lista das 318 classes de topo do JAR está em [`data/jar-class-inventory-top-level.txt`](data/jar-class-inventory-top-level.txt). O JAR em si **não** é publicado neste repositório (distribuição do mod bloqueada pelo gate de licença/assets — ver [`PROVENIENCIA.md`](PROVENIENCIA.md)).

## 7. Limites desta análise

- Não executei o JAR (nem em servidor nem em cliente) — só inspeção estática de arquivo.
- "Idêntico ao conjunto de classes de `9879cdc`" prova **o mesmo conjunto de classes**, não o mesmo bytecode; sem recompilar o worktree sujo não dá para provar a diferença byte a byte.
- O fuso do carimbo de build é presumido (UTC−03:00), coerente com os horários de commit do mesmo dia.
- Os resultados de teste do estado "dirty" no momento do build **não estão registrados**; os números 598/98 (`1ec598d`) e 611/100 (`9879cdc`) são dos commits, não do JAR.
