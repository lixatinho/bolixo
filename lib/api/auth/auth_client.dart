import 'dart:convert';
import 'dart:developer';

import 'package:bolixo/api/model/auth_response.dart';
import 'package:bolixo/api/model/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'auth_api.dart';

class AuthClient implements AuthApi {
  String baseUrl;
  String loginPath = "login";
  String signUpPath = "user";
  String recoverPasswordPath = "login/recover-password";
  String changePasswordPath = "user/change-password";
  Dio dio = Dio();

  AuthClient({required this.baseUrl});

  @override
  Future<AuthResponse> login(UserModel user) async {
    try {
      var response = await dio.post("$baseUrl/$loginPath", data: jsonEncode(user));
      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        if (kDebugMode) {
          print(response.data);
        }
        AuthResponse authResponse = AuthResponse.fromJson(response.data);
        return Future.value(authResponse);
      } else {
        return Future.error(response.data?['msg'] ?? response.statusCode ?? 500);
      }
    } on DioException catch (e) {
      log(e.toString());
      if (e.response != null && e.response?.data != null && e.response?.data is Map) {
        return Future.error(e.response?.data['msg'] ?? "Erro ao fazer login");
      }
      return Future.error(e.message ?? "Erro de conexão");
    } catch (e) {
      log(e.toString());
      return Future.error(e);
    }
  }

  @override
  Future signUp(UserModel user) async {
    try {
      var response =
          await dio.post("$baseUrl/$signUpPath", data: jsonEncode(user));
      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        return Future.value();
      } else {
        return Future.error(response.data?['msg'] ?? response.statusCode ?? 500);
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null && e.response?.data is Map) {
        return Future.error(e.response?.data['msg'] ?? "Erro ao criar conta");
      }
      return Future.error(e.message ?? "Erro de conexão");
    } catch (e) {
      log(e.toString());
      return Future.error(e);
    }
  }

  @override
  Future recoverPassword(String email) async {
    try {
      var response = await dio.post("$baseUrl/$recoverPasswordPath",
          queryParameters: {"email": email});
      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        return Future.value();
      } else {
        return Future.error(response.data?['msg'] ?? response.statusCode ?? 500);
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null && e.response?.data is Map) {
        return Future.error(e.response?.data['msg'] ?? "Erro ao recuperar senha");
      }
      return Future.error(e.message ?? "Erro de conexão");
    } catch (e) {
      log(e.toString());
      return Future.error(e);
    }
  }

  @override
  Future changePassword(String token, String oldPassword, String newPassword) async {
    try {
      var response = await dio.post(
        "$baseUrl/$changePasswordPath",
        data: jsonEncode({
          "oldPassword": oldPassword,
          "newPassword": newPassword,
        }),
        options: Options(headers: {"x-access-token": token}),
      );
      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        return Future.value();
      } else {
        return Future.error(response.data?['msg'] ?? response.statusCode ?? 500);
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null && e.response?.data is Map) {
        return Future.error(e.response?.data['msg'] ?? "Erro ao alterar senha");
      }
      return Future.error(e.message ?? "Erro de conexão");
    } catch (e) {
      log(e.toString());
      return Future.error(e);
    }
  }
}
