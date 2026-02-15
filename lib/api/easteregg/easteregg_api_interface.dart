import 'package:bolixo/api/easteregg/easteregg_client.dart';
import 'package:bolixo/main.dart';

import 'easteregg_mock_api.dart';

abstract class EasterEggApi {

  /// Exposed ids
  static const int rankingOneKey = 1;
  static const int rankingLastKey = 2;
  static const int shakeKey = 3;
  static const int easterEggTotal = 3;

  /// Exposed methods
  Future initialize();
  Future postEasterEgg(int easterEggId);

  /// Injection turnaround
  static EasterEggApi? easterEggApi;
  static EasterEggApi getInstance() {
    if(easterEggApi == null) {
      switch (MyApp.flavor) {
        case Flavor.mock:
          return EasterEggMockClient();
        case Flavor.staging:
          return EasterEggClient(baseUrl: 'https://lixolao-backend.onrender.com');
        case Flavor.production:
          return EasterEggMockClient();
        case Flavor.local:
          return EasterEggClient(baseUrl: 'http://localhost:8080');
      }
    }
    return easterEggApi!;
  }
}
