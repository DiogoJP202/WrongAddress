# Direção de arte e som — baixo custo, identidade forte

## Estética

- Low-poly estilizado, formas claras, iluminação suave e neblina controlada.
- Inspiração de atmosfera: Easy Delivery Co. (silêncio de estrada, som de motor, elementos simples), sem replicar seus assets, música, UI ou mapa.
- Contraste: estrada tranquila / carga com comportamento absurdo.
- Cores guiadas por legibilidade: mundo dessaturado e sinais de interação com cor reconhecível.

## P0: greybox deliberado

- Van reconhecível, sem rig/arte detalhada.
- Depósito com ponto de partida, trecho de estrada e destino.
- Pacote simples com comportamento visível (olhos/pés opcionais, priorizar lógica).
- Obstáculos e bordas evidentes; boa visibilidade da carga em fuga.
- Lighting bonito o suficiente para transmitir o clima, sem prejudicar performance ou gameplay.

## Identidade de áudio futura

- Rádio com trilhas originais/licenciadas, ambiente da estrada, barulho de motor e ruídos diegéticos do pacote.
- P0: apenas sons utilitários opcionais, prioridade para feedback mecânico (pacote escape/capturado/entregue).
- Evitar usar OST de Easy Delivery Co., Big Walk, PEAK ou músicas de terceiros sem licença.

## Produção e orçamento de arte

- Reutilizar base mesh, texturas simples e alterações de material.
- Limitar quantidade de assets únicos por fase; novos pacotes podem usar o mesmo modelo com comportamentos diferentes.
- Não usar modelos Toolbox sem inspecionar scripts, licenças e dependências.
- Separar protótipo de asset final. Evitar polir um mapa antes da diversão ser comprovada.

## Performance visual

- Testar dispositivo de entrada: geometria barata, iluminação racional, partículas limitadas.
- Não depender de neblina tão densa que o jogador não enxerga o destino ou a caixa.
- Efeitos que comunicam gameplay devem vencer realismo/estética.
