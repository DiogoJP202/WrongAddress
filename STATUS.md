# Status — WRONG ADDRESS

- Data de referência: 2026-11-17
- Fase: preparação local do P3.
- P0-00 a P0-09 concluídos. O teste humano de primeira partida do P0-10 continua pendente.
- **P1 implementado e verificado localmente** com seis contratos, quatro destinos e sessão de quatro clientes.
- **P2 implementado e verificado no Studio** com garagem, catálogo, reputação e contrato desbloqueável. A integração com o DataStore real ainda precisa de teste.
- **P3 local** com loja de pinturas em moedas do jogo, métricas da primeira entrega e duas miniaturas do protótipo. [Plano de lançamento](docs/16-LANCAMENTO.md)
- Projeto Roblox Studio inspecionado via MCP: Sim
- Build local: pegar, carregar, dirigir, reagir à fuga, recuperar, entregar e jogar de novo.
- [Matriz do P0 e resultados do P1/P2/P3](docs/14-ACEITE.md).
- Publicação do protótipo: local.

## Decisão do veículo

Adotado o **candidato B, corpo arcade único** — ver `docs/decisions/ADR-002-veiculo.md` (medidas, teste de 2 clientes e testes manuais). O candidato A não foi construído porque B passou nos critérios.

A van atual tem câmera elevada para o motorista e recuperação pelo HUD. O mapa do P0 é plano. A suavidade percebida por dois jogadores segue para o playtest humano.

## Place

- Fonte da verdade: arquivo local `place/WrongAddress.rbxl`.
- Backups em `place/backups/` (fora do git), incluindo cópias antes de P0-05, P0-06 e P0-07.
- Existe uma experiência "WrongAddress" na nuvem (placeId 108005427964214), criada por engano no primeiro salvamento. **Não é usada.** Pode ser arquivada pelo responsável.
- O id MCP da instância muda a cada abertura do Studio; sempre obter por `list_roblox_studios`.
- `StreamingEnabled = false` desde o P0-01.

## Esqueleto e graybox (P0-01 e P0-02, 2026-11-13)

- `ReplicatedStorage.WrongAddress` contém `Config`, `MissionState` e `Remotes.ClientRequest`. O estado é replicado por Attributes. O servidor aceita pedidos de recuperar a van ou jogar de novo.
- `ServerScriptService.WrongAddress.Main` inicializa `Vehicle`, `Cargo` e `Mission`. `PlayerPlacement` posiciona personagens ao recuperar a van ou reiniciar.
- `ServerStorage.WrongAddress.Templates` contém a van e a caixa. `Workspace.WrongAddress.Runtime` recebe exatamente uma de cada em Play.
- `Workspace.WrongAddress.Map`: 51 partes, todas ancoradas — `Depot`, `Road` (3 retas de 48 studs de largura, 2 cantos, lombada), `EscapeArena` (campo cercado de 160 × 120 com `Trigger`, 6 `Waypoints`, `SafePoint`), `Destination` (`DeliveryZone` de 36 × 48, casa, farol luminoso) e `Markers` (`PlayerSpawn`, `VanSpawn`, `CargoSpawn`, 6 `RecoverPoints`).
- O `SpawnLocation` do template foi movido para `Markers.PlayerSpawn`, no depósito.
- O graybox é gerado por `tools/studio/build_graybox.luau`; para mudar o mapa, alterar o script e reexecutar com `Map` vazio.
- `tools/studio/build_p1_routes.luau` acrescenta as entradas laterais, as novas vagas e as peças dos incidentes após gerar o mapa base.

Evidência (Play solo, automação):
- P0-01: `[WA] boot ok` uma vez, zero erros; o cliente recebeu `Phase=Loading`, `CargoState=Loose`, `MissionId=1` e carregou o `Config`.
- P0-02: a van do spike, guiada por waypoints, saiu do `VanSpawn`, percorreu a rota de ~1.060 studs em ~26 s, passou a lombada e parou **dentro** da `DeliveryZone`; nunca inclinou (vetor "para cima" ≥ 0,997). O jogador nasceu no depósito.
- A automação de 2026-11-16 percorreu a estrada e a arena com controles de jogo. Julgamento humano de escala e legibilidade fica para o P0-10.

## Entrega jogável (P0-04 a P0-09)

- **Carga.** Um prompt alterna entre pegar, soltar, colocar na caçamba e capturar. Morte, respawn, saída e entrada no banco liberam a caixa carregada.
- **Fuga.** O gatilho depois da lombada inicia um aviso de 2,5 s. Frear faz a caixa aparecer perto da entrada da arena. Ela corre em rajadas por waypoints sob controle do servidor, volta ao ponto seguro se sair dos limites e fica disponível para pegar após 40 s. A fuga ocorre uma vez por entrega.
- **Missão.** A entrega é automática com a caixa presa e a van quase parada por 0,5 s na área verde. O tempo mínimo desde a primeira carga é de 8 s. Recuperar a van usa o ponto seguro mais próximo e tem espera de 8 s. Jogar de novo recria a van e a caixa e devolve os jogadores ao depósito.
- **HUD.** Indica o objetivo, a direção quando o alvo está fora de quadro, a distância em linha reta, a fuga e o resultado. Os botões de recuperar e jogar de novo funcionam por toque.
- **Verificação.** Percurso solo completo em 47,4 s com controles simulados. Dois clientes confirmaram a mesma carga, fuga e entrega. Cinco reinícios seguidos mantiveram uma van, uma caixa e 44 descendentes em `Runtime`. Os testes de toque usaram o Galaxy A06 para as ações do jogo e três resoluções para a HUD.

## Contratos e progressão

- O grupo compartilha um contrato por vez. Para entregar, a van passa por três pontos da estrada, para na vaga verde e mantém a caixa presa. A conveniência também exige alinhamento na vaga.
- Seis cargas e quatro destinos compõem os contratos iniciais. Os incidentes são obra com desvio ou remoção da barreira, parada obrigatória, falha temporária dos faróis e mudança de vaga.
- O pagamento considera a integridade da caixa e é concedido uma vez a cada jogador conectado por entrega. As métricas de sessão ficam em `ServerStorage.WrongAddress.SessionMetrics`.
- A garagem permite melhorar motor e freios em dois níveis. A van usa as melhorias de quem escolhe o contrato. Cada entrega registra reputação e, na primeira entrega de um tipo de caixa, a descoberta no catálogo. Reputação 3 libera a entrega no pátio norte.
- O perfil usa armazenamento em memória no Studio. O código da experiência publicada usa `UpdateAsync` e um bloqueio de sessão com expiração. [ADR-003](docs/decisions/ADR-003-perfis.md)

## Preparação de lançamento

- A aba Pinturas tem a cor Original e três opções cosméticas. A compra debita moedas do jogo uma vez e equipa a cor na van do próximo contrato escolhido pelo jogador. O esquema 2 preserva os dados do P2 e grava as pinturas e a seleção.
- O funil registra cada etapa uma vez por jogador. A participação na segunda entrega e a ação de iniciá-la têm contagens próprias.
- As miniaturas Fuga e Entrega são cenas preparadas com o mapa e os modelos do jogo. Ambas estão no projeto para teste de aquisição futuro.

## Spike histórico (prefixo `WA_Spike`)

Preservado nos backups anteriores ao P0-04.

- `Workspace.WA_Spike.Track`: 9 partes ancoradas (retas, canto, muretas, lombada).
- `Workspace.WA_Spike.VanB`: 13 partes num único conjunto, `VehicleSeat` + `Seat`, 2 prompts, `LinearVelocity` e `AngularVelocity`.
- `ServerScriptService.WA_SpikeOwnership`: dono de rede por ocupante e prompts de entrada.
- `StarterPlayer.StarterPlayerScripts.WA_SpikeDriver`: controle local da van (com gancho de teste só no Studio).
- `ServerScriptService.WA_SpikeMpTest` e `StarterPlayerScripts.WA_SpikeMpTestClient`: teste automático de 2 clientes; inertes em Play normal.

## Capacidades de teste confirmadas por execução

- Play solo com `execute_luau` em Server e Client, teclado e mouse emulados, captura de tela.
- Emulador de celular por `StudioDeviceSimulatorService` (definir antes do Play); toque emulado pelo mouse funciona no thumbstick.
- Dois clientes por `StudioTestService:ExecuteMultiplayerTestAsync` via `execute_luau`, com resultado devolvido por `EndTest`.
- Rede simulada por `settings().Network` (restaurar zeros ao final).
- O Studio em segundo plano rodou a ~15 FPS nos testes automatizados. O salvamento por MCP foi verificado com retorno `LocalFile` para `place/WrongAddress.rbxl`.

## Ambiente

- `.mcp.json` na raiz carrega o servidor `Roblox_Studio` no Claude Code.
- Sem Rojo, Aftman, Rokit, Wally, Lune, Selene ou StyLua. `git` e `node` presentes.
- Repositório git para docs, ADRs e scripts de build; scripts do jogo vivem no Studio.

## Decisões registradas

- Conexão: `.mcp.json` do projeto.
- Place: arquivo local, backup por cópia datada antes de cada sessão.
- Fonte da verdade: Studio para scripts do jogo. Sem Rojo.
- Veículo: corpo arcade único (ADR-002).
- Padrões assumidos: entrega conclui ao parar a van na zona; nada salvo no Roblox.

## Próxima ação

Validar DataStore e Analytics em uma experiência de teste publicada, depois observar a primeira partida de jogadores externos. O plano de lançamento registra as verificações pendentes. [Preparação de lançamento](docs/16-LANCAMENTO.md)

## Histórico de mudanças

- 2026-11-11 — Documentação inicial elaborada. Nenhum componente do jogo foi criado por este pacote.
- 2026-11-11 — Auditoria e plano do P0 aprovados (`docs/15-PLANO-P0.md`). Criados `.mcp.json`, `.gitignore`, `place/README.md`; repositório git iniciado.
- 2026-11-11 — Studio conectado via MCP; inventário em leitura. Place convertido de nuvem para arquivo local. Spike `WA_Spike` construído (pista + VanB + 2 scripts).
- 2026-11-13 — Testes automáticos do candidato B (teclado, lombada, mureta, entrada/saída, touch emulado) e ajuste do remapeamento de diagonal.
- 2026-11-13 — Testes manuais do responsável aprovados (direção no PC, thumbstick e saída no celular emulado). Teste automático de 2 clientes em rede normal e 4G simulado. ADR-002 aceito. Place salvo.
- 2026-11-13 — P0-01 (esqueleto, `StreamingEnabled=false`, ADR-001) e P0-02 (graybox por `tools/studio/build_graybox.luau`) concluídos e verificados por automação. Place salvo; backup `antes-P0-01` em `place/backups/`.
- 2026-11-16 — Confirmado o P0-04 já presente no place salvo. P0-05 a P0-08 implementados e salvos localmente. P0-09 registrado após testes solo, com dois clientes e no emulador touch.
- 2026-11-16 — Com autorização para continuar antes do playtest humano, implementados P1 e P2. Backups `antes-P1` e `antes-P2` preservam os marcos anteriores.
- 2026-11-17 — Salvas a loja de pinturas e a instrumentação do P3 local. Capturadas as imagens Fuga e Entrega. Backup `antes-P3` preserva o P2.
