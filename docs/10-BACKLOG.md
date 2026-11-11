# Backlog executável por fases

> Backlog de planejamento. As tarefas não estão implementadas; não marque prontas sem evidência no Studio.

## P0 — Backlog priorizado

| ID | Tarefa | Dependência | Aceite |
|---|---|---|---|
| P0-00 | Inventariar Studio/MCP, escolher projeto e backup | Nenhuma | Estado real e capacidades documentados |
| P0-01 | Definir árvore mínima, fases e estratégia de sync | P0-00 | Plano claro sem duplicidade fonte de verdade |
| P0-02 | Graybox: depósito, trecho de estrada, destino | P0-01 | Caminho completo navegável |
| P0-03 | Spike veículo arcade PC/touch | P0-01 | Move, vira, freia e não explode em 2-clientes |
| P0-04 | Cargo: spawn/pegar/soltar/colocar | P0-02 | Ação repetível, sem duplicação |
| P0-05 | Fuga controlada e captura | P0-04 | Pacote escapa e recupera, com fallback |
| P0-06 | Serviço de missão e entrega | P0-02, P0-04 | 1 contrato completo e reset |
| P0-07 | HUD minimalista e input touch | P0-03, P0-06 | Objetivo claro em PC/mobile |
| P0-08 | Proteção de remotes/anti-spam | P0-04, P0-06 | Estados inválidos não dão conclusão |
| P0-09 | Testes solo, duo e edge cases | Todos | Evidência por cenário de `14-ACEITE.md` |
| P0-10 | Sessão com jogadores externos e relatório | P0-09 | Medidas e conclusão GO/ITERAR/PIVOT |

## P1 — Após gate

- P1-01: Dados de contrato + quatro destinos.
- P1-02: Seis definições de carga, quatro comportamentos ativos no total.
- P1-03: Quatro eventos externos, com cooldown e matrizes compatíveis.
- P1-04: Sistema de recompensa da sessão; evitar exploits.
- P1-05: Multiplayer até quatro jogadores e saída/entrada segura.
- P1-06: Métricas de funil e novo teste externo.

## P2 — Após gate

- P2-01: Schema de profile e política de persistência.
- P2-02: Garage UI simples e 2–4 upgrades.
- P2-03: Catálogo de cargas descobertas.
- P2-04: Reputação/novas rotas.
- P2-05: Falhas de DataStore, concorrência e migrações.
- P2-06: Retenção e balanceamento de economia.

## P3 — Após gate

- P3-01: Analytics/dashboards estruturados.
- P3-02: Loja cosmética pequena (sem P2W).
- P3-03: Teste de aquisição via thumbnails, vídeos e criadores.
- P3-04: Revisar localização, políticas, acessibilidade e performance.

## Regra de execução do Claude

A cada entrega de tarefa: objetivo, alteração efetiva, teste executado, resultado, risco restante e referência ao ID. Não trabalhar em vários épicos simultaneamente sem motivo. Ao fim de cada etapa autorizada, atualizar STATUS e reportar próximos itens.
