# Dados, progressão e monetização

## Fronteira por fase

- P0: tudo em memória da sessão, nenhuma moeda nem DataStore.
- P1: moeda de teste apenas no servidor durante a sessão; não converter em Robux.
- P2: profile persistente, garagem, upgrades, reputação e catálogo.
- P3: produtos cosméticos pagos **após validação de retenção**.

## Modelos conceituais

```lua
-- P2: apenas schema de planejamento, NÃO implementar no P0
export type PlayerProfile = {
    schemaVersion: number,
    coins: number,
    reputation: number,
    ownedVehicleSkins: {string},
    equippedVehicleSkin: string?,
    upgrades: {[string]: number},
    discoveredCargo: {[string]: boolean},
    completedDeliveries: number,
}

export type MissionSnapshot = {
    missionId: string,
    phase: string,
    destinationId: string,
    cargoId: string,
    cargoState: string,
    completed: boolean,
}
```

## Economia proposta P2

- **Fonte de moeda:** entrega concluída; bônus pequenos por condição de carga ou risco.
- **Sumidouro:** upgrades com limites, itens de personalização grátis e possíveis reparos moderados (avaliar frustração).
- **Nada de penalidade punitiva no começo:** falhar não pode fazer alguém perder meia hora.
- **Sem exploração por reset:** cada `missionId` remunera no máximo uma vez.
- **Sem números rígidos:** recompensas e custos só depois de medir tempo por entrega, retenção e inflação.

### Progressão inicial proposta (não especificação P0)

1. Capacidade de prender cargas com menos tempo.
2. Iluminação de veículo com variações de alcance (cuidado para não anular a regra de carga fotossensível).
3. Melhorias de aceleração controladas.
4. Ferramenta simples de recuperação.

Toda vantagem permanente deve preservar desafios. Evitar builds que tornam cargas irrelevantes.

## Persistência segura P2

- Um store de perfis com chave `User_{UserId}` quando possível.
- Alterar estado em memória; salvar em checkpoints e saída, não por cada moeda recebida.
- Preferir `UpdateAsync` quando há risco de escrita concorrente; `pcall`, retry com backoff, cuidado com resultados de escrita incertos.
- Definir política de sessão e conflito (session locking ou módulo validado) **antes** de habilitar saves reais.
- `BindToClose` e `PlayerRemoving` com proteção contra double-save e tempo limite.
- `schemaVersion` e migração testável. Nunca sobrescrever dados reais ao migrar sem backup.
- Sem dados pessoais além de identificadores necessários para o perfil.

Fonte oficial: https://create.roblox.com/docs/cloud-services/data-stores/best-practices

## Monetização P3 — hipótese inicial

| Produto | Faixa para teste | Tipo esperado |
|---|---:|---|
| Pinturas/adesivos de van | 29–79 Robux | Cosmético |
| Uniformes/bonés | 49–149 Robux | Cosmético |
| Buzinas/animações | 39–99 Robux | Cosmético |
| Tema de garagem | 149–299 Robux | Cosmético |

Preços **hipotéticos**, sem validação de mercado. Modelar custos de criação, conversão e retenção antes de precificar. Não implementar passes nem Developer Products no P0–P2; nunca criar IDs de produto fictícios em scripts como se fossem reais.

### Guardrails de monetização

- Compras não podem ser necessárias para concluir contratos.
- Sem loot box com Robux no plano inicial; se algum dia forem consideradas, revisar regras por região, divulgação de chances e restrições Roblox.
- Não manipular menores com temporizadores coercitivos ou pressão de compra.
- Não prometer renda: faturamento depende de aquisição, retenção, conversão e custos.

Fontes: https://create.roblox.com/docs/production/monetization/passes ; https://create.roblox.com/docs/production/monetization/paid-random-items
