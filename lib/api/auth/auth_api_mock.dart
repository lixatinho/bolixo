import 'package:bolixo/api/auth/auth_api.dart';
import 'package:bolixo/api/model/auth_response.dart';
import 'package:bolixo/api/model/user_model.dart';

class MockAuthApi implements AuthApi {
  @override
  Future<AuthResponse> login(UserModel user) {
    return Future.value(AuthResponse(
        auth: true,
        token:
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InNpbGFzIn0.pJbd832huORhZoNk1_RvFu6xd-nG2NnQsRIhtAiiuTk"));
  }

  @override
  Future signUp(UserModel user) {
    return Future.value();
  }
}
