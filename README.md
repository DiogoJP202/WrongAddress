# WRONG ADDRESS — Documentação de pré-produção

> Jogo original para Roblox. Documentação de trabalho, não produto pronto.  
> O protótipo local inclui contratos, garagem, pinturas cosméticas e métricas de sessão. Estado e testes atuais em [STATUS.md](STATUS.md).
>
> Responsável pelo produto: desenvolvedor solo. Ferramenta de execução: Roblox Studio + Claude Code com MCP já configurado.

## A ideia em uma frase

Um jogo de entregas em uma região estranha: o jogador transporta encomendas com comportamentos imprevisíveis, lida com problemas na estrada, recebe pagamento e melhora sua operação.

**Prioridade:** primeiro comprovar que levar uma caixa problemática do ponto A ao B é divertido. Depois construir progressão e, só após validação, monetização.

## Como usar esta pasta

1. Comece por `CLAUDE.md` e `docs/00-INDICE.md`.
2. Leia `docs/01-VISAO.md`, `docs/02-GDD.md`, `docs/03-CONTEUDO.md`, `docs/04-MVP.md`.
3. Consulte os documentos técnicos e de validação antes de desenvolver.
4. Copie `prompts/01-PLANEJAMENTO-INICIAL.md` para a primeira conversa com Claude Code **aberto na raiz deste projeto**.
5. Não considere o escopo proposto como implementação validada. Ajuste após testes e registre alterações no histórico de decisões.

## A única missão do P0

**Uma van. Uma estrada. Uma caixa que tenta fugir.**

Precisamos verificar: (a) o jogador entende o que fazer, (b) o transporte cria uma situação interessante, (c) ele quer tentar outra entrega. Todo o resto é secundário.

## Estrutura

- `CLAUDE.md`: instruções persistentes para o agente.
- `docs/`: visão, GDD, arquitetura, MVP, dados, interface, arte, métricas, riscos e backlog.
- `prompts/`: prompt de arranque e fluxo de planejamento.
- `templates/`: template de decisão arquitetural.
- `STATUS.md`: status vivo; o Claude deve atualizá-lo **somente após autorização** para começar mudanças.

## O que está decidido

- Roblox Studio + Luau; experiência acessível para solo e cooperação opcional de até 4 pessoas.
- Controles mobile são requisito de produto, não extra opcional.
- Direção arcade, física simplificada e regras de carga previsíveis para o código.
- Economia e personalização **não** entram no P0; progressão local no P1/P2, monetização apenas no P3.
- Design/arte de baixo custo, sem modelos/áudio de terceiros sem licença de uso.

## O que **não** foi decidido

- Quais ferramentas o MCP expõe no ambiente real.
- Se há projeto Roblox já aberto/criado ou repositório com código.
- Sincronização via Rojo, Wally, Aftman etc. Só adotar se existirem e forem úteis.
- Controles e sistema de física do veículo (avaliar na prova técnica).
- Preços de Robux, identidades finais dos pacotes e data de lançamento.

**Em caso de conflito documental:** `docs/04-MVP.md` estabelece o escopo; `docs/05-ARQUITETURA.md` estabelece os princípios técnicos; `docs/11-DECISOES.md` registra divergências, pendências e alterações autorizadas.
