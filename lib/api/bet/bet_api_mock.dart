import '../model/bet_model.dart';
import 'bet_api_interface.dart';

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