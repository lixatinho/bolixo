import 'package:bolixo/api/bet/bet_client.dart';
import 'package:bolixo/main.dart';

import '../model/bet_model.dart';
import '../model/bets_in_day_model.dart';
import 'bet_api_mock.dart';

abstract class BetApi {
  /// Exposed methods
  Future initialize();
  Future<List<BetsInDayModel>> getUserBets();
  Future<List<BetModel>> getBetsByBolaoAndMatch(int? matchId);
  Future saveUserBets(List<BetModel> betList);

  /// Injection turnaround
  static BetApi? betApi;
  static BetApi getInstance() {
    if (betApi == null) {
      switch (MyApp.flavor) {
        case Flavor.mock:
          return MockBetApi();
        case Flavor.staging:
          return BetClient(baseUrl: 'https://lixolao.herokuapp.com');
        case Flavor.production:
          return MockBetApi();
        case Flavor.local:
          return BetClient(baseUrl: 'http://localhost:8080');
      }
    }
    return betApi!;
  }
}
