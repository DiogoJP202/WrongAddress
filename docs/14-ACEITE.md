# Critérios de aceite e matriz de testes

## P0 — Funcionalidade

| Teste | Passos essenciais | Esperado |
|---|---|---|
| T01 Spawn | Abrir Studio em Play solo | Jogador, van, caixa e destino aparecem |
| T02 Entendimento | Jogador sem instruções extras começa | Objetivo visível e primeira ação óbvia |
| T03 Pegar caixa | Aproximar e interagir | Um jogador segura a carga, sem duplicação |
| T04 Colocar na van | Levar caixa ao compartimento | Caixa fica associada ao veículo e estado atualiza |
| T05 Direção | Entrar/dirigir/frear | Van responde e não fica inutilizável facilmente |
| T06 Fuga | Acionar incidente controlado | Caixa escapa com sinal claro, sem sumir |
| T07 Captura | Perseguir e interagir | Caixa é recuperada e pode voltar à van |
| T08 Entrega | Chegar à zona válida com carga | Servidor conclui **uma vez** |
| T09 Reset | Reiniciar contrato | Estado limpo, sem scripts/eventos duplicados |
| T10 Spam | Apertar interagir/entregar repetidamente | Sem rewards/delivery duplicados, sem exception |
| T11 Queda de carga | Derrubar em borda/fora da rota | Fallback recupera sem softlock |
| T12 Veículo preso | Bater/esbarrar ou capotar | Jogador consegue resetar/recolocar com cooldown |
| T13 Solo | Uma sessão inteira sem outros players | Conclui sem funções simultâneas |
| T14 Dois clientes | Testar uma carga compartilhada | Não há clones, donos inconsistentes ou travamento |
| T15 Desconexão | Player sai carregando caixa | Estado é liberado/reparado |
| T16 Touch | Emular mobile | Interação, direção e reset possíveis sem teclado |
| T17 Respawn | Reiniciar personagem | UI e missão não travam |
| T18 Segurança | Simular chamadas inválidas quando possível | Servidor rejeita intents fora da fase/distância |

## P0 — Qualidade mínima

- Sem erros recorrentes de script no fluxo normal; logs de debug não inundam output.
- UI legível em celular pequeno e PC; elementos clicáveis não ficam fora da tela.
- Objetos e conexões antigos não persistem de forma duplicada após 5 resets consecutivos.
- Se 2 clientes completarem a primeira entrega, nenhum deles deve ver estado final incompatível.
- Documentar desempenho (FPS/memória quando disponíveis) em vez de alegar otimização sem medição.

## Gate de review

Para cada teste, registrar **PASSOU**, **FALHOU** ou **NÃO EXECUTADO**, com data, plataforma, passos e evidência. Proposta de MVP só é considerada concluída quando os obrigatórios passarem ou os desvios forem aprovados explicitamente.

## P1/P2/P3 — Adições

- P1: diferentes destinos e pacotes sem combinações insolúveis; pagamentos uma vez por contrato; sala com 4 jogadores.
- P2: persistência após sair/entrar, falha transitória de DataStore, migração de schema, proteção a salvamentos concorrentes.
- P3: compra cosmética aprovada, sem efeitos involuntários no gameplay e seguindo políticas Roblox.
