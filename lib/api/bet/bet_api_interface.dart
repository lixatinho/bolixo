import 'package:bolixo/main.dart';

import '../model/bet_model.dart';
import 'bet_api_mock.dart';

abstract class BetApi {

  /// Exposed methods
  Future<List<BetModel>> getUserBets();


  /// Injection turnaround
  static BetApi? betApi;
  static BetApi getInstance() {
    if(betApi == null) {
      switch (MyApp.flavor) {
        default:
          betApi = MockBetApi();
      }
    }
    return betApi!;
  }
}
