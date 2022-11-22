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
    }, onError: (error) {
      if (kDebugMode) {
        print(error);
      }
    });
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

  void getBetsByBolaoAndMatch() {
    api.getUserBets().then((betsInDayList) {
      List<BetsInDayViewContent> betsInDayViewContentList = betsInDayList
          .map((betsInDayApiModel) =>
          BetsInDayViewContent.fromApiModel(betsInDayApiModel))
          .toList()
          .cast<BetsInDayViewContent>();

      view!.update(betsInDayViewContentList);
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
