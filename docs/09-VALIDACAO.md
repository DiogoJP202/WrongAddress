# Validação de gameplay, telemetria e experimentos

## Hipóteses

| ID | Hipótese | Como testar | Sinal de sucesso preliminar |
|---|---|---|---|
| H1 | A entrega é compreensível | 5 pessoas sem explicação | 4/5 iniciam a ação correta em ~30s |
| H2 | Fuga da carga é divertida | 10–20 testers | maioria entende causa e recupera sem intervenção |
| H3 | Querem repetir | 15–20 testers | pelo menos metade inicia segunda entrega voluntariamente |
| H4 | Solo funciona | 5 sessões solo | nenhum bloqueio que exija amigo |
| H5 | Touch é viável | simulação + dispositivos reais quando possível | entrega completa sem manipulação de teclado |
| H6 | Coop agrega | 2-clientes + testers reais | interação significativa e sem dessincronização crítica |

**Metas são experimentais, não médias oficiais.** Com amostra pequena, registrar número absoluto, comentários e contexto, não afirmar validação estatística.

## Observação de primeira sessão

Registrar: tempo até entender objetivo, tempo até pegar caixa, número de resets, tempo até a primeira entrega, falhas de controle, tentativas de recuperar carga, se iniciou segunda missão, relatos espontâneos e momentos em que pediu ajuda.

## Perguntas úteis (sem induzir resposta)

- O que você achou que precisava fazer no começo?
- Em que momento ficou divertido ou chato?
- Quando a caixa fugiu, você entendeu por quê?
- O que te faria querer fazer outra entrega?
- Se parou, qual foi o motivo?

## Analytics P1/P2 (quando habilitar)

- `session_started`, `contract_started`, `cargo_loaded`, `cargo_escape_started`, `cargo_recovered`, `contract_completed`, `contract_reset`, `session_ended`.
- Medir funil `spawn → pegar → carregar → incidente → completar → repetir`.
- D1/D7/D28 após haver amostra e publicação adequadas.
- Tempo médio de sessão, abandono 0–60s e 61–180s, resultado solo vs duo.
- Fonte: https://create.roblox.com/docs/production/analytics/event-types

Não emitir eventos por frame. Evitar cardinalidade desnecessária de atributos. Verificar limites/nomes atuais no Creator Hub antes de instrumentar.

## Plano de testes técnicos P0

- Entrada solo e primeira missão.
- 2 clientes e interação concorrente com pacote.
- Sair do servidor durante fuga.
- Caixinha cai do mapa/veículo vira/carro prende.
- Apertar interagir/reset repetidamente.
- Concluir, reiniciar e concluir novamente.
- Touch em resolução pequena, HUD e controles.
- FPS/performance básica em configuração mobile.

## Decisão go/no-go

- **GO P1:** fluxo confiável, loop compreensível, feedback positivo suficiente para justificar conteúdo, e correções de bugs sob controle.
- **ITERAR P0:** principal problema é legibilidade, física, câmera ou tempo excessivo de ociosidade.
- **PIVOT:** após iterações curtas, teste mostra que transportar/recuperar a caixa não diverte; testar outra mecânica, não simplesmente produzir mais cenário.
