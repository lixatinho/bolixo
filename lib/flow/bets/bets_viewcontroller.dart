import 'package:bolixo/api/bet/bet_api_interface.dart';
import 'package:bolixo/api/model/bet_model.dart';
import 'package:bolixo/flow/bets/bet_view_content.dart';
import 'package:flutter/foundation.dart';

import 'bets_view.dart';

class BetsViewController {
  BetApi api = BetApi.getInstance();
  late BetsWidgetState? view;

  void onInit(state) async {
    view = state;
    await _prepareApi();
    _fillBets();
  }

  void onDateChanged(int index) {
    view!.updateDate(index);
  }

  void onGoalsTeam1Changed(int index, String goals) {
    view!.betsByDay[view!.dateIndex].betList[index].homeTeam.scoreBet = goals;
  }

  void onGoalsTeam2Changed(int index, String goals) {
    view!.betsByDay[view!.dateIndex].betList[index].awayTeam.scoreBet = goals;
  }

  Future _prepareApi() async {
    await api.initialize();
  }

  void _fillBets() {
    api.getUserBets().then((betsInDayList) {
      List<BetsInDayViewContent> betsInDayViewContentList = betsInDayList
          .map((betsInDayApiModel) =>
              BetsInDayViewContent.fromApiModel(betsInDayApiModel))
          .toList()
          .cast<BetsInDayViewContent>();
      view!.update(betsInDayViewContentList);

      _selectClosestDate(betsInDayViewContentList);
    }, onError: (error) {
      if (kDebugMode) {
        print(error);
      }
    });
  }

  void _selectClosestDate(List<BetsInDayViewContent> betsInDayViewContentList) {
    if (betsInDayViewContentList.isEmpty) return;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    int selectedIndex = 0;
    bool found = false;

    for (int i = 0; i < betsInDayViewContentList.length; i++) {
      final betDate = betsInDayViewContentList[i].date;
      final betDay = DateTime(betDate.year, betDate.month, betDate.day);

      if (!betDay.isBefore(today)) {
        selectedIndex = i;
        found = true;
        break;
      }
    }

    if (!found) {
      selectedIndex = betsInDayViewContentList.length - 1;
    }

    view!.updateDate(selectedIndex);
  }

  void saveBets() {
    List<BetModel> betList = view!.betsByDay
        .expand((betsByDay) => betsByDay.betList.map((bet) => bet.toApiModel()))
        .toList()
        .cast();
    view!.updateIsLoading(true);
    api.saveUserBets(betList).then((empty) {
      view!.showMessage("Aposta salva com sucesso.");
      view!.updateIsLoading(false);
    }, onError: (error) {
      view!.showMessage("Erro ao salvar aposta");
      if (kDebugMode) {
        print(error);
      }
    });
  }

  void getBetsByBolaoAndMatch(int? matchId) {
    api.getBetsByBolaoAndMatch(matchId).then((betsByBolaoAndMatch) {
      List<BetsByBolaoAndMatchViewContent> betsViewContentList = betsByBolaoAndMatch
          .map((betsByBolaoAndMatchApiModel) =>
          BetsByBolaoAndMatchViewContent.fromApiModel(betsByBolaoAndMatchApiModel))
          .toList()
          .cast<BetsByBolaoAndMatchViewContent>();

      view!.updateViewBets(betsViewContentList);
      view!.showBetsByMatch();
    }, onError: (error) {
      if (kDebugMode) {
        print(error);
      }
    });
  }

  void onDispose() {
    view = null;
  }
}
