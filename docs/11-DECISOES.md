# Riscos, decisões abertas e ADRs

## Riscos prioritários

| Risco | Impacto | Contenção |
|---|---|---|
| Veículo difícil em Roblox | Alto | Spike antes de criar todo o loop; arcade simplificado |
| Desync da caixa | Alto | Servidor controla estados críticos; testar 2 clientes |
| Gameplay vira só dirigir | Alto | Fuga/recuperação precisa ser interativa e divertida |
| Mecânica confusa no touch | Alto | Prototipar touch desde P0 |
| Escopo cresce para mundo aberto | Alto | Não aceitar features fora do gate |
| Desempenho ruim mobile | Médio/alto | Limitar física e assets, testar cedo |
| Monetização fraca | Médio/alto | Não presumir demanda; testar somente em P3 |
| Dependência de ferramenta MCP | Médio | Confirmar capacidades e alternativas antes de criar |

## Decisões já tomadas

- D-001: foco inicial em **Wrong Address**, não Don't Open It!, para este repositório.
- D-002: desenvolvimento **solo**; sistema não pode depender de equipe grande.
- D-003: primeiro marco é **P0 da caixa fugitiva**; zero monetização/persistência.
- D-004: solo como base e coop como extensão de diversão.
- D-005: priorizar confiabilidade mobile e clareza a realismo de física.
- D-006: planejamento inicial via Claude Code é **somente leitura** e requer aprovação para modificar.

## Em aberto — Claude deve investigar e recomendar

1. Existe um lugar Roblox já aberto? Qual o ID e o estado dos scripts?
2. Qual é o servidor MCP usado, quais tools reais e como ler/alterar/testar?
3. Fluxo de sincronização Studio ↔ arquivos: MCP puro, Rojo ou outro já disponível?
4. Solução de veículo mais simples e estável para Studio/mobile?
5. Como restringir pacote fugitivo e recover fallback sem pathfinding complexo?
6. Limite inicial de players P0: 1 e 2, posterior 4; que configuração prática adotar?

## Registro de decisões

Quando uma escolha técnica mudar, criar um ADR em `docs/decisions/ADR-xxx-NOME.md` baseado em `templates/ADR.md`, contendo alternativas, trade-offs e evidências. Não reescrever fatos históricos para fazer parecer que sempre foi a escolha original.
