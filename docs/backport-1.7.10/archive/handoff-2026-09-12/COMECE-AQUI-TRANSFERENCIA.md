# Transferência do projeto — 12/09/2026

Checkpoint preservado: `db6b77d63c91696ed492b8d069d529cda450a9ee`, branch `feature/derrick-v1`.

**Comece pelo [relatório principal](work/ImmersivePetroleum-1.7.10/docs/HANDOFF-2026-09-12.md)** e pela [validação do checkpoint](work/ImmersivePetroleum-1.7.10/docs/HANDOFF-VALIDATION.md).

- [Mensagem pronta para o próximo engenheiro](work/ImmersivePetroleum-1.7.10/docs/HANDOFF-RESUME-PROMPT.md).
- [Pacote completo ZIP, aproximadamente 95 MiB](engineering-handoff/20260912T200922Z.zip).
- [Manifesto do pacote](engineering-handoff/20260912T200922Z/handoff-manifest.json).
- [Verificação do ZIP](engineering-handoff/20260912T200922Z.zip.verification.json).
- [Instruções de restauração](engineering-handoff/20260912T200922Z/LEIA-PRIMEIRO.txt).

O check completo sem exclusões passou com **401 testes/64 suítes, zero falhas/erros/skips e zero apontamentos de Checkstyle**. O bundle foi restaurado em uma pasta separada, com HEAD correspondente, árvore limpa e `git fsck` aprovado. Foram conferidos tamanho e SHA-256 de 1731 arquivos no pacote e das 1732 entradas do ZIP.

SHA-256 do ZIP: `c8d90c79e851c062a037f1541a6352645429025f40ca51feac9f990a4399a364`.

As falhas de runtime do Coker e do cenário de lubrificação estão documentadas com mundos/logs preservados. Motorboat, integrações de receitas, cliente e qualificação completa ainda têm pendências. **Este é um checkpoint de continuidade, não uma release do backport completo.** O backup é local; não houve upload ou push.

Não é necessário recuperar a conversa para compreender o estado de engenharia: os relatórios conservam decisões, referências, arquivos, gates, riscos, reproduções e ordem de retomada.
