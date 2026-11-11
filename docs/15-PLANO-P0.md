# WRONG ADDRESS — Auditoria e plano de implementação do P0

> **Status:** aprovado pelo responsável em 2026-11-11. A aprovação cobre somente a "Primeira sessão" (§7); as demais etapas pedem autorização própria.
> O diagnóstico do §1 é um retrato de 2026-11-11 feito **sem** acesso ao Studio. O estado corrente fica em `STATUS.md`.

## Contexto

Pré-produção de um jogo Roblox original, dev solo. O P0 existe para responder a uma pergunta: **levar uma caixa que foge do ponto A ao B é divertido o bastante para querer repetir?** Este turno foi somente leitura: nenhum script, instância, arquivo de projeto ou configuração foi alterado.

**Aprovar este plano autoriza apenas a "Primeira sessão" (§7).** Todo o resto continua exigindo autorização por etapa.

**O jogo em resumo.** Entregador de uma transportadora estranha leva encomendas com comportamento anômalo; humor seco, caos legível e recuperável. Pilares: ação clara · caos administrável · atmosfera · repetição recompensadora (pós-P0) · acessibilidade operacional (solo, touch, coop opcional). Hipóteses a testar: H1 entende em ~30 s · H2 a fuga diverte · H3 quer repetir · H4 solo funciona · H5 touch viável · H6 coop agrega.

**Limites que não ultrapassamos no P0:** sem DataStore, moeda, loja, inventário, upgrades, IA/pathfinding, Event Director, procedural, narrativa, matchmaking; sem publicar/monetizar; sem assets de terceiros não inspecionados; servidor é a autoridade de missão; nada depende de 4 jogadores, voz ou teclado.

---

## 1. Diagnóstico do ambiente

### Verificado (com evidência de ferramenta)

| Item | Estado |
|---|---|
| Documentação | 20 arquivos lidos por inteiro (CLAUDE, README, STATUS, docs 00–14, prompt, template ADR) |
| Workspace local | Só documentação. Sem código Luau, sem `.rbxl/.rbxlx`, sem `*.project.json`, sem `.mcp.json`, sem `.claude/`. **Não é repositório git.** Pasta fica dentro do OneDrive |
| Ferramentas no PATH | `git`, `node`, `npx` presentes. `rojo`, `aftman`, `rokit`, `wally`, `lune`, `selene`, `stylua` ausentes |
| Roblox Studio | Instalado, `RobloxStudioBeta` 0.747 (atualizado hoje 01:55). **Não está em execução** — só o `RobloxPlayerBeta` (cliente de jogo) |
| Studio MCP | É nativo do Studio: `StudioMCP.exe` na pasta da versão, launcher `%LOCALAPPDATA%\Roblox\mcp.bat` (criado 02:05) |
| Registro do MCP | `~/.codex/config.toml` tem `[mcp_servers.Roblox_Studio]`. `~/.claude.json` tem **apenas `godot`**; o projeto não tem `mcpServers`; Claude Desktop também não |
| Ferramentas Roblox nesta sessão | **Nenhuma.** Busca por "roblox studio" retornou 0. O único MCP de engine carregado é `godot` (irrelevante) |

**Conclusão:** o MCP do Studio foi conectado ao **Codex CLI**, não ao Claude Code. O "MCP já configurado" do README não vale para esta sessão.

**Reconferido após sua resposta** ("já ativei o Quick connect"): `~/.claude.json` continua só com `godot` (modificado 02:26), o Studio segue fechado e nenhuma ferramenta Roblox apareceu. O Quick connect não gravou a entrada do Claude Code; por isso o `.mcp.json` do projeto entra na Parte A, como você autorizou.

### Catálogo de ferramentas do Studio MCP

Lido de `%LOCALAPPDATA%\Roblox\StudioMCP\tools-cache.json` (gerado hoje 02:08). É o catálogo do binário instalado, **não** uma conexão ativa. 38 ferramentas:

- **Leitura (14):** `list_roblox_studios`, `get_studio_state`, `search_game_tree`, `inspect_instance`, `script_read`, `script_search`, `script_grep`, `get_console_output`, `screen_capture`, `http_get`, `search_asset`, `skill`, `list_skills`, `wait_job_finished`
- **Escrita (4):** `multi_edit` (edita/cria scripts, só em Edit), `execute_luau` (Edit/Client/Server; congela o Studio até dar yield), `insert_asset`, `save_place` (nunca publica)
- **Playtest/input (4):** `start_stop_play` (só liga/desliga), `user_keyboard_input`, `user_mouse_input`, `character_navigation` (os três só no datamodel Client)
- **Geração por IA (10):** `generate_scene`, `generate_procedural_model`, `generate_mesh`, `generate_material`, `generate_texture`, `generate_animation`, `generate_avatar`, `auto_setup_avatar`, `segment_mesh`, `store_image`
- **Externo/nuvem (3):** `open_cloud_invoke`, `upload_image`, `submit_feedback`
- **Meta (3):** `subagent` (explore / screen_capture / unit_test), `create_skill`, `edit_skill`

Lacunas relevantes para teste: não há ferramenta dedicada para iniciar **Server & Clients** nem para **Device Emulator**. A doc de testing modes cita `StudioTestService` (até 8 clientes simulados) e `StudioDeviceSimulatorService`, possivelmente acionáveis por `execute_luau`.

### NÃO verificado

- Qual place existe (PlaceId, UniverseId ou arquivo), DataModel, serviços, scripts e objetos; se há trabalho anterior a preservar.
- Se o toggle "Enable Studio as MCP server" está ligado.
- Comportamento real das ferramentas: play, console, screenshot durante play, multi-cliente, emulação de dispositivo.
- Propriedades do place: `StreamingEnabled`, `AuthorityMode`, `PlayerScriptsUseInputActionSystem`, tipo de avatar.

---

## 2. Decisões e riscos

### 2.1 Inconsistências na documentação e resolução proposta

| # | Inconsistência | Resolução |
|---|---|---|
| 1 | README diz "MCP já configurado"; está no Codex, não no Claude Code | Pergunta bloqueante Q1 |
| 2 | GDD propõe 10 estados de missão; arquitetura propõe 5 estados de carga; ambos pedem "verificar necessidade real" | 4 fases de missão + 6 estados de carga (§3.3) |
| 3 | Estado `FAILED` existe sem nenhuma condição de falha definida | Removido. Reset cobre tudo |
| 4 | Gatilho da fuga aparece de 4 formas (`EscapeOnStop`, parada forçada, timer 50–100 s, "incidente controlado") | Um só: zona fixa na rota, 1× por missão |
| 5 | "1 pacote" (MVP) vs "caixa normal + `BOX_RUNNER`" (conteúdo) | Uma caixa; "normal" é ela antes de se agitar |
| 6 | Arquitetura lista 2 remotes e 4 intents, mas também diz preferir ProximityPrompt | ProximityPrompt + Attributes; **1** RemoteEvent |
| 7 | Intent `Deliver` vs "destino é uma zona" | Entrega automática ao parar na zona (Q4) |
| 8 | Limite de jogadores: 2 no GDD, 4 em outros pontos | Não configurar nada; teste local escolhe 1–2 clientes. `MaxPlayers` só importa em place publicado |
| 9 | T10 fala em "rewards" que não existem no P0 | Ler como "conclusão duplicada" |
| 10 | Backlog põe P0-08 (validação) no fim | Validação nasce em P0-04/06; P0-08 vira auditoria + testes negativos |
| 11 | Backlog põe graybox (02) antes do spike de veículo (03) | Inverto: largura de pista e raio de curva dependem do veículo |
| 12 | Exige backup/versionamento, mas não há arquivo de place nem git | Q2 e Q3 |

### 2.2 Decisões técnicas propostas

1. **Interações por `ProximityPrompt`.** `Triggered(player)` dispara no servidor; funciona em teclado, touch e gamepad sem UI própria. Elimina `RequestInteract`.
2. **Estado para o cliente por Attributes** em `ReplicatedStorage.WrongAddress.MissionState`. Quem entra depois ou dá respawn recebe o estado sozinho. Elimina `MissionStateChanged`.
3. **Um único RemoteEvent `ClientRequest`**, com duas ações: `RecoverVan` e `RestartDelivery` (botões da HUD). Não aceita nenhum outro argumento.
4. **Carregar a caixa = `WeldConstraint` no personagem**, `CanCollide=false`, `Massless=true`. A caixa nunca é filha do Character, então morte/saída só quebra a solda.
5. **Caixa na van = soldada ao compartimento.** Zero física solta durante a viagem.
6. **Fuga sem pathfinding:** arena cercada ao lado da pista com waypoints pré-colocados; a caixa vai ao waypoint mais distante do jogador mais próximo, em rajadas com pausa. Física não ancorada com dono servidor (`LinearVelocity` + `AlignOrientation`), porque parte ancorada movida por CFrame replica sem interpolação.
7. **Telegrafar a fuga** (~2,5 s de estado `Agitated`: destaque visual + aviso na HUD). Frear nessa janela faz a caixa cair perto — é a decisão do jogador.
8. **Entrega automática:** van parada dentro da `DeliveryZone` com caixa `Secured`, checado no servidor.
9. **Reset por clone de template** em `ServerStorage`: destruir van e caixa antigas, clonar novas. `Destroy()` desconecta eventos, o que mata a classe de bug "conexão duplicada".
10. **`StreamingEnabled = false` e mundo plano** (Baseplate + pista com muretas). Mapa minúsculo; evita instância ausente no cliente e queda no vazio.
11. **Veículo:** controle roda no cliente do motorista (dono da física), input lido do `VehicleSeat`. Spike compara **B** (corpo arcade único com `LinearVelocity`/`AngularVelocity`) contra **A-min** (4 rodas em `HingeConstraint`, sem molas).
12. **Descartados por análise, a registrar em ADR:** chassi pronto do Creator Store (script longo, exige inspeção) e o modo **Server Authority** (liberado em 2026, mas exige `BindToSimulation`, Input Action System, streaming e simulação fixa — reescrita desproporcional para coop sem recompensa).
13. **Input Action System não entra no P0.** Exige ligar `PlayerScriptsUseInputActionSystem`, e ProximityPrompt + VehicleSeat + 2 botões cobrem tudo.
14. **Ferramentas MCP permitidas no P0:** as 14 de leitura, `multi_edit`, `execute_luau`, `start_stop_play`, as 3 de input e `save_place` (só quando você pedir). **Nunca sem autorização:** `open_cloud_invoke`, `upload_image`, `insert_asset`, `generate_*`, `submit_feedback`, `create_skill`/`edit_skill`.

### 2.3 Riscos e contenção

| Risco | Contenção | Fallback |
|---|---|---|
| Veículo instável, capota ou treme | Spike com timebox de 1 sessão; candidato B não capota por construção | A-min → botões touch próprios → chassi oficial inspecionado (pede autorização) |
| Posição da van é verdade do cliente motorista | Sem recompensa no P0; conclusão exige fase + carga `Secured` + tempo mínimo | Documentar para P1 (validar velocidade ou Server Authority) |
| "Pop" visual quando a caixa sai da van | Ordem fixa: desfazer solda → posicionar → `SetNetworkOwner(nil)`; impulso + partícula | Ejetar só com van abaixo de certa velocidade |
| Captura rejeitada por latência (caixa se move no servidor) | Tolerância de distância no servidor; raio generoso; rajadas com pausa | Caixa para ao ser tocada |
| Recuperação longa e chata em vez de divertida | Números em `Config`: velocidade média ≤ 0,85× do jogador, duração, raio | Caixa corre a um ponto único e para |
| Fuga 100% scriptada vira "animação engraçada" | Janela `Agitated` dá agência; perguntar "entendeu por quê?" no teste | Variar a zona entre 2–3 fixas por rodada |
| Jogador senta carregando a caixa | Soltar automaticamente ao sentar | — |
| Jogador em pé dentro da van em movimento | Van fechada + 1 `Seat` de passageiro | — |
| Caixa ou van destruída por `FallenPartsDestroyHeight` | Mundo plano + watchdog de altura/limites que teleporta ao ponto seguro | Reclonar do template |
| ProximityPrompt acionado à distância por exploit | Servidor revalida distância, estado e identidade | — |
| Touch: dirigir e sair da van | Thumbstick padrão do `VehicleSeat`, sair pelo pulo; verificar no spike | 4 botões próprios + botão "Sair" |
| HUD cobre thumbstick ou pulo | HUD no topo/centro; checar 3 resoluções | — |
| Salvamento entrar por acidente | Critério de aceite: `script_grep "DataStore"` = 0 | — |
| `execute_luau` congela o Studio | Blocos pequenos com `task.wait()` | Dividir mais |
| `.rbxl` e `.git` dentro do OneDrive | Backups datados antes de cada sessão | Mover o projeto para fora do OneDrive (não bloqueia) |

---

## 3. Arquitetura mínima

### 3.1 Árvore de instâncias

```text
game
├── Workspace                      (StreamingEnabled = false)
│   └── WrongAddress
│       ├── Map                    (tudo Anchored)
│       │   ├── Depot
│       │   ├── Road               (segmentos + muretas)
│       │   ├── EscapeArena        (Trigger, Waypoints, SafePoint, Fence)
│       │   ├── Destination        (DeliveryZone)
│       │   └── Markers            (PlayerSpawn, VanSpawn, CargoSpawn, RecoverPoints)
│       └── Runtime                (Van e Cargo clonados; exatamente 1 de cada)
├── ServerStorage
│   └── WrongAddress/Templates     (Van, Cargo)
├── ReplicatedStorage
│   └── WrongAddress
│       ├── Config                 (ModuleScript)
│       ├── MissionState           (Configuration com Attributes)
│       └── Remotes/ClientRequest  (RemoteEvent)
├── ServerScriptService
│   └── WrongAddress
│       ├── Main                   (Script)
│       ├── Mission                (ModuleScript)
│       ├── Cargo                  (ModuleScript)
│       └── Vehicle                (ModuleScript)
├── StarterPlayer/StarterPlayerScripts
│   └── WrongAddressClient         (LocalScript)
└── StarterGui
    └── WrongAddressHUD            (ScreenGui, ResetOnSpawn = false)
```

Sete scripts no total. Todos `--!strict`.

### 3.2 Responsabilidades

| Script | Faz | Não faz |
|---|---|---|
| `Main` | Inicializa uma vez, injeta dependências, liga `ClientRequest`, loga `[WA] boot` | Regra de jogo |
| `Mission` | Fase, `missionId`, conclusão única, reset, cooldowns, escreve Attributes | Mover objetos |
| `Cargo` | Clonar caixa, pegar/soltar/colocar, fuga, captura, watchdog, ownership | Saber de fase |
| `Vehicle` | Clonar van, ownership por ocupante, recuperar van, teste "está na zona" | Ler input |
| `Config` | Números de teste e textos | Lógica |
| `WrongAddressClient` | HUD, seta, avisos, botões, **controle da van quando é o motorista** | Decidir estado |

`Cargo` não conhece `Mission`: expõe um callback de mudança de estado, e `Mission` assina. Sem dependência circular.

### 3.3 Máquina de estados

```text
Missão:   Loading ──(carga Secured)──> InTransit <──> CargoLost
                                          │
                 (van parada na zona ∧ carga Secured)
                                          v
                                      Completed ──(RestartDelivery)──> Loading (missionId+1)

Carga:    Loose ──pegar──> Carried ──colocar na van──> Secured
            ^                 │ soltar/morrer/sair/sentar   │ entra no gatilho (1×)
            └─────────────────┘                             v
            ^                                            Agitated ──2,5 s──> Escaping
            └──────── cansou (~40 s) ─────────────────────────────────────────┤
                              Carried <──────── capturar ─────────────────────┘
          Secured ──(Completed)──> Delivered
```

`CargoLost` é derivado: fase em trânsito com carga diferente de `Secured`. O texto da HUD é função de (fase, estado da carga, "sou eu que carrego?").

### 3.4 Comunicação

| Canal | Direção | Uso |
|---|---|---|
| `ProximityPrompt.Triggered` | cliente → servidor | Pegar, soltar, colocar na van, capturar |
| Attributes em `MissionState` | servidor → clientes | `Phase`, `CargoState`, `CarrierUserId`, `MissionId`, `EscapeCount`, tempos |
| `ClientRequest` (RemoteEvent) | cliente → servidor | `RecoverVan`, `RestartDelivery` |

### 3.5 Validação no servidor

Para todo `Triggered`:
1. Personagem existe e está vivo.
2. Debounce por jogador (~0,25 s).
3. Distância real entre `HumanoidRootPart` e o alvo ≤ alcance do prompt + tolerância.
4. Estado permite a ação (tabela ação → estados válidos).
5. Soltar e colocar só valem para quem é o `CarrierUserId`.

Para `ClientRequest`: tipo `string`, ação na lista, limite de frequência por jogador, cooldown por ação, elegibilidade de fase. Argumentos extras são ignorados — o cliente nunca informa posição, id ou resultado.

Conclusão da entrega: decidida só pelo servidor, uma vez por `missionId`, com fase `InTransit`, carga `Secured`, van dentro da zona e quase parada por ~0,5 s, e duração mínima de missão.

---

## 4. Plano por etapas

Ordem: 00 → 01 → **03 → 02** → 04 → 05 → 06 → 07 → 08 → 09 → 10. Estimativa grosseira: ~8 sessões curtas até P0-09.

### P0-00 — Conexão, inventário e backup
- **Objetivo:** ligar o Claude Code ao Studio MCP, identificar o place certo, inventariar, definir backup.
- **Cria:** nada no DataModel. No repo: plano persistido, `STATUS.md`, `.gitignore`, `git init` (se aprovado), pasta de backups.
- **Depende:** Q1 e Q2 (ações suas).
- **Aceite:** `list_roblox_studios` devolve a instância que você confirma; árvore e scripts existentes documentados; backup datado existe; capacidades reais de teste registradas.
- **Teste MCP:** `list_roblox_studios`, `get_studio_state`, `search_game_tree`, `inspect_instance`, `script_grep "DataStore"`, `get_console_output`, `screen_capture`.
- **Risco / fallback:** place com conteúdo prévio ou várias instâncias abertas → parar e perguntar. MCP não conecta → reiniciar Studio e cliente, conferir `mcp.bat`.

### P0-01 — Esqueleto e fonte da verdade
- **Objetivo:** criar a árvore vazia e registrar a decisão de sync.
- **Cria:** pastas de §3.1, `Config`, `MissionState`, `ClientRequest`, `Main` (só loga boot), `StreamingEnabled=false`. Repo: `docs/decisions/ADR-001-fonte-da-verdade.md`.
- **Depende:** P0-00, Q3.
- **Aceite:** Play solo mostra `[WA] boot ok` uma vez e zero erros; árvore confere por `search_game_tree`.
- **Teste MCP:** `start_stop_play`, `get_console_output`, `search_game_tree`.
- **Risco / fallback:** `StreamingEnabled` não gravável por script → você marca no painel Properties.

### P0-03 — Spike de veículo
- **Objetivo:** escolher a solução de veículo com evidência.
- **Cria (descartável, prefixo `WA_Spike`):** pista de teste com muretas, curva e lombada; `VanB`; `VanA` só se B falhar; `WA_SpikeDriver` (LocalScript); `WA_SpikeOwnership` (Script).
- **Depende:** P0-00.
- **Aceite:** anda, vira e freia; estável visto pelo segundo cliente; dirigível por thumbstick no emulador; sai pelo pulo; `ADR-002-veiculo.md` com velocidade máxima, raio de curva, frenagem e nº de peças não ancoradas.
- **Teste MCP:** sentar o personagem pelo servidor, `user_keyboard_input` W/A/S/D, ler posição e velocidade em Server e Client, `get_console_output`. Sensação, touch e 2 clientes são manuais.
- **Risco / fallback:** B "ensaboado" → ajustar aderência lateral; persiste → A-min; touch não responde → botões próprios.

### P0-02 — Graybox
- **Objetivo:** depósito, pista, arena de fuga e destino navegáveis.
- **Cria:** `Workspace.WrongAddress.Map` completo, por script paramétrico guardado em `tools/studio/build_graybox.luau` e executado via `execute_luau` em blocos. Iluminação leve.
- **Depende:** P0-01, P0-03 (dimensões).
- **Aceite:** percurso completo de van sem sair da pista; zero `BasePart` não ancorada em `Map` (asserção automática); muretas contínuas; captura de tela.
- **Teste MCP:** asserções por `execute_luau`, `screen_capture`, play + teclado.
- **Risco / fallback:** escala errada → mudar parâmetros e reexecutar.

### P0-04 — Carga: clonar, pegar, soltar, colocar
- **Objetivo:** manipulação confiável da caixa.
- **Cria:** `Templates.Cargo`, `Templates.Van` (do vencedor do spike, com `CargoBay`), módulos `Cargo` e `Vehicle`.
- **Depende:** P0-02, P0-03.
- **Aceite:** T03, T04, T17; 10 repetições sem duplicar; solta ao morrer, sair ou sentar; dono de rede correto em cada estado.
- **Teste MCP:** `character_navigation` + acionar prompt, ler Attributes, contar instâncias em `Runtime`.
- **Risco / fallback:** solda arremessa o personagem → já mitigado; carregar ruim no mobile → caixa segue o jogador por `AlignPosition`.

### P0-05 — Fuga e captura
- **Objetivo:** o momento central do P0.
- **Cria:** estados `Agitated`/`Escaping` em `Cargo`, constraints no template, uso de `Waypoints`, sinal visual.
- **Depende:** P0-04.
- **Aceite:** T06, T07, T11; fuga 1× por missão e telegrafada; caixa nunca deixa a arena; cansa e vira `Loose` após o tempo limite.
- **Teste MCP:** posicionar a van antes do gatilho e acelerar; forçar caixa fora dos limites e ver voltar; navegar até a caixa e capturar.
- **Risco / fallback:** ver §2.3 (chato, latência, falta de agência).

### P0-06 — Missão, entrega e reset
- **Objetivo:** um contrato completo, repetível.
- **Cria:** módulo `Mission`, Attributes, handler de `ClientRequest`.
- **Depende:** P0-02, P0-04, P0-05, Q4.
- **Aceite:** T08, T09, T12; conclusão exatamente uma vez; 5 resets seguidos com contagem de instâncias estável.
- **Teste MCP:** sequência completa scriptada com asserções a cada transição.
- **Risco / fallback:** reentrância no reset → flag `resetting`; van destruída com ocupante → desassentar antes.

### P0-07 — HUD e touch
- **Objetivo:** objetivo sempre claro em PC e celular.
- **Cria:** `WrongAddressHUD` (objetivo, seta, aviso, painel de resultado, botão de recuperar), `WrongAddressClient`, marcador sobre o alvo.
- **Depende:** P0-03, P0-06.
- **Aceite:** T16, T17; texto correto em cada estado; nada sobre thumbstick ou pulo em 3 resoluções.
- **Teste MCP:** ler textos no Client por estado; asserção de limites da GUI. Emulador é manual.
- **Risco / fallback:** seta confusa → marcador com distância apenas.

### P0-08 — Auditoria de validação
- **Objetivo:** provar que estado inválido não avança nada.
- **Cria:** nada novo; ajustes pontuais.
- **Depende:** P0-04, P0-06.
- **Aceite:** T10, T18; nenhum erro no console sob spam.
- **Teste MCP:** no Client, disparar `ClientRequest` com tipos e ações inválidos e acionar prompts à distância; conferir no Server que nada mudou.

### P0-09 — Bateria de testes
- **Objetivo:** matriz T01–T18 com PASSOU / FALHOU / NÃO EXECUTADO e evidência.
- **Depende:** tudo. Ver §5.

### P0-10 — Jogadores externos
- **Objetivo:** medir H1–H3 e decidir GO / ITERAR / PIVOT.
- **Depende:** P0-09, Q5. Publicação privada exige autorização explícita; alternativa sem publicar é teste presencial no seu PC.

---

## 5. Testes

Legenda: **AUTO** = eu executo pelo MCP · **SEMI** = depende de capacidade a confirmar na sessão 1 · **MANUAL** = você.

### Solo

| Teste | Como | Quem |
|---|---|---|
| T01 Spawn | Play; conferir van, caixa, zona, personagem, Attributes iniciais | AUTO |
| T03 Pegar | Navegar até a caixa, acionar prompt, ler `CargoState` | AUTO |
| T04 Colocar na van | Navegar ao compartimento, acionar, ler fase | AUTO |
| T05 Direção (responde) | Sentar, teclas, medir deslocamento | AUTO |
| T05 Direção (sensação) | Dirigir o percurso | MANUAL |
| T06 Fuga | Van antes do gatilho, acelerar, ler estados | AUTO |
| T07 Captura | Navegar até a caixa e capturar | SEMI |
| T08 Entrega única | Parar na zona; conferir `MissionId` e contagem | AUTO |
| T09 Cinco resets | Pedir reset 5×; contar instâncias; console limpo | AUTO |
| T10 Spam | Centenas de pedidos e acionamentos | AUTO |
| T11 Queda da caixa | Jogar a caixa fora dos limites | AUTO |
| T12 Van presa | Virar a van, pedir recuperação, testar cooldown | AUTO |
| T17 Respawn | Matar personagem carregando; conferir HUD | AUTO |
| T18 Segurança | Pedidos inválidos e prompts à distância | AUTO |
| T13 Sessão inteira sem debug | Jogar do início ao fim | MANUAL |
| T02 Entendimento | Pessoa sem instrução | MANUAL (P0-10) |
| Desempenho | FPS de física e memória durante play | AUTO (PC) |

### Dois clientes

| Teste | Como | Quem |
|---|---|---|
| T14 Disputa pela caixa | Dois jogadores acionam ao mesmo tempo | SEMI |
| T14 Van vista pelo outro | Um dirige, outro observa e anda de passageiro | MANUAL |
| T15 Sair carregando | Fechar o cliente que segura a caixa | SEMI |
| Estado final igual nos dois | Comparar HUD ao concluir | MANUAL |
| Entrar no meio da missão | Segundo cliente entra durante a fuga | SEMI |

SEMI aqui depende de `StudioTestService` funcionar via `execute_luau` e de cada cliente aparecer em `list_roblox_studios`. Se não, você inicia Server & Clients (2) e eu leio o console.

### Mobile

| Teste | Como | Quem |
|---|---|---|
| T16 Pegar, colocar, capturar | Device Emulator, toque nos prompts | MANUAL |
| T16 Dirigir e sair da van | Thumbstick e botão de pulo | MANUAL |
| HUD não cobre controles | 3 resoluções; asserção de limites | SEMI + MANUAL |
| Entrega completa sem teclado | Sessão inteira no emulador | MANUAL |
| Desempenho em aparelho real | Exige place salvo no Roblox | MANUAL (Q5) |

---

## 6. Perguntas bloqueantes

| # | Pergunta | Situação | Bloqueia |
|---|---|---|---|
| Q1 | Como conectar o Studio MCP ao Claude Code? | **Respondida:** você ativou o Quick connect e autorizou o `.mcp.json` como reforço. A entrada não chegou ao Claude Code, então eu crio o `.mcp.json` | Tudo no Studio |
| Q2 | Qual place usar? | **Respondida:** Baseplate novo, arquivo local em `place/WrongAddress.rbxl` | P0-00 |
| Q3 | Fonte da verdade e versionamento? | **Respondida:** Studio é a fonte única; `git init` para docs, ADRs e scripts de build; cópia datada do `.rbxl` antes de cada sessão; sem Rojo | P0-01 |
| Q4 | Como a entrega conclui? | Padrão assumido: automática ao parar a van na zona | P0-06 |
| Q5 | Posso salvar o place no Roblox (privado) para teste em celular real e externos? | Padrão assumido: não por enquanto; emulador até P0-09 | P0-09/10 |

Q4 e Q5 seguem com o padrão até você dizer o contrário.

---

## 7. Primeira sessão sugerida

Escopo: **P0-00 + P0-03**. Nada de mapa final, carga, missão ou HUD.

### Parte A — sem Studio, logo após a aprovação
1. Gravar este plano em `docs/15-PLANO-P0.md` e adicionar a linha no `docs/00-INDICE.md`.
2. Atualizar `STATUS.md` com o diagnóstico verificado.
3. Criar `.mcp.json` na raiz com a entrada `Roblox_Studio` (`cmd.exe /c %LOCALAPPDATA%\Roblox\mcp.bat`, conforme a doc oficial).
4. `git init`, `.gitignore` (`*.rbxl.lock`), criar a pasta `place/` e fazer o primeiro commit só de documentação e configuração.

### Parte B — ações suas
5. Abrir o Studio, criar um Baseplate e fazer **Save As** em `place/WrongAddress.rbxl`.
6. Conferir que "Enable Studio as MCP server" está ligado (Assistant → … → Manage MCP Servers).
7. Abrir nova sessão do Claude Code nesta pasta e aceitar o servidor `Roblox_Studio` do `.mcp.json`. O plano estará em `docs/15-PLANO-P0.md`.

### Parte C — com Studio conectado
8. `list_roblox_studios` → você confirma nome/arquivo da instância.
9. Inventário só com ferramentas de leitura; registrar em `STATUS.md`.
10. Sondar capacidades de teste: play, console, captura, multi-cliente, emulador.
11. Copiar o `.rbxl` para a pasta de backups com data.
12. Construir a pista de teste e a `VanB` sob `Workspace.WA_Spike`.
13. Testes automáticos de direção; depois seus testes manuais (PC, emulador touch, 2 clientes) — cerca de 10 minutos.
14. Se B reprovar em algum critério, construir `VanA` e repetir.
15. Escrever `ADR-002-veiculo.md`, remover o candidato perdedor, atualizar `STATUS.md`.

### Verificação da sessão
- Console sem erros durante o play do spike.
- Números medidos no ADR (velocidade, raio de curva, frenagem).
- Seu veredito nos 5 critérios de veículo, registrado como PASSOU / FALHOU / NÃO EXECUTADO.
- `search_game_tree` mostra apenas instâncias `WA_Spike*` novas.

---

## Fontes

- Studio MCP: https://create.roblox.com/docs/studio/mcp
- Modos de teste: https://create.roblox.com/docs/studio/testing-modes
- Network ownership: https://create.roblox.com/docs/physics/network-ownership
- Input Action System: https://create.roblox.com/docs/input/input-action-system
- Server Authority: https://create.roblox.com/docs/projects/server-authority
- Anúncio de lançamento do Server Authority: https://devforum.roblox.com/t/full-release-ship-fair-and-competitive-games-with-server-authority/4727993
