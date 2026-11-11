# Roadmap de produto e escopo fechado

> **Documento de autoridade de escopo.** Se outra página pedir uma feature adicional, não implementá-la antes de seu gate.

## P0 — Prova de diversão (primeiro marco)

Objetivo: uma única entrega com incidentes engraçados e recuperáveis, jogável no Studio por 1 jogador, depois 2.

### Dentro

- 1 lugar de jogo, 1 mapa graybox compacto (depósito, estrada, destino).
- 1 veículo arcade controlável (pode usar solução mínima confiável testada).
- 1 pacote que pode ser carregado, transportado, escapar e ser recuperado.
- 1 sequência de entrega hardcoded/parametrizada no servidor; resultado e reinício.
- 1 HUD mínima: destino, ação contextual, estado da carga e conclusão.
- Mouse/teclado e touch funcionais nas ações essenciais.
- Testes de solo, 2 clientes, fuga, reset, desconexão e performance básica.

### Fora, explicitamente

- DataStore, garagem, upgrades, moeda, catálogo, loja, passes, monetização, anúncios.
- Múltiplos mapas, 4 destinos, 6 pacotes, 4 incidentes (isso é P1).
- Randomização procedural, Event Director genérico, roteiros de NPC, IA de perseguição, cutscenes.
- Replays, saves, matchmaking customizado, voice chat, chat próprio.

### Critérios para aprovar P0

- Fluxo completo sem comandos de debug.
- Pacote não some permanentemente nem bloqueia o contrato.
- Jogador consegue concluir solo em PC e touch simulado.
- Pelo menos um teste 2-cliente termina sem dessincronização impeditiva.
- Repetir o contrato funciona sem reentrância, objetos duplicados ou recompensa em dobro.
- Evidências objetivas (capturas, logs/testes, passos reproduzíveis).
- Feedback de usuários externos: ver `09-VALIDACAO.md`. Não tratar números como garantias.

## P1 — Loop repetível

Após P0 aprovado: 4 destinos, 6 tipos de carga, 4 comportamentos, até 4 incidentes, contratos selecionáveis, pagamento de sessão, reset estável, entrada/saída de até 4 jogadores. Sem salvar dinheiro entre sessões até estabilizar a economia. Balancear partidas de 5–10 minutos, não prometer duração fixa.

Gate: pelo menos 50% dos testers inicia voluntariamente uma segunda entrega **em teste pequeno**, mais observação de bugs e frustração.

## P2 — Progressão persistente

Após P1 aprovado: garagem simples, moedas persistentes, 2–4 upgrades permanentes de baixo risco, catálogo de anomalias, reputação básica. Salvar com cuidados do DataStore, migração de schema, fallback e testes de falhas.

Gate: retorno espontâneo de parte dos testers e clareza sobre razões de voltar; instrumentar D1/D7 quando público permitir.

## P3 — Distribuição/monetização

Após P2 aprovado: analytics consistente, ambiente de publicação controlada, 2–3 cosméticos, preços regionais onde aplicáveis, análise de aquisição e testes de retenção. Monetização não pode comprometer o loop gratuito; nenhuma loot box paga planejada.

Gate: avaliação de retenção, conversão, custo de manutenção e demanda antes de expansão.

## Política de escopo

Uma feature entra apenas se responder à hipótese do gate atual. Em caso de dúvida, criar um **spike de 1 sessão** que produza evidência técnica, não um subsistema completo.
