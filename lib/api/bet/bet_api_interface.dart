import 'package:bolixo/main.dart';

import '../model/BetsInDay.dart';
import 'bet_api_mock.dart';

abstract class BetApi {

  /// Exposed methods
  Future<List<BetsInDay>> getUserBets();


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
