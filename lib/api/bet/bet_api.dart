import '../model/BetsInDay.dart';
import 'bet_api_interface.dart';

class MockBetApi implements BetApi {

  @override
  Future<List<BetsInDay>> getUserBets() {
    // TODO
    return Future.value(null);
  }
}