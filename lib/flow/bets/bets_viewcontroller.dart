import 'package:bolixo/api/bet/bet_api_interface.dart';
import 'package:bolixo/flow/bets/bet_view_content.dart';

import 'bets_view.dart';

class BetsViewController {

  BetApi api = BetApi.getInstance();
  late BetsWidgetState viewState;

  void onInit(state) {
    viewState = state;
    _fillBets();
  }

  void onGoalsTeam1Changed(int index, String goals) {
    viewState.bets[index].team1.goals = goals;
  }

  void onGoalsTeam2Changed(int index, String goals) {
    viewState.bets[index].team2.goals = goals;
  }

  void _fillBets() {
    api.getUserBets()
        .then((bets)
      {
        List<BetViewContent> betsViewContent = bets
            .map((apiModel) => BetViewContent.fromApiModel(apiModel))
            .toList()
            .cast<BetViewContent>();
        viewState.update(betsViewContent);
      }, onError: (error) {
        print(error);
      }
    );
  }

  void saveBets() {
    viewState.bets.forEach((bet) {
      print('goals team 1: ${bet.team1.goals}');
      print('goals team 2: ${bet.team2.goals}');
    });
  }
}