# ADR-002 — Veículo do P0: corpo arcade único (candidato B)

- Data: 2026-11-13
- Status: aceita
- Relacionado ao gate: P0 (tarefa P0-03, spike de veículo)

## Contexto

O veículo é o maior risco técnico do P0 (`docs/11-DECISOES.md`). `docs/05-ARQUITETURA.md` exige escolher a solução de menor custo que funcione com teclado e touch, replique bem em multiplayer, não atravesse obstáculos, seja recuperável se ficar presa e não dependa de assets pagos ou modelos inseguros. O projeto prioriza confiabilidade mobile e clareza sobre realismo de física (D-005).

## Alternativas

1. **A — rodas com `HingeConstraint`** (chassi nativo, sem molas). Vantagem: comportamento físico "de carro", emergente. Desvantagem: pode capotar, tremer em velocidade e prender; mais peças móveis e mais ajuste. Não foi construído, porque B passou em todos os critérios.
2. **B — corpo arcade único.** Um só conjunto soldado, apoiado em 4 esferas sem atrito, movido por `LinearVelocity` (tração e aderência lateral com limites por eixo) e `AngularVelocity` (curva e manter-se em pé). Vantagem: não capota por construção, poucos parâmetros, 1 conjunto físico. Desvantagem: não inclina em rampas nem tem suspensão; a "física" é pouca.
3. **C — chassi pronto do Creator Store.** Descartado por análise: script longo de terceiros, exige inspeção e autorização para inserir asset.
4. **D — modo Server Authority.** Descartado por análise: exige `BindToSimulation`, Input Action System, streaming e simulação fixa; reescrita desproporcional para um coop sem recompensa.

## Decisão

Adotar **B**. O input vem do `VehicleSeat` (`ThrottleFloat`/`SteerFloat`) e o controle roda no **cliente do motorista**, que recebe o dono de rede da van enquanto está sentado; ao sair, o dono volta ao servidor e a van freia sozinha. Nenhum RemoteEvent é usado para dirigir.

Parâmetros de partida (Attributes do modelo): `MaxForward=45`, `MaxReverse=18`, `Accel=26`, `Coast=14`, `Brake=55`, `TurnRate=1.6`, `TurnRefSpeed=12`.

## Consequências

- A posição da van é verdade do cliente motorista. Aceito no P0 (não há recompensa); a conclusão da entrega será decidida por estado no servidor. Rever no P1.
- O mapa do P0 deve ser plano: o corpo não acompanha rampas. Lombadas baixas (0,5 stud) funcionam.
- Dimensões para o graybox: van de 8 × 16 studs; raio de curva de ~28 studs na velocidade máxima; pista de 60 studs de largura sobrou com folga.
- A diagonal do controle padrão vem normalizada (0,707 em cada eixo); o script remapeia para o quadrado.
- Sentado, a câmera padrão fica atrás do baú e esconde a pista. Corrigir no template final (câmera ou altura do baú).
- Falta o botão de recuperar a van (previsto no P0-06) para fechar o critério 4.
- O script de controle tem um gancho de teste (`WA_TestThrottle`/`WA_TestSteer`, só no Studio). Manter restrito ao Studio ou remover no template final.

## Evidências

Play no Studio 0.747, place local `place/WrongAddress.rbxl`, instâncias `Workspace.WA_Spike`, scripts `WA_SpikeOwnership`, `WA_SpikeDriver`, `WA_SpikeMpTest`, `WA_SpikeMpTestClient`.

### Automação via MCP (2026-11-13)

| Medida | Resultado |
|---|---|
| Aceleração | 0 → 45 studs/s em ~1,8 s |
| Velocidade máxima | 45 à frente, 18 em ré |
| Desaceleração solta / freando | ~14 / ~50 studs/s² |
| Curva | 1,6 rad/s; raio ~28 studs a 45 studs/s |
| Lombada de 0,5 stud a ~42 studs/s | salto de 0,4 stud, sem perder o controle |
| Mureta a 45 studs/s | para rente, sem atravessar |
| Inclinação | vetor "para cima" ≥ 0,998 em todos os testes |
| Peças não ancoradas | 13, em 1 conjunto |
| Touch emulado (Galaxy A06) | thumbstick acelera, dá ré e faz curva |
| Console | sem erros |

### Teste automático de 2 clientes (`StudioTestService`, 2 rodadas)

Um cliente dirige 3,5 s e solta; o outro mede a van no próprio cliente, primeiro a pé e depois como passageiro.

| Verificação | Rede normal | 4G simulado (45–55 ms, jitter 20–30 ms, perda 0,4–0,5%) |
|---|---|---|
| Distância percorrida: motorista / observador / servidor | 191,5 / 191,5 / 191,4 | 188,5 / 188,5 / 188,4 |
| Dono de rede com passageiro a bordo | motorista | motorista |
| Passageiro preso ao banco (variação da distância à van) | 0 | 0 |
| Frames em que a van "voltou para trás" | 0 | 0 |
| Frames parados com a van em movimento | 0 | 1 |
| Maior deslocamento em um frame no observador (nominal 0,75 a 60 FPS) | não comparável (cliente a ~15 FPS) | 1,1 a pé; 2,0 como passageiro |

Limite do teste: mede sincronização, não a suavidade percebida. Em cada rodada um dos clientes rodou a ~15 FPS por estar em janela de fundo. Com 4G simulado o passageiro vê pequenos saltos de recuperação; se isso incomoda só um olho humano diz.

### Testes manuais do responsável (2026-11-13)

- Direção no PC com teclado: **boa, manter**.
- Emulador de celular, thumbstick: **funcionou bem**.
- Emulador de celular, sair pelo botão de pulo: **saiu normalmente**.
- Dois clientes manual: **NÃO EXECUTADO**.

### Critérios de `docs/05-ARQUITETURA.md`

| # | Critério | Resultado |
|---|---|---|
| 1 | Teclado e touch | PASSOU (automação + teste manual) |
| 2 | Replica bem em multiplayer | PASSOU na sincronização (automação); suavidade percebida NÃO VERIFICADA por humano |
| 3 | Não atravessa obstáculos | PASSOU |
| 4 | Recuperável se preso | PARCIAL: não capota; botão de recuperar fica para o P0-06 |
| 5 | Sem assets pagos ou modelos inseguros | PASSOU |

Documentação consultada: https://create.roblox.com/docs/reference/engine/classes/LinearVelocity · https://create.roblox.com/docs/reference/engine/classes/VehicleSeat · https://create.roblox.com/docs/reference/engine/classes/StudioTestService · https://create.roblox.com/docs/physics/network-ownership
