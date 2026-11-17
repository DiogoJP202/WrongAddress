# Preparação de lançamento

O build local está em `place/WrongAddress.rbxl`. A aba Pinturas oferece Original, Faixa Laranja, Azul Noturno e Verde Serra. As três pinturas novas custam 70, 95 e 120 moedas ganhas em entregas. A cor equipada altera apenas o visual da van do próximo contrato escolhido pelo jogador. O preço aparece antes da compra.

## Métricas

| Área | Eventos e leitura |
|---|---|
| Primeira entrega | `First Delivery` mede entrada, escolha do contrato, pegar a caixa, carregar a van, concluir e começar outra entrega com o grupo. |
| Repetição | `RepeatSelection` identifica quem confirmou a primeira repetição. A última etapa do funil também inclui quem estava no grupo quando a segunda entrega começou. |
| Sessão | `VisitSeconds` agrupa o tempo de sessão pela última etapa alcançada. A inspeção local separa saídas antes de concluir em até 60 s, entre 61 e 180 s e após 180 s. |
| Contrato | `DeliverySeconds` mede o tempo desde o primeiro carregamento até a conclusão. As dimensões são o contrato e o modo solo ou coop. |
| Economia | `Coins` registra ganhos por entrega e gastos confirmados na garagem ou em pinturas. |

O Studio expõe os totais locais em `ServerStorage.WrongAddress.SessionMetrics`. Um jogador que entra durante a viagem começa o funil quando a próxima missão é escolhida. A integração usa `Config.Analytics.SendToRoblox`, desligada no build local. [Eventos e painéis do Roblox](https://create.roblox.com/docs/production/analytics/event-types) · [Eventos de funil](https://create.roblox.com/docs/production/analytics/funnel-events)

## Miniaturas

| Prévia | Conteúdo |
|---|---|
| [Fuga](launch/thumbnail-fuga.jpg) | Uma caixa laranja está na arena à esquerda da van, junto à lombada. |
| [Entrega](launch/thumbnail-entrega.jpg) | A van carrega uma caixa amarela e está parada na vaga verde diante da casa. |

As duas prévias de 1920 × 1079 usam o mapa e os modelos do jogo, com enquadramento e título preparados no Studio. O tamanho ideal para o upload é 1920 × 1080. O teste futuro compara a cena do incidente com a cena da entrega. Jogue o mesmo build para as duas variantes e acompanhe impressões, entradas e primeira entrega concluída. [Miniaturas no Creator Hub](https://create.roblox.com/docs/production/publishing/thumbnails)

## Verificações antes do lançamento

1. Em uma experiência de teste publicada, confirmar que o perfil recarrega após sair e entrar em outro servidor. Repetir com saldo, compra, pintura equipada e perfil do esquema 1.
2. Após ativar a integração no ambiente de teste, conferir eventos e contagens no Creator Hub. Medir a primeira partida e a repetição voluntária com jogadores externos. [Roteiro do playtest](09-VALIDACAO.md)
3. Completar a revisão de conteúdo da versão destinada ao público. A interface atual está em pt-BR. Verificar texto, touch e desempenho em aparelho físico e avaliar controles por gamepad. [Classificação de conteúdo](https://create.roblox.com/docs/production/promotion/content-ratings) · [Localização](https://create.roblox.com/docs/production/localization) · [Acessibilidade](https://create.roblox.com/docs/production/publishing/accessibility)
4. Após os critérios de retenção, avaliar se o projeto vai oferecer cosméticos em Robux. A etapa depende de uma experiência publicada e de IDs reais criados no Creator Hub. [Passes no Roblox](https://create.roblox.com/docs/production/monetization/passes)

## Rodada fechada de teste

A cópia local `place/backups/WrongAddress-Playtest_20261117-021422.rbxl` tem `Config.Analytics.SendToRoblox=true` e aguarda publicação como uma experiência própria. O DataStore pertence à experiência, então usar um universo separado mantém o progresso de teste isolado. [Data stores](https://create.roblox.com/docs/cloud-services/data-stores) · [Acesso de playtest](https://create.roblox.com/docs/production/publishing/publish-games-and-places#target-audience)

### 1. Perfil entre servidores

- No Roblox Player, começar uma sessão solo e registrar a versão publicada e a hora de entrada. Concluir uma entrega e escolher outra voluntariamente para cobrir também o evento de repetição.
- Acumular pelo menos 150 moedas, comprar Faixa Laranja (70) e Freios nível 1 (80). Equipar Original e voltar para Faixa Laranja. Registrar saldo, reputação, descobertas, nível de Freios e pintura equipada antes de sair pelo menu do Roblox.
- Entrar em outra instância de servidor com a mesma conta. Comparar os valores com o registro anterior. Escolher um contrato e conferir a pintura na van. Se o servidor for o mesmo ou se o perfil operar em modo de sessão, considerar o teste inconclusivo.
- No Studio, a transação com armazenamento simulado passou na migração do esquema 1, na reabertura com progresso e pintura preservados e na rejeição de gravação por uma sessão expirada. A confirmação com `DataStoreService` continua pendente.

### 2. Recebimento dos eventos

No Creator Hub da experiência de teste, abrir **View Events** em Funnels, Custom e Economy. Usar a hora e a conta da rodada técnica para identificar a sequência. Os gráficos agregados geralmente aparecem em cerca de 24 horas. [Validação de eventos](https://create.roblox.com/docs/production/analytics/event-types#validate-your-event-tracking)

| Painel | Resultado esperado na rodada técnica |
|---|---|
| Funnels | `First Delivery` avança da entrada até a escolha da segunda entrega em seis passos. |
| Custom | `RepeatSelection` aparece uma vez para quem escolheu a segunda entrega, `DeliverySeconds` aparece a cada entrega concluída e `VisitSeconds` aparece ao sair. |
| Economy | `Coins` registra cada pagamento e uma saída por compra de pintura ou melhoria. Equipar uma pintura já possuída preserva o saldo e não gera outra saída. |

O teste isolado no Studio registrou seis etapas para dois participantes, uma única ação de repetição, um pagamento e uma compra de cada tipo. A validação do recebimento pelo Creator Hub continua pendente.

### 3. Primeira sessão com cinco pessoas

Usar cinco contas que ainda não conhecem o jogo, com pelo menos uma sessão em celular físico. Abrir com a mesma frase para todos, “Entre e jogue como faria normalmente.” Cronometrar a partir do momento em que o jogador ganha controle. Registrar o momento de qualquer ajuda e encerrar a observação quando a pessoa começar outra entrega ou decidir parar. [Perguntas abertas e hipóteses](09-VALIDACAO.md)

| Pessoa | Aparelho | Primeira ação e tempo | Entendeu a fuga e recuperou a caixa | Concluiu a entrega | Iniciou outra por conta própria | Travou ou pediu ajuda onde? |
|---|---|---|---|---|---|---|
| T01 | | | | | | |
| T02 | | | | | | |
| T03 | | | | | | |
| T04 | | | | | | |
| T05 | | | | | | |

### 4. Ajustes e miniaturas

Registrar quantos começaram a ação correta em cerca de 30 segundos, quantos recuperaram a caixa e quantos quiseram repetir. Priorizar o primeiro ponto de bloqueio observado e rever a mesma etapa com novos jogadores após a correção.

As duas miniaturas foram revisadas localmente. O título tem leitura clara nas duas, e as imagens distinguem a caixa fora da van da caixa já carregada. Esta rodada pode comparar a expectativa gerada por cada imagem, mostrando apenas uma a cada participante depois da sessão e pedindo que descreva o que ela comunica. O desempenho em aquisição depende de impressões reais. Quando houver distribuição na Home, comparar impressões e taxa de partidas qualificadas por miniatura. [Personalização de miniaturas](https://create.roblox.com/docs/production/publishing/thumbnails#home-page-personalization)
