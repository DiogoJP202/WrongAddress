# ADR-001 — Fonte da verdade do código e do place

- Data: 2026-11-13
- Status: aceita
- Relacionado ao gate: P0 (tarefas P0-00 e P0-01)

## Contexto

`docs/11-DECISOES.md` deixou em aberto o fluxo Studio ↔ arquivos, e `docs/05-ARQUITETURA.md` proíbe duplicar scripts entre filesystem e Studio sem um fluxo definido. Na auditoria não havia Rojo, Aftman, Rokit nem Wally instalados, a pasta não era repositório git e o Studio MCP edita o DataModel diretamente.

## Alternativas

1. **Studio como fonte única + git simples.** Scripts do jogo só existem no place; o repositório guarda documentação, ADRs e scripts de build. Vantagem: nada a instalar, um único lugar para cada coisa. Desvantagem: sem diff de código por arquivo; o histórico do código depende de cópias do `.rbxl`.
2. **Rojo.** Código em arquivos `.luau`, sincronizado para o Studio. Vantagem: diff e histórico de código. Desvantagem: instalar ferramenta e plugin, manter um segundo fluxo de sync e decidir o que fica fora dele (instâncias, mapa) já no P0.
3. **Studio sem git.** Mais simples ainda, mas docs e decisões ficam sem histórico.

## Decisão

Alternativa 1, escolhida pelo responsável em 2026-11-11.

- **Scripts do jogo:** vivem só no Studio, editados via MCP (`multi_edit`).
- **Place:** arquivo local `place/WrongAddress.rbxl`. Antes de cada sessão de mudanças, cópia datada em `place/backups/` (fora do git).
- **Repositório git:** documentação, ADRs e scripts de build em `tools/studio/`. Um script de build é a origem do que ele constrói: muda-se o arquivo e reexecuta-se no Studio, nunca o contrário.
- **Nuvem:** nada é salvo no Roblox sem autorização.

## Consequências

- Não há revisão de código por diff. Para auditar um script, lê-se no Studio (`script_read`).
- Recuperar um estado antigo significa abrir um backup do `.rbxl`.
- Em 2026-11-13, o salvamento local foi feito por File → Save to File As. Em 2026-11-16, o MCP `save_place` gravou `place/WrongAddress.rbxl` com retorno `LocalFile`.
- Revisitar no P1: se o código passar de ~15 scripts ou se o diff fizer falta, avaliar Rojo.
- A pasta está dentro do OneDrive; `.git` e `.rbxl` sob sincronização podem conflitar. Mover o projeto é uma opção, não uma urgência.

## Evidências

- Auditoria de 2026-11-11 em `docs/15-PLANO-P0.md` §1 (ferramentas ausentes, sem `.rbxl`, sem git).
- Script de build em uso: `tools/studio/build_graybox.luau` (graybox do P0-02).
- Documentação: https://create.roblox.com/docs/studio/mcp
