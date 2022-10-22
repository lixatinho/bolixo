import 'package:bolixo/api/model/ranking_item_model.dart';
import 'package:bolixo/api/ranking/ranking_client.dart';
import 'package:bolixo/api/ranking/ranking_mock_api.dart';
import 'package:bolixo/main.dart';

abstract class RankingApi {

  /// Exposed methods
  Future initialize();
  Future<List<RankingItemModel>> getRanking();

  /// Injection turnaround
  static RankingApi? betApi;
  static RankingApi getInstance() {
    if(betApi == null) {
      switch (MyApp.flavor) {
        case Flavor.mock:
          return RankingMockApi();
        case Flavor.staging:
          return RankingClient(baseUrl: 'https://lixolao.herokuapp.com');
        case Flavor.production:
          return RankingMockApi();
        case Flavor.local:
          return RankingClient(baseUrl: 'http://localhost:8080');
      }
    }
    return betApi!;
  }
}
