# Prompt inicial — Claude Code (cole na conversa)

Estamos começando a pré-produção do jogo Roblox **WRONG ADDRESS**, que vou desenvolver sozinho. O Roblox Studio já tem um MCP configurado para você; NÃO presuma quais ferramentas existem, descubra as capacidades reais da conexão.

**Sua tarefa nesta primeira interação é fazer uma AUDITORIA E PLANO DE IMPLEMENTAÇÃO do P0. Não implemente ainda.**

1. Leia integralmente o `CLAUDE.md`, o `README.md`, o `STATUS.md` e todos os arquivos de `docs/`, começando pelo índice. Trate `docs/04-MVP.md` como fonte de verdade sobre escopo e `docs/11-DECISOES.md` para incertezas e decisões.
2. Resuma o jogo, os pilares, as hipóteses e os limites que não podemos ultrapassar. Quero um plano viável para um dev solo, não um framework enorme.
3. Inspecione o workspace local e a configuração MCP disponível. Liste os nomes e recursos das ferramentas realmente acessíveis. Conecte-se à instância correta do Roblox Studio e **faça apenas leituras** para identificar Place, DataModel, serviços, scripts e objetos existentes. Se não conseguir ler, diga exatamente o que ficou não verificado; não invente estado.
4. Revise criticamente o design do P0: **uma van, uma estrada, uma caixa que tenta fugir, recuperação, entrega e reset**. Aponte inconsistências, riscos de física, network ownership, servidor/cliente, controles touch e salvamento (que NÃO entra no P0). Prefira a solução mais simples que entregue diversão.
5. Proponha uma árvore de instâncias Roblox Studio e organização mínima de ModuleScripts/Script/LocalScripts. Mostre responsabilidades, eventos necessários (somente os imprescindíveis), máquina de estados e como validar interações no servidor.
6. Faça um plano técnico sequencial a partir do backlog P0-00 a P0-10. Para cada passo: objetivo, instâncias/arquivos que criaria, dependências, critério de aceite, teste de Studio viável via MCP, riscos e fallback. Inclua um spike de veículo antes de construir todo o loop.
7. Prepare um checklist concreto para testes solo, 2 clientes e mobile. Separe testes que você consegue automatizar pelo MCP dos que exigem minha intervenção manual.
8. Identifique até cinco dúvidas realmente bloqueantes e, para cada uma, recomende a alternativa padrão mais barata e reversível. Não pergunte detalhes cosméticos que não bloqueiam P0.
9. Entregue uma proposta de **primeira sessão de implementação**, pequena e verificável, com a ordem exata das ações. **Pare antes de alterar qualquer script, objeto, arquivo de projeto, configuração, publicação ou instalação.** Espere minha autorização explícita antes de escrever.

Formato da resposta: diagnóstico do ambiente verificado / decisões e riscos / arquitetura mínima / plano por etapas / testes / perguntas bloqueantes / primeira sessão sugerida. Seja específico, crítico e objetivo. Não marque nada como implementado ou testado sem executar e apresentar evidência real.
