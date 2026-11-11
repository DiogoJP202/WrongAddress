# Game Design Document — mecânicas e fluxo

> Versão inicial; valores e tempos são parâmetros de teste, não balanceamento definitivo.

## Loop completo (alvo P1/P2)

1. **Aceitar contrato:** escolher destino, carga, pagamento previsto e aviso simples de risco.
2. **Carregar:** pegar encomenda no depósito, colocá-la no veículo, partir.
3. **Transporte:** dirigir e reagir a 0–2 incidentes compatíveis por contrato.
4. **Entrega:** chegar à área do destino com carga recuperada ou pagar uma penalidade simples pela falha.
5. **Resultado:** receber moeda (P1), progredir contrato/catálogo/garagem (P2), retornar ao depósito e repetir.

No P0 só existe o essencial: sequência de carregar → dirigir → caixa foge → recuperar → entregar → resultado → reset. Sem seleção de múltiplos contratos e sem moeda persistente.

## Sessão curta

- Primeiro contato: o jogador entra perto da van e da caixa; destino é mostrado sem precisar abrir menu.
- Primeiro contrato P0: 2–4 minutos como alvo de design; testar tempos reais.
- Um incidente principal deve acontecer de forma controlada e compreensível.
- Fail state suave: reposicionar carga ou reiniciar entrega. Nada de tempo perdido/expulsão.

## Máquina de estados P0 (por sessão de entrega)

```text
IDLE -> ASSIGNED -> LOADING -> IN_TRANSIT -> CARGO_LOST -> RECOVERING
                                     |                        |
                                     +<-----------------------+
                                     |
                                     v
                                DELIVERABLE -> COMPLETED -> RESET_READY
                                     |
                                     +-> FAILED (somente falha recuperável definida)
```

- `IDLE`: aguarda interação com contrato inicial.
- `ASSIGNED`: contrato configurado pelo servidor.
- `LOADING`: carga aguardando ser colocada em área válida.
- `IN_TRANSIT`: veículo saiu ou contrato iniciou.
- `CARGO_LOST`: carga saiu de posição segura ou iniciou fuga, mas não está destruída.
- `RECOVERING`: jogador consegue capturar e reposicionar a carga.
- `DELIVERABLE`: destino atingido e condições mínimas satisfeitas.
- `COMPLETED`: entrega confirmada pelo servidor uma única vez.
- `RESET_READY`: reinicia sem reconstruir o mundo inteiro.

Transições e nomes são proposta de design; o Claude deve verificar necessidade real antes de criar máquinas de estado genéricas.

## Ações do jogador

- Movimentar personagem; olhar ao redor.
- Interagir com caixa (coletar/soltar), compartimento do veículo, ponto de destino e reset.
- Entrar/sair da van; acelerar, frear, virar.
- Recuperar carga fugitiva através de interação de alcance curto, com indicação visual.
- Opcional P1: usar 1 ferramenta de contenção; no P0, evitar inventário.

## Regras de contrato

- Apenas um contrato ativo por grupo/servidor no P0/P1, para reduzir estados compartilhados.
- Uma entrega só conta se o **servidor** confirmar destino + carga + estado do contrato.
- A área de destino é uma zona, não uma colisão exata de um pixel.
- A carga que foge deve poder ser recuperada sem exigir precisão excessiva.
- Ao sair um jogador, a missão não pode travar para os restantes.
- Limite de incidências concorrentes: P0 = 1; P1 = 1–2; P2 avaliar com telemetria.

## Solo e cooperação

Solo é modo base; com 2–4, companheiros podem pegar carga, dirigir, olhar o mapa ou recuperar fugas. **Não existem classes obrigatórias.**

Decisão pendente P1: servidor por contrato/grupo ou múltiplos grupos paralelos. **P0 escolhe 1 contrato global por servidor**, máximo 2 jogadores no teste inicial; escalar para 4 após estabilidade. Evitar criar instâncias isoladas de mapa sem provar necessidade.

## Design de falha

- Pacote fora da van: ele permanece recuperável num raio/área segura; fallback de resgate se cair no vazio.
- Veículo preso: opção de reposicionamento sem exploit de recompensa.
- Jogador desconectou: missão não depende dele para concluir.
- Repetir a missão: nenhuma recompensa duplicada por spam ou reconexão.

## Progressão por etapa

P0: resultado qualitativo, sem economia. P1: dinheiro de partida e 1 ou 2 opções de melhoria temporária. P2: garagem persistente, veículo, catálogo, reputação e novas rotas. P3: eventos e cosméticos extras após medir retenção.

## Anti-requisitos

Sem hunger/thirst, health/injury, árvore de habilidades complexa, PvP, combate, NPC inteligente, sistema de jobs de background, física realista de carreta, geração procedural infinita ou quests diárias em P0.
