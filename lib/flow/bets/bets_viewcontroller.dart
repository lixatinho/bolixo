import 'package:bolixo/api/bet/bet_api_interface.dart';
import 'package:bolixo/api/model/bet_model.dart';
import 'package:bolixo/flow/bets/bet_view_content.dart';

import 'bets_view.dart';

class BetsViewController {

  BetApi api = BetApi.getInstance();
  late BetsWidgetState viewState;

  void onInit(state) async {
    viewState = state;
    await _prepareApi();
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

  Future _prepareApi() async {
    await api.initialize();
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
    List<BetModel> betList = viewState.betsByDay
        .expand((betsByDay) => betsByDay.betList.map((bet) => bet.toApiModel()))
        .toList()
        .cast();
    viewState.updateIsLoading(true);
    api.saveUserBets(betList)
      .then((empty)
        {
          viewState.updateIsLoading(false);
        },
        onError: (error) {
          print(error);
        }
      );
  }
}