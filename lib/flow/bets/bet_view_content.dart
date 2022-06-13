import 'package:bolixo/api/bet/bet_model.dart';

class BetViewContent {
  TeamViewContent team1;
  TeamViewContent team2;

  BetViewContent({required this.team1, required this.team2});

  static fromApiModel(BetModel apiModel) {
    return BetViewContent(
        team1: TeamViewContent(
          name: '',
          flagUrl: 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
          goals: apiModel.teamOneGoals.toString()
        ),
        team2: TeamViewContent(
            name: '',
            flagUrl: 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
            goals: apiModel.teamTwoGoals.toString()
        )
    );
  }
}

class TeamViewContent {
  String name;
  String flagUrl;
  String goals;

  TeamViewContent({
    required this.name,
    required this.flagUrl,
    required this.goals
  });
}