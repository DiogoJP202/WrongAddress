# Proposta de arquitetura técnica — Roblox Studio + Luau

> Documento **propositivo**, não árvore já existente. Claude deve primeiro inspecionar o projeto real via MCP e adequar a estrutura. APIs e ferramentas devem ser confirmadas na versão atual do Studio.

## Princípios

- Vertical slice end-to-end antes de abstrações pesadas.
- Código legível, módulos pequenos, `--!strict` quando viável.
- Servidor como autoridade de estados de missão, inventário de carga, resultado e economia.
- Cliente para input, HUD, câmera, efeitos e feedback visual; nunca decide recompensa.
- Não depender de replicar dezenas de objetos físicos soltos; preferir comportamentos controlados com estados/posições validadas.
- Nada de chamada remota a cada frame para mover caixa/veículo; usar mecanismo de física/input apropriado e validar transições críticas.
- Cada recurso de gameplay deve ter fallback que permita testar sem arte final.

## Árvore Studio sugerida (P0)

```text
game
├── ReplicatedStorage
│   └── WrongAddress
│       ├── Shared
│       │   ├── Config                (ModuleScript)
│       │   └── Types                 (ModuleScript, se necessário)
│       └── Remotes
│           ├── RequestInteract       (RemoteEvent)
│           └── MissionStateChanged   (RemoteEvent)
├── ServerScriptService
│   └── WrongAddress
│       ├── Bootstrap.server.lua
│       ├── MissionService           (ModuleScript)
│       ├── CargoService             (ModuleScript)
│       └── VehicleService           (ModuleScript ou wrapper mínimo)
├── StarterPlayer
│   └── StarterPlayerScripts
│       └── WrongAddressClient.client.lua
├── StarterGui
│   └── WrongAddressHUD              (ScreenGui)
└── Workspace
    └── WrongAddressMap
        ├── Depot
        ├── Route
        ├── DeliveryZone
        ├── VehicleSpawn
        └── CargoSpawn
```

**Observação:** nomes e remotes são sugestões. Se um ProximityPrompt nativo fizer o trabalho, não criar `RequestInteract` desnecessário. O planejamento deve propor a **árvore menor que cumpra P0**.

## Responsabilidades

- `Bootstrap`: inicializar serviços uma vez, garantir bindings/eventos, logs de inicialização.
- `MissionService`: estado, jogador/grupo, fase atual, conclusão/reset, anti-duplicação.
- `CargoService`: spawn único, captura/liberação, fuga/recuperação e posição segura.
- `VehicleService`: spawn, controles escolhidos, verificação de veículo ativo e recuperação se preso.
- `Config`: valores de teste, nomes e timers; evitar números mágicos em dezenas de scripts.
- `Client`: instruções, indicadores, efeitos e entradas sensíveis à plataforma.

## Exemplo de contrato de comunicação (não API implementada)

| Intent do cliente | O que servidor verifica | Resposta |
|---|---|---|
| `PickUpCargo(cargoId)` | jogador perto da carga; estado válido; pacote não pego por outro | atualiza proprietário/estado |
| `DropCargo` | jogador realmente carrega; local permitido | solta ou coloca no veículo |
| `Deliver` | fase correta; veículo e carga em área válida; contrato não concluído | conclui exatamente uma vez |
| `RequestReset` | cooldown e estado elegível | restaura missão segura |

Verificar identificador de sessão/contrato para impedir comandos de contratos anteriores. Rate limit/anti-spam nos remotes usados; nunca aceitar recompensa, saldo ou localização declarada pelo cliente como verdade.

## Veículo: spike técnico obrigatório

O maior risco é o carro. Comparar **A)** veículo simples com chassi/constraints nativos, **B)** solução cinemática/arcade controlada com segurança, **C)** outro sistema já disponível no Studio. Escolher o menor custo que:

1. funcione com teclado e touch;
2. replique bem a direção em multiplayer;
3. não atravesse obstáculos facilmente;
4. seja recuperável se ficar preso;
5. não dependa de assets pagos ou modelos inseguros.

A escolha não é fixada por esta documentação. Antes de optar por solução com física distribuída, estudar propriedade de rede e implicações de segurança.

## Físicas da carga

Para o P0, `BOX_RUNNER` pode alternar entre `Secured`, `Escaping`, `Recoverable`, `Carried`, `Delivered`. **Não** precisa simular uma criatura com navegação universal. Pode usar movimento dirigido em trecho limitado e telemetria de fallback. Prioridade: percepção de fuga, perseguição divertida e repetibilidade.

## Persistência

Não implementar P0. P2 usará `DataStoreService` através de um serviço de perfis, com atualizações atômicas, retries delimitados e versionamento de schema. Ver `06-DADOS-E-ECONOMIA.md`.

## Ferramentas e sync

MCP já está configurado segundo usuário. Claude deve listar as ferramentas reais e inspecionar Studio. Se existir Rojo/repo, decidir origem da verdade e forma de sincronização **antes** de escrever em ambos. Nunca duplicar scripts em filesystem e Studio sem um fluxo definido.

## Observabilidade

Usar prefixo `[WA]` para logs de desenvolvimento (não spam por frame). Registrar transições relevantes e erros. Evidência de testes: instância, scripts alterados, logs, resultado, impedimentos.
