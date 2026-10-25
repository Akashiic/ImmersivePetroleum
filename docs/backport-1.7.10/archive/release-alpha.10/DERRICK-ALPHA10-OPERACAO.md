# Derrick alpha.10 — operação e limites

Este checkpoint permite formar o Derrick, abastecer tubos e fluido, perfurar e entregar petróleo sob pressão. As campanhas usam mundos de desenvolvimento isolados. A progressão survival completa ainda depende da produção de concreto, exploração sísmica, manual e edição da grade direcional.

## Montagem

São 59 blocos em um volume de 5 × 8 × 5. O quadro abaixo vem das coordenadas de `DerrickStructure`, conferidas com o template moderno congelado.

| Símbolo | Material | Quantidade |
|---|---|---:|
| S | Andaime de aço IE | 19 |
| F | Cerca de aço IE | 16 |
| P | Tubo de fluido IE | 9 |
| L | Bloco de engenharia leve IE | 8 |
| H | Bloco de engenharia pesada IE | 2 |
| R | Bloco de engenharia de redstone IE | 1 |
| G | Laje de grade de aço Petroleum, metade superior | 4 |
| . | Posição sem material exigido pelo template | — |

Orientação de referência NORTH, sem espelhar: cada quadro é visto de cima; esquerda → direita aumenta X, cima → baixo aumenta Z. Y=0 é a base. O centro da base é o mestre `(2,0,2)`.

```text
Y=0     Y=1     Y=2     Y=3
SLLLS   .LLL.   .....   .....
SSSSS   RF.F.   .FGF.   .FFF.
SSHPP   SLH..   SGPG.   .FPF.
SSPSS   .F.F.   .FGF.   .FFF.
SSLSS   .....   .....   .....

Y=4     Y=5     Y=6     Y=7
.....   .....   .....   .....
.....   .....   .....   .....
..P..   ..P..   ..P..   ..P..
.....   .....   .....   .....
.....   .....   .....   .....
```

Use o martelo IE no bloco L central da última linha da base, coordenada local `(2,0,4)`. A formação reconhece quatro orientações e as variantes espelhadas. Clique com o botão direito em uma parte formada, sem agachar, para abrir o painel; o servidor exige proximidade do mestre.

Remova as coberturas de andaime dos tubos antes da montagem. A formação recusa tubos cobertos para evitar que o callback IE solte a cobertura durante a conversão e a restaure novamente na desmontagem. Cor e configuração de faces dos tubos continuam preservadas.

## Conexões e sequência

| Função | Coordenada local | Face na orientação NORTH sem espelhar |
|---|---|---|
| Entrada de energia | `(2,1,0)` | Superior |
| Entrada de concreto/água | `(2,0,4)` | Sul |
| Saída de petróleo sob pressão | `(4,0,2)` | Leste |
| Controle de redstone | `(0,1,1)` | Sinal no bloco |

1. Insira tubos de fluido IE pelo painel. Cada item fornece seis unidades de perfuração; os nove tubos usados na montagem são materiais da estrutura, separados desse estoque.
2. Forneça energia RF pela entrada superior. O buffer guarda 16.000 RF e a perfuração ativa consome 512 RF por tick.
3. Forneça concreto durante a descida física e água durante a extensão virtual. O tanque guarda até 8.000 mB e cada avanço confirmado usa 125 mB do fluido correspondente. O número de passos físicos depende do terreno.
4. A grade padrão usa a coluna central e termina em 384 unidades. A edição direcional ainda não está disponível no painel.
5. Ao terminar, o Derrick libera a pressão dos reservatórios finitos alcançados, sem consumir RF nessa fase. Conecte a saída antes da conclusão: o excedente que o destino não aceita é derramado, seguindo a política moderna. Isso também ocorre com saída desconectada.
6. Quando a pressão termina, a Pumpjack pode continuar extraindo pelo mesmo Well. A campanha verificou essa transição com a pressão preparada pela API; não simulou todo o tempo natural de esgotamento.

Redstone pausa a perfuração. A pressão de um poço concluído segue sua própria fase. O limite físico de referência usa Y=63 do Overworld; níveis de mar de geradores personalizados ainda não foram homologados.

## Diagnóstico e configuração

Estados como falta de tubos, energia, concreto, água e estrutura parcialmente descarregada aparecem no painel. Dados incompatíveis ou uma resposta impossível de outro componente colocam a máquina em quarentena. Nesse estado, preserve o mundo e o registro de recuperação para diagnóstico; o registro não é uma receita de restauração automática de itens.

Em `config/immersivepetroleum.cfg`, os controles `machines.enableDerrick`, `machines.enablePumpjack` e `machines.enableDistillation` pausam a operação sem remover registros de blocos ou dados salvos. A configuração é carregada na inicialização.

Consulte `G6-EVIDENCE.md` para o escopo aprovado. Migração de mundo do modpack, multiplayer dedicado com jogadores, integração NEI/CraftTweaker, arte e áudio finais e medições de desempenho continuam pendentes.
