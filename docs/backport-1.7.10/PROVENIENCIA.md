# Proveniência — de onde vêm os fatos deste dossiê

> Este arquivo responde a duas perguntas: **(1)** de onde vieram o conhecimento e o código do backport (cadeia de fontes, licenças, o que foi copiado ou não); **(2)** de onde vem cada afirmação deste dossiê e como conferi-la.

## 1. Cadeia de fontes do projeto

### 1.1 Referências upstream congeladas

| Papel | Repositório / branch | Commit congelado | Observação |
|---|---|---|---|
| Semântica moderna (**autoridade de funcionalidades**) | `TwistedGate/ImmersivePetroleum` · `1.21.1` | `e6cb01df32d4adfd096d49c02bb91e60fef56a15` (2026-07-29) | **Este commit é exatamente a ponta do branch `1.21.1` do fork** `Akashiic/ImmersivePetroleum` — verificado por `git merge-base --is-ancestor` e contagem 0 de commits à frente |
| Ponte de migração | `TwistedGate/ImmersivePetroleum` · `1.12.2` | `670050389c777e47e8beda18bf41cb6e819b66d4` | Pumpjack em `ModelBase/ModelRenderer` + TESR; torre com OBJ/MTL — reduz a distância semântica até o Forge 1.7.10 |
| Arqueologia histórica | `Flaxbeard/ImmersivePetroleum` · `master` | `dce4c3b8d2b59d30357a006cf1a5fd1640e61a30` | Para identificar comportamento anterior a reescritas e não tratar escolha recente como "eterna" |
| Referência de API do IE moderno | Immersive Engineering 1.21.1 | `75a27f03e4243544243567e8d5c38d336f4f10f4` | Agendador/API; constante no manifesto do handoff |
| Template da Distillation Tower | NBT do 1.21.1 | SHA-256 `f1a33208203e6daeead34e16e306b34856fbd6c11613cb8f3ed4245d0e500442` | A tabela Java de 137 blocos é **gerada** desse NBT e validada (tamanho, paleta, entradas, posições duplicadas) |
| Dependência de runtime | `ImmersiveEngineering-garden-cloche-test-2.jar` | SHA-256 `51cf081e5a7c9e92dc9ede65021ba2befbdd17971a070d7f26f8c83839c4ac2e` | IE do pack Forbidden Series; **nunca modificado** |

Os quatro arquivos `upstream/*.zip` do handoff são *"referência local, não licença de redistribuição"* (campo `purpose` do manifesto).

### 1.2 Regra "sem cópia cega" (`PROVENANCE.md`)

Cada ideia importada é classificada como: **port semântico**, **adaptação de algoritmo**, **reescrita de compatibilidade de API**, **referência de asset** ou **implementação original**. Classes NeoForge modernas não são copiadas para o 1.7.10 só porque os nomes coincidem.

### 1.3 Licença

- Sem arquivo de licença na raiz dos repositórios clonados; distribuição no CurseForge marcada **All Rights Reserved**.
- Postura do projeto: upstream = **evidência**; código e assets do backport = **clean-room**; modelos/texturas/sons do upstream **não** entram em pacote público; G11 bloqueado até resolução.
- Postura **deste dossiê**: só inclui texto/dados produzidos pelo próprio projeto (documentos de engenharia, hashes, tabelas derivadas do git) e diagramas novos. **Nenhum** código-fonte do backport, JAR, asset, log de run ou arquivo do upstream foi acrescentado — o fork continua com o conteúdo do upstream **inalterado** na árvore raiz.
- **Isto não é aconselhamento jurídico.** A decisão de licenciar/publicar o backport é do autor.

## 2. Como este dossiê foi produzido (método)

| Etapa | O que foi feito |
|---|---|
| Inventário | Listagem das pastas da raiz do projeto local, 4 worktrees, 37 branches, 11 tags, `git worktree list` |
| Histórico | Clone espelho local do repositório de trabalho; `commits.tsv` gerado por script (data, pais, tags, arquivos/linhas alteradas, contagem de arquivos/linhas de main/test/docs/tools **por commit**, extraídas com `git archive`/`git ls-tree`) |
| Documentos | Leitura dos docs de engenharia no commit `2c7b3f9` (85 arquivos), 3 handoffs, evidências G3A–G6, relatórios de qualificação 13–15/09, ADRs, release/build audit da alpha.10 |
| Estado do disco | Comparação por **hash** dos arquivos não commitados dos 4 worktrees contra a ponta (Windows git/PowerShell) |
| JAR em uso | JAR anexado pelo autor em 25/10/2026: SHA-256, entradas, versão de bytecode, carimbos; conjunto de classes comparado com `src/main/java` de cinco commits ([`BUILD-EM-USO.md`](BUILD-EM-USO.md)) |
| Hashes de release | Lidos dos `SHA256SUMS` de cada `dist/` e conferidos com tamanho do JAR em disco |
| Progresso | `TOTAL-PROGRESS.md` interpretado seção a seção → `progress-estimates.tsv` |
| Diagramas | Mermaid validado com `mmdc` (Mermaid CLI 11.16) em Chromium headless; SVGs e fontes `.mmd` em `diagrams/` |
| Arquivo | Cópia **verbatim** (byte a byte) dos documentos originais; varredura de segredos (nenhum token/senha/chave; as ocorrências de "token" são tokens de sessão de protocolo de GUI descritos nos ADRs) |

### 2.1 Mapa afirmação → fonte

| Tipo de afirmação neste dossiê | Fonte primária |
|---|---|
| Datas, tags, autoria de commits, tamanhos de diff, crescimento de código | `data/commits.tsv`, `data/tags.tsv` (derivados de `git log`/`ls-tree`) |
| Hashes e tamanhos de JAR | `data/release-jars.tsv` ← `archive/release-sha256sums/*/SHA256SUMS.txt` |
| Contagens de testes/suítes | Documentos de cada checkpoint (`TOTAL-PROGRESS.md`, `BUILD-AUDIT.md`, `AUDIT-STATUS.md`) |
| % de progresso | `TOTAL-PROGRESS.md` → `data/progress-estimates.tsv` |
| Estado dos gates | `AUDIT-STATUS.md`, `ROADMAP.md` + docs de qualificação 13–15/09 |
| Incidentes e causas | Docs de qualificação e diagnóstico citados em [`HIPOTESES-E-INCIDENTES.md`](HIPOTESES-E-INCIDENTES.md) |
| Estado do disco (worktrees, WIP, `origin` inexistente) | Inspeção direta do disco em 25/10/2026 (git local) — **não** está no archive, só descrito em [`ESTADO-ATUAL-E-RETOMADA.md`](ESTADO-ATUAL-E-RETOMADA.md) |
| Rótulos curtos de commit e títulos de fase | Escritos por mim a partir dos assuntos dos commits e dos docs |

## 3. Limites e ressalvas da investigação

1. **Não executei o projeto.** Não rodei Gradle, testes, servidor nem cliente; o dossiê relata o que o git e os documentos do próprio projeto registram. Contagens de testes e veredictos PASS são **alegações do projeto**, apoiadas pela evidência salva (que fica no disco do autor em `run/`), não reverificadas por mim.
2. **Sem auditoria independente.** O próprio projeto afirma que implementação, revisão e aprovação foram feitas pelo mesmo assistente; este dossiê herda essa limitação.
3. **Leitura parcial de alguns documentos.** Li integralmente os documentos de estado, handoffs, qualificação e gates principais; os corpos de alguns ADRs e evidências G4B1/G4B2/G5/G6 foram lidos só nos trechos relevantes. Todos estão arquivados verbatim para consulta.
4. **Mojibake.** Alguns documentos originais contêm caracteres corrompidos (ex.: `suÃ­tes`, `â€“`) — são do original e foram preservados no archive; não alterei bytes.
5. **Os artefatos pesados não estão no archive:** `run/`, `evidence/**` (logs/screenshots/mundos), `dist/*.jar`, `*.zip`, `repository.bundle`, `source-code.zip`, `upstream/*.zip`. Os **hashes** deles estão nos índices.
6. **Datas.** `~2026-10-02` (inicialização do `.git` da raiz) vem do timestamp de pasta; o restante vem de metadados de commit.
7. **Rótulos [inferência].** Quando uma frase minha vai além dos documentos, está marcada como **[inferência]**.

## 4. Verificação de integridade do archive

[`archive/INDEX.md`](archive/INDEX.md) lista cada arquivo copiado com tamanho e SHA-256 **e o caminho de origem**; basta comparar com o original:

```powershell
Get-FileHash -Algorithm SHA256 C:\Users\User\Desktop\Codex\immersivepetroleum-backport\project-docs\README-CURRENT.md
```
