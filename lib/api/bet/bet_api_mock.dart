import 'package:bolixo/api/model/match_model.dart';

import '../model/bet_model.dart';
import '../model/user_model.dart';
import 'bet_api_interface.dart';

class MockBetApi implements BetApi {

  @override
  Future<List<BetModel>> getUserBets() {
    return Future.value(
        List.generate(10, (index) =>
            BetModel(
                index,
                MatchModel(),
                UserModel(),
                0,
                0,
                0,
                ''
            )
        )
    );
  }
}