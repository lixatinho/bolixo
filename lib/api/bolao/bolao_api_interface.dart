import 'package:bolixo/api/bolao/bolao_client.dart';
import 'package:bolixo/api/bolao/bolao_mock_api.dart';
import 'package:bolixo/api/model/competition_model.dart';
import 'package:bolixo/main.dart';

import '../model/bolao_model.dart';

abstract class BolaoApi {

  /// Exposed methods
  Future initialize();
  Future<List<BolaoModel>> getBoloes();
  Future<List<CompetitionModel>> getActiveCompetitions();
  Future createBolao(String name, int competitionId);

  /// Injection turnaround
  static BolaoApi? bolaoApi;
  static BolaoApi getInstance() {
    if(bolaoApi == null) {
      switch (MyApp.flavor) {
        case Flavor.mock:
          return BolaoMockApi();
        case Flavor.staging:
          return BolaoClient(baseUrl: 'https://lixolao-backend.onrender.com');
        case Flavor.production:
          return BolaoMockApi();
        case Flavor.local:
          return BolaoClient(baseUrl: 'http://localhost:8080');
      }
    }
    return bolaoApi!;
  }
}
