# Conteúdo: mapa, cargos, contratos e incidentes

## Cenário base

Uma cidade/estrada montanhosa compacta com atmosfera de neblina. Em P0, **não precisa ser cidade**: depósito/departure point, trecho de estrada em circuito e um destino final reconhecível, com barreiras que reduzam queda de veículo e sumiço de objetos.

### Destinos P1 (propostas)

1. Posto de gasolina: área de descarga ampla.
2. Casa isolada: rua estreita e acesso curto a pé.
3. Loja de conveniência: estacionamento apertado.
4. Depósito secundário: curva e retorno ao mapa.

Destinos diferentes precisam alterar a ação, não só a placa. Reutilizar cenário de forma inteligente.

## Catálogo inicial P1: seis pacotes (hipóteses)

| ID | Nome de trabalho | Regra | Ação do jogador | Complexidade |
|---|---|---|---|---|
| `BOX_STANDARD` | Caixa normal | Não reage | Carregar/entregar | Muito baixa |
| `BOX_HOPPER` | Saltitante | Salta após parada prolongada | Recolocar/estabilizar | Baixa |
| `BOX_RUNNER` | Fugitiva | Pode sair e andar/fugir em direção legível | Perseguir/capturar | Baixa/média |
| `BOX_LIGHTSHY` | Fotossensível | Agita quando iluminada | Administrar farol/luz | Média |
| `BOX_HEAVY` | Peso morto | Reduz aceleração simulada enquanto embarcada | Escolher rota/dirigir | Baixa |
| `BOX_FRAGILE` | Frágil | Perde integridade em colisões acima do limiar | Dirigir com cuidado | Média |

**P0 implementa só:** caixa normal de teste e `BOX_RUNNER` (ou uma única caixa com dois estados).

## Sistema Cargo Personality (P1/P2)

Em vez de scripts individuais por caixa, usar **definições de dados** + conjunto pequeno de comportamentos. Exemplo conceitual:

```lua
return {
    id = "BOX_RUNNER",
    displayName = "Restless Parcel",
    baseReward = 50, -- valor de teste, não preço final
    behaviors = { "EscapeOnStop" },
    maxActiveIncidents = 1,
    weightClass = "Light",
}
```

Regra importante: combinações só quando houver matriz de compatibilidade. Não gerar aleatoriamente dois comportamentos que produzam contrato insolúvel. No P0, zero combinação aleatória.

## Incidentes Event Director (P1)

| Evento | Gatilho | Resultado | Resolução |
|---|---|---|---|
| Estrada bloqueada | Região de rota | Exige desviar/consertar percurso | Desvio curto ou obstáculo removível |
| Falha do farol | Trecho seguro | Baixa visibilidade temporária | Aguarda/aciona luz alternativa |
| Parada forçada | Ponto predeterminado | Pode ativar fuga da caixa | Recuperar e continuar |
| Cliente muda instrução | Próximo ao destino | Encomenda muda de local permitido | Seguir seta para nova área curta |

P0: um único incidente **scriptado** de fuga. Sem diretor procedural.

## Controles de caos

- Antecipação: som ou tremor antes do evento.
- Janela de reação: tempo razoável para intervir.
- Telemetria: registrar incidência e resolução nas fases instrumentadas.
- Recovery: reset específico quando o pacote ficar irrecuperável.
- Cooldown: não disparar eventos em cascata.
- Modo solo: sem desafios que exijam dois pontos simultâneos.

## Curva de partida

Calma inicial → sinal de perigo → incidente → recuperação → chegada → recompensa. A intensidade é controlada por fase de contrato e dificuldades, não por rolagens ininterruptas.

## Ritmo de atualização (pós-P2)

Preferir adicionar um comportamento de carga reutilizável a construir um bairro inteiro toda semana. Conteúdo escalável: novas propriedades de pacotes, variações de destino, desafios curtos, cosméticos e pequenos eventos sazonais.
