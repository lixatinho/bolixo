import 'package:bolixo/main.dart';

import 'bet_model.dart';

abstract class BetApi {

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

  Future<List<BetModel>> getUserBets();
}

class MockBetApi implements BetApi {

  @override
  Future<List<BetModel>> getUserBets() {
    return Future.value(
      List.generate(10, (index) =>
        BetModel(
          index,
          index + 10,
          index + 100,
          0,
          0,
          0,
          ''
        )
      )
    );
  }
}