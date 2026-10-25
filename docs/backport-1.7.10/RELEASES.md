# Releases (JARs já construídos)

> Todos os JARs abaixo foram publicados em **25/10/2026** como **pre-releases** do fork `Akashiic/ImmersivePetroleum`, anexados *byte a byte* como estavam em `dist/` do projeto local (alpha.2–10) e o JAR do autor (build em uso). Os tamanhos e SHA-256 mostrados pelo GitHub foram conferidos contra [`data/release-jars.tsv`](data/release-jars.tsv). `alpha.0` e `alpha.1` **não têm JAR** e por isso não têm release.

## Avisos importantes

- São **pre-releases de laboratório**: nada foi homologado em pack/mundo de produção (ver [`ESTADO-ATUAL-E-RETOMADA.md`](ESTADO-ATUAL-E-RETOMADA.md)).
- **Licença:** o upstream é *All Rights Reserved* e foi tratado só como evidência; o código/assets do backport são originais (clean-room). O gate G11 (release) segue **bloqueado** pelo projeto; a publicação destes JARs foi decisão explícita do autor — ver [`PROVENIENCIA.md`](PROVENIENCIA.md) §1.3. Isto não é aconselhamento jurídico.
- As tags de release (`1.7.10-0.1.0-alpha.N`) apontam para o commit do **dossiê** no branch `1.7.10-backport`, **não** para o commit-fonte do JAR: o código-fonte do backport não está no GitHub. Os commits-fonte (locais) constam em [`CRONOLOGIA.md`](CRONOLOGIA.md).
- O JAR *dirty* **não é reproduzível**: foi compilado de um worktree com alterações não commitadas ([`BUILD-EM-USO.md`](BUILD-EM-USO.md)).

## Tabela

| Versão | Release | Tamanho (bytes) | SHA-256 |
|---|---|---:|---|
| 0.1.0-alpha.2 | [`1.7.10-0.1.0-alpha.2`](https://github.com/Akashiic/ImmersivePetroleum/releases/tag/1.7.10-0.1.0-alpha.2) | 65.679 | `fb24d1fc667af0d29bf41456bfbab46fe6c6bd5d78774726608610ce0f8c9787` |
| 0.1.0-alpha.3 | [`1.7.10-0.1.0-alpha.3`](https://github.com/Akashiic/ImmersivePetroleum/releases/tag/1.7.10-0.1.0-alpha.3) | 81.674 | `82de7e151c1a1ef2831da5a900fa06842f347ef0fad1672756e09156f6bc7027` |
| 0.1.0-alpha.4 | [`1.7.10-0.1.0-alpha.4`](https://github.com/Akashiic/ImmersivePetroleum/releases/tag/1.7.10-0.1.0-alpha.4) | 110.520 | `7522d6ef9f91041215247f6c2a3307868e4241ab6d10bcb7fd81add9cbc0dbc9` |
| 0.1.0-alpha.5 | [`1.7.10-0.1.0-alpha.5`](https://github.com/Akashiic/ImmersivePetroleum/releases/tag/1.7.10-0.1.0-alpha.5) | 133.570 | `2edc22cc43bcdb5a062e55bc67bb746ca4850cf14298304b667d148c8b028cce` |
| 0.1.0-alpha.6 | [`1.7.10-0.1.0-alpha.6`](https://github.com/Akashiic/ImmersivePetroleum/releases/tag/1.7.10-0.1.0-alpha.6) | 179.837 | `5773ebe2db5947cc589dc00d73ba296a0e546336c3738e8eb3011f420424b1fd` |
| 0.1.0-alpha.7 | [`1.7.10-0.1.0-alpha.7`](https://github.com/Akashiic/ImmersivePetroleum/releases/tag/1.7.10-0.1.0-alpha.7) | 197.396 | `41dcf282ae79d4db32cb57395a10670653ee41edc1282c8359ca9d10ec0523f7` |
| 0.1.0-alpha.8 | [`1.7.10-0.1.0-alpha.8`](https://github.com/Akashiic/ImmersivePetroleum/releases/tag/1.7.10-0.1.0-alpha.8) | 284.913 | `054859cefb627730e2754a7ba70bb6a64b1bc4f0dfb395032070cb6a46e7815c` |
| 0.1.0-alpha.9 | [`1.7.10-0.1.0-alpha.9`](https://github.com/Akashiic/ImmersivePetroleum/releases/tag/1.7.10-0.1.0-alpha.9) | 296.923 | `23e2b61f7f2b4f75a77bc732b50592354d6603edfde25b3d9bf211e98e315871` |
| 0.1.0-alpha.10 | [`1.7.10-0.1.0-alpha.10`](https://github.com/Akashiic/ImmersivePetroleum/releases/tag/1.7.10-0.1.0-alpha.10) | 452.282 | `271359f01e011aba5ee03121da085c51e0c9587143cd94d36e8c0c630ae9b20a` |
| 0.1.0-alpha.10 Catalyst WIP (`-dirty`, **build em uso**) | [`1.7.10-0.1.0-alpha.10-catalyst-wip-1ec598d`](https://github.com/Akashiic/ImmersivePetroleum/releases/tag/1.7.10-0.1.0-alpha.10-catalyst-wip-1ec598d) | 1.583.283 | `d5065d03a3e4ea65b518e523a5809161c486ccd4ad5c456ffc91a9770ce1c72c` |

## Como conferir um download

```powershell
Get-FileHash -Algorithm SHA256 .\immersivepetroleum-0.1.0-alpha.10.jar
# compare com a coluna SHA-256 acima, ou com o arquivo .sha256 anexado ao release
```

Cada release tem dois assets: o `.jar` e o `.jar.sha256` (formato `sha256sum`). Requisitos de runtime: Minecraft 1.7.10, Forge 10.13.4.1614, Immersive Engineering 0.7.9 customizado do pack (SHA-256 `51cf081e…c2e`), Java 8 bytecode.
