import 'package:bolixo/api/bet/bet_api.dart';
import 'package:bolixo/flow/bets/bet_view_content.dart';

import 'bets_view.dart';

class BetViewController {

  BetApi api = BetApi.getInstance();
  late BetsWidgetState viewState;

  void onInit(state) {
    viewState = state;
    fillBets();
  }

  void fillBets() {
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
}