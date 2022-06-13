import 'bet_api_interface.dart';
import '../model/bet_model.dart';

class MockBetApi implements BetApi {

  @override
  Future<List<BetModel>> getUserBets() {
    // TODO
    return Future.value(null);
  }
}