# Fluxo de trabalho com Claude Code + MCP Roblox Studio

## Primeira sessão: leitura e auditoria, sem mudanças

1. Confirmar raiz do repositório/projeto onde o Claude está trabalhando.
2. Ler `CLAUDE.md` e demais documentos, mapear requisitos e inconsistências.
3. Consultar ferramentas MCP disponíveis (nomes reais, argumentos suportados).
4. Listar instâncias do Studio, identificar a correta, consultar árvore e scripts **sem editar**.
5. Detectar se Studio está vazio ou tem código que não deve ser sobrescrito.
6. Verificar ferramentas de testes: Play, multi-client, console/output, screenshot, execução Luau, dispositivos.
7. Checar se há fluxo de fonte da verdade via Rojo ou se o MCP edita diretamente o DataModel.
8. Entregar arquitetura de P0 e plano detalhado; registrar limitações e pendências.

No primeiro prompt, não usar ferramentas que escrevam scripts/instâncias nem criar backups sem necessidade de mudança. Se o MCP expõe uma ferramenta que mistura leitura e escrita, verificar sem executá-la quando houver risco de mutação.

## Em implementação autorizada

- Selecionar a instância correta por ID.
- Preparar backup/versionamento do lugar antes de mudanças amplas.
- Executar uma pequena tarefa de backlog por vez; verificar mudanças na árvore.
- Rodar testes e inspecionar logs reais após alterações.
- Documentar o que funciona, o que não pode ser testado e como reproduzir.
- Guardar registro de mudança em `STATUS.md`, depois de autorização para escrever.

## Evidência mínima de mudança

| Campo | Exemplo |
|---|---|
| Tarefa | `P0-04` |
| Instância Studio | ID/nome obtido via MCP |
| Criado/alterado | caminhos completos dos scripts/objetos |
| Teste | Play solo + 2 clients |
| Resultado | Passou/falhou/não testado |
| Impedimentos | ausência de tool, erro de API, bug de física |

## Referência de capacidades Studio MCP oficial

O MCP oficial pode, conforme versão e configuração, ler e editar scripts, explorar o DataModel, executar comandos Luau e realizar testes Play. A documentação lista métodos como `list_roblox_studios`, `script_read` e `multi_edit`; **não assumir que a instalação do usuário expõe todos eles**. Ver https://create.roblox.com/docs/studio/mcp.

## Proibições operacionais

- Não publicar, lançar monetização, alterar permissions ou apagar lugar sem autorização.
- Não instalar dependências sem explicar por que.
- Não confiar em `print` ou resposta de tool como prova de teste visual se a tool não executou o jogo.
- Não declarar scripts em arquivos locais como sincronizados com Studio sem conferência.
