import 'package:bolixo/api/auth/auth_api_mock.dart';
import 'package:bolixo/api/auth/auth_client.dart';
import 'package:bolixo/api/model/auth_response.dart';
import 'package:bolixo/api/model/user_model.dart';
import 'package:bolixo/main.dart';

abstract class AuthApi {
  /// Exposed methods
  Future signUp(UserModel user);
  Future<AuthResponse> login(UserModel user);

  /// Injection turnaround
  static AuthApi? betApi;
  static AuthApi getInstance() {
    if (betApi == null) {
      switch (MyApp.flavor) {
        case Flavor.mock:
          return MockAuthApi();
        case Flavor.local:
          return AuthClient(baseUrl: "http://localhost:8080");
        case Flavor.staging:
          return AuthClient(baseUrl: 'https://lixolao-backend.onrender.com');
        case Flavor.production:
          return AuthClient(baseUrl: 'https://lixolao-backend.onrender.com');
      }
    }
    return betApi!;
  }
}
