# Bolixo

Aplicativo web/mobile para jogos de bolões com partidas variáveis e sistema de pontuação dinâmico.

## Preparação de ambiente

1. Baixar o Android Studio (https://developer.android.com/studio)
2. Baixar o Flutter SDK (https://docs.flutter.dev/get-started/install)
3. Adicionar o Flutter às variáveis de ambiente do Windows.
  - Na barra de iniciar do Windows, digitar env e selecionar "Edit environment variables for your account"
  - Em "User Variables" checar se existe um campo "Path"
    - Caso positivo, adicionar **flutter\bin** no final, usando ; como separador.
    - Caso negativo, criar a variável chamada **Path** e adicionar o nome **flutter\bin**.
4. Rodar o comando **flutter doctor** no cmd.
5. Clonar este repositório em alguma pasta qualquer.
6. Abrir o projeto clonado no Android Studio.

## Estrutura de Menus e Telas

O projeto divide as funcionalidades principais em fluxos de palpites, gerenciamento de bolões e administração de competições.

### 1. Palpites (Novo)
Menu para visualizar e selecionar competições ativas e seus respectivos jogos de forma isolada. Este é o fluxo principal de apostas.
- **View (Listagem)**: `lib/flow/bets/competitions_bets_view.dart` (`CompetitionsBetsView`)
- **View (Detalhe)**: `lib/flow/bets/competitions_bets_view.dart` (`CompetitionBetsDetailView`)
- **API Client**: `lib/api/bolao/bolao_client.dart` (método `getActiveCompetitions`)

### 2. Palpites por Bolão (old)
Tela legada para participantes de um bolão específico selecionado. Mantida para referência futura.
- **View**: `lib/flow/bets/bets_view.dart` (`BetsWidget`)
- **Controller**: `lib/flow/bets/bets_viewcontroller.dart`
- **Componentes**: `lib/flow/bets/bet_item_view.dart` (Card de aposta individual)
- **API Client**: `lib/api/bolao/bolao_client.dart` (para dados do bolão) e `lib/api/bet/bet_client.dart` (para salvar palpites)

### 3. Ranking (old)
Visualização da classificação dos participantes no bolão selecionado (fluxo legado).
- **View**: `lib/flow/ranking/ranking_view.dart` (`RankingWidget`)
- **Controller**: `lib/flow/ranking/ranking_viewcontroller.dart`
- **API Client**: `lib/api/bolao/bolao_client.dart` (método `getBoloes`)

### 4. Bolões
Gerenciamento de bolões (criação e listagem).
- **View (Listagem)**: `lib/flow/boloes/boloes_view.dart`
- **View (Criação)**: `lib/flow/boloes/create_bolao_view.dart`
- **API Client**: `lib/api/bolao/bolao_client.dart` (métodos `getBoloes` e `createBolao`)

### 5. Competições (Admin)
Área restrita para administradores gerenciarem a estrutura dos campeonatos.
- **View (Gestão)**: `lib/flow/competition/manage_competitions_view.dart`
- **View (Partidas)**: `lib/flow/competition/edit_matches_view.dart`
- **API Client**: `lib/api/competition/competition_client.dart`

## Repositório do backend
Link: [Lixolao](https://github.com/lixatinho/lixolao)

## Tecnologias Utilizadas
- **Flutter**: Framework UI
- **Dio**: Cliente HTTP para consumo de APIs
- **Shared Preferences**: Persistência de dados local (Cache e Auth)
- **Google Fonts**: Tipografia personalizada
