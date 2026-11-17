# ADR-003 — Perfis da garagem

- Data: 2026-11-16
- Status: aceita para o build local do P2

## Contexto

O P1 manteve as moedas durante a partida. O P2 precisa guardar saldo, entregas, reputação, níveis das melhorias e descobertas por jogador. O protótipo continua em arquivo local e os testes no Studio precisam ser isolados dos dados reais.

## Decisão

Usar um DataStore na experiência publicada com uma chave `User_<UserId>` por jogador e um esquema versionado. O mesmo código de transações roda no Studio com armazenamento em memória da sessão.

Abrir o perfil com `UpdateAsync`, reservar a sessão por 150 segundos e exigir o mesmo token para gravar. Fazer checkpoints periódicos, tentar novamente após erros transitórios e descarregar no fim da sessão. Quando há falha de armazenamento, o jogador pode fazer entregas com saldo de sessão e as compras ficam indisponíveis. Um registro escrito por uma versão de esquema mais nova fica preservado.

## Verificação

Os testes locais cobriram migração, concorrência, expiração, liberação repetida, recarga e esquema desconhecido. O serviço real ainda precisa ser verificado com uma experiência de teste publicada. [DataStoreService](https://create.roblox.com/docs/cloud-services/data-stores) · [Boas práticas de DataStore](https://create.roblox.com/docs/cloud-services/data-stores/best-practices)
