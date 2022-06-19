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

  void onDateChanged(int index) {
    viewState.updateDate(index);
  }

  void onGoalsTeam1Changed(int index, String goals) {
    viewState.betsByDay[viewState.dateIndex].betList[index].homeTeam.scoreBet = goals;
  }

  void onGoalsTeam2Changed(int index, String goals) {
    viewState.betsByDay[viewState.dateIndex].betList[index].awayTeam.scoreBet = goals;
  }

  void _fillBets() {
    api.getUserBets()
        .then((betsInDayList)
      {
        List<BetsInDayViewContent> betsInDayViewContentList = betsInDayList
            .map((betsInDayApiModel) => BetsInDayViewContent.fromApiModel(betsInDayApiModel))
            .toList()
            .cast<BetsInDayViewContent>();
        viewState.update(betsInDayViewContentList);
      }, onError: (error) {
        print(error);
      }
    );
  }

  void saveBets() {
    for (var bet in viewState.betsByDay[viewState.dateIndex].betList) {
      print('goals team 1: ${bet.homeTeam.scoreBet}');
      print('goals team 2: ${bet.awayTeam.scoreBet}');
    }
  }
}