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

## Resultados do P0 — 2026-11-16

Place local `place/WrongAddress.rbxl`. Testes automatizados no Roblox Studio, com teclado e toque simulados. Uma rodada solo percorreu o mapa inteiro pelos controles do jogo. Os testes direcionados usaram posições preparadas em Play para repetir cenários. [Modos de teste do Studio](https://create.roblox.com/docs/studio/testing-modes) · [Device Simulator](https://create.roblox.com/docs/studio/device-simulator)

| Teste | Resultado | Evidência |
|---|---|---|
| T01 Spawn | PASSOU | Personagem no depósito, uma van, uma caixa, HUD em “Pegue a caixa”. |
| T02 Entendimento | NÃO EXECUTADO | Depende da primeira sessão de jogadores externos no P0-10. |
| T03 Pegar caixa | PASSOU | Prompt no PC e no Galaxy A06 emulado. Com dois clientes, um único jogador ficou com a caixa. |
| T04 Colocar na van | PASSOU | Prompt “Colocar na van” acionado por teclado e toque. A caixa permaneceu presa durante a direção. |
| T05 Direção | PASSOU | Percurso solo com as duas curvas, a lombada e frenagem no destino. Thumbstick acionou a van no Galaxy A06 emulado. |
| T06 Fuga | PASSOU | Aviso de ~2,52 s nas duas rodadas. A caixa começou a ~28 studs da van freada e a ~124 studs quando ela manteve a velocidade. O gatilho ficou inativo na segunda passagem da mesma entrega. |
| T07 Captura | PASSOU | Prompt “Capturar” acionado enquanto a caixa fugia no solo, com dois clientes e no emulador touch. Ela voltou à caçamba. |
| T08 Entrega | PASSOU | Van sem carga manteve `CargoLost` no destino. Entrar na zona em movimento manteve `InTransit`. Van parada com a caixa presa concluiu uma vez por missão. |
| T09 Reset | PASSOU | Cinco cliques de reinício seguidos mantiveram `Runtime` com dois objetos e 44 descendentes. Reiniciar sentado devolveu o motorista ao depósito. |
| T10 Spam | PASSOU | 241 pedidos inválidos ou fora de fase preservaram o estado. Depois do quinto reinício, 80 pedidos repetidos mantiveram `MissionId=6`. |
| T11 Queda da carga | PASSOU | Caixa forçada para fora foi reposicionada na arena. A fuga natural durou ~40 s e ficou em `Loose`. Após destruir a caixa em Play, uma única substituta apareceu no `SafePoint` e preservou `EscapeCount=1`. |
| T12 Veículo preso | PASSOU | Van voltou ao `RecoverPoint`, com carga presa e motorista a pé ao lado. O pedido seguinte respeitou a espera de 8 s. |
| T13 Solo | PASSOU | Do depósito à entrega em 47,4 s, com teclado e prompts simulados, sem teletransportes ou atributos de teste da van. “Jogar de novo” iniciou a missão seguinte. |
| T14 Dois clientes | PASSOU | Ambos interagiram na mesma caixa. Replicaram o mesmo portador, aviso, fuga e status final. |
| T15 Desconexão | PASSOU | Cliente que carregava saiu pelo `StudioTestService`. O cliente restante pegou a caixa liberada. |
| T16 Touch | PASSOU NO EMULADOR | Pegar, carregar, sentar, dirigir, sair da van, capturar, recolocar e jogar de novo executados por toque no Galaxy A06, com posições preparadas para os trechos da rodada. A HUD ficou fora das áreas de joystick e pulo em 705 × 338, 666 × 374 e 959 × 599. |
| T17 Respawn | PASSOU | Morte enquanto carregava soltou a caixa. A mesma HUD permaneceu e voltou a “Pegue a caixa”. |
| T18 Validação | PASSOU | Tipos e ações inválidos, pedido de reinício fora de fase e tentativa de interação fora do alcance mantiveram o estado. |

**Desempenho no Studio em segundo plano.** A automação solo registrou ~15 FPS e ~2.967 MB de memória total reportada pelo cliente do Studio. No Galaxy A06 emulado, a amostra no depósito registrou ~15 FPS e ~2.888 MB. Desempenho em aparelho real e percepção de fluidez em coop ficam para o playtest.

## Resultados do P1 — 2026-11-16

Os seis contratos foram concluídos na mesma sessão de Play no Studio. O saldo acumulado foi de 385 moedas.

| Contrato | Destino | Pagamento verificado | Cenário |
|---|---|---:|---|
| Fugitiva | Casa isolada | 65 | Aviso, parada, fuga e captura antes da entrega. |
| Comum | Posto | 45 | Desvio pela faixa livre com a barreira ainda na pista. |
| Saltitante | Conveniência | 60 | Caixa escapou após a parada, foi recapturada e entregue na vaga estreita. |
| Fotossensível | Depósito secundário | 68 | Integridade caiu para 95% com faróis ligados. Faróis desligados pelo jogador e falha disparada após a curva. |
| Peso morto | Posto, vaga alternativa | 75 | Aceleração em 66% da normal com a carga e redirecionamento para a vaga correta. |
| Frágil | Conveniência | 72 | Colisão reduziu a integridade a 80%. Barreira retirada pelo prompt e entrega concluída. |

Com quatro clientes, o servidor aceitou uma única seleção concorrente, manteve uma caixa, rejeitou o salto direto até o destino e pagou 45 moedas a cada jogador. Após a saída do portador, outro jogador pegou a caixa. As métricas locais registraram seis contratos selecionados, seis entregas, cinco reinícios e duas fugas recuperadas. A repetição voluntária e o balanceamento com jogadores ficam em aberto.

## Resultados locais do P2 — 2026-11-16

- **Garagem.** Duas entregas geraram 90 moedas. A compra do motor consumiu esse saldo e liberou o nível 1. Pedidos repetidos sem saldo preservaram o nível e as moedas. A van seguinte recebeu multiplicador 1,1 no motor e concluiu a rota da caixa fugitiva.
- **Catálogo e reputação.** O catálogo marcou as duas cargas entregues. O contrato do pátio norte foi rejeitado com reputação 0, liberado após três entregas e pagou 85 na vaga alternativa.
- **Touch.** A garagem abriu por toque no Galaxy A06 emulado. A compra indisponível e o bloqueio inicial do pátio norte apareceram na interface.
- **Quatro clientes.** A versão com perfis pagou uma vez, registrou reputação e descoberta nos quatro clientes e preservou a entrega após a saída do portador. Um cliente que entrou no meio do contrato recebeu o estado e o portador atuais.
- **Perfil.** O armazenamento simulado passou pelos casos de migração de um registro legado, concorrência, liberação repetida, reabertura, bloqueio expirado e preservação de uma versão desconhecida do esquema.
- **NÃO EXECUTADO.** Integração com o DataStore real, desempenho em aparelho físico e playtest humano de retenção.

## Resultados locais do P3 — 2026-11-17

| Teste | Resultado | Evidência |
|---|---|---|
| Loja no PC | PASSOU | Duas entregas renderam 90 moedas. Faixa Laranja custou 70 e ficou equipada. Vinte pedidos de recompra preservaram o saldo de 20. A escolha de uma cor ainda bloqueada preservou a seleção. |
| Loja por toque | PASSOU NO EMULADOR | Galaxy A06 com viewport de 705 × 338. A aba abriu, a compra por toque debitou 70 e a linha passou a exibir “Em uso”. |
| Veículo | PASSOU | A van seguinte usou a pintura escolhida. Aceleração, motor e freios continuaram com multiplicador 1 para o perfil de teste. |
| Esquema de perfil | PASSOU EM MEMÓRIA | O esquema 1 manteve saldo, níveis, reputação e descobertas. O esquema 2 preservou a pintura comprada após reabertura. Bloqueios concorrentes e versões futuras foram respeitados. |
| Funil solo | PASSOU | Uma contagem em cada etapa da primeira entrega e na escolha de outra. Total de 90 moedas ganhas, 70 gastas e uma compra registrada. |
| Funil coop | PASSOU EM TESTE ISOLADO | Dois jogadores concluíram e repetiram no teste do módulo. Um iniciou a repetição. A entrada tardia ficou fora do funil da entrega já iniciada e a saída antecipada foi contada uma vez. |
| Sessão multicliente P3 | INTERROMPIDA | As janelas de jogadores simulados foram fechadas antes do resultado. |
| Apoio à aquisição | PRÉVIAS SALVAS | Duas cenas do protótipo em JPEG, 1920 × 1079. |

A amostra de dois segundos na loja do Galaxy A06 emulado registrou 60 FPS e 2.914 MB reportados pelo cliente do Studio. A configuração de Analytics do Roblox permaneceu desligada. DataStore real, painel do Creator Hub, teste de aquisição e playtest humano continuam pendentes.
