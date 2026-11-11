# Status — WRONG ADDRESS

- Data de referência: 2026-11-11
- Fase: Pré-produção
- P0: Plano aprovado; implementação não iniciada
- Projeto Roblox Studio inspecionado via MCP: **Não** (sem conexão; ver abaixo)
- MVP implementado: Não
- Testes executados: Nenhum
- Publicação: Não

## Ambiente — verificado em 2026-11-11

- Roblox Studio instalado (`RobloxStudioBeta` 0.747); estava fechado durante a auditoria.
- Studio MCP é nativo: `StudioMCP.exe` + launcher `%LOCALAPPDATA%\Roblox\mcp.bat`.
- O MCP estava registrado apenas no Codex CLI (`~/.codex/config.toml`). O Claude Code não tinha nenhuma ferramenta Roblox na sessão de auditoria.
- Catálogo de 38 ferramentas lido do cache local do Studio MCP, não de conexão ativa (lista em `docs/15-PLANO-P0.md` §1).
- Sem Rojo, Aftman, Rokit, Wally, Lune, Selene ou StyLua instalados. `git` e `node` presentes.
- Nenhum arquivo de place (`.rbxl`/`.rbxlx`) existia na pasta do projeto.

## Não verificado

- Place, DataModel, serviços, scripts e objetos no Studio.
- Se "Enable Studio as MCP server" está ligado.
- Comportamento real das ferramentas de play, console, captura, multi-cliente e emulação de dispositivo.
- Se o `.mcp.json` do projeto carrega o servidor `Roblox_Studio` numa sessão nova. **NÃO TESTADO.**

## Decisões registradas

- Conexão: `.mcp.json` na raiz do projeto com a entrada `Roblox_Studio`.
- Place: Baseplate novo, arquivo local em `place/WrongAddress.rbxl`.
- Fonte da verdade: Studio para scripts do jogo; git para docs, ADRs e scripts de build; cópia datada do `.rbxl` em `place/backups/` antes de cada sessão. Sem Rojo.
- Padrões assumidos até segunda ordem: entrega conclui automaticamente ao parar a van na zona; sem salvar o place no Roblox por enquanto.

## Próxima ação

Do responsável:
1. Abrir o Studio, criar um Baseplate e salvar em `place/WrongAddress.rbxl`.
2. Conferir "Enable Studio as MCP server" em Assistant → … → Manage MCP Servers.
3. Abrir nova sessão do Claude Code nesta pasta e aceitar o servidor `Roblox_Studio`.

Depois, do Claude: Parte C da primeira sessão (`docs/15-PLANO-P0.md` §7) — inventário em leitura, backup e spike de veículo (P0-00 + P0-03).

## Histórico de mudanças

- 2026-11-11 — Documentação inicial elaborada. Nenhum componente do jogo foi criado por este pacote.
- 2026-11-11 — Auditoria e plano do P0 aprovados (`docs/15-PLANO-P0.md`). Criados `.mcp.json`, `.gitignore`, `place/README.md`; repositório git iniciado. Nada alterado no Studio.
