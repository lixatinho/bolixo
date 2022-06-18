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
    viewState.bets[index].homeTeam.scoreBet = goals;
  }

  void onGoalsTeam2Changed(int index, String goals) {
    viewState.bets[index].awayTeam.scoreBet = goals;
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
    for (var bet in viewState.bets) {
      print('goals team 1: ${bet.homeTeam.scoreBet}');
      print('goals team 2: ${bet.awayTeam.scoreBet}');
    }
  }
}