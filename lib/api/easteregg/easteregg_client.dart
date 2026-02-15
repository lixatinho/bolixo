import 'dart:developer';

import 'package:bolixo/api/easteregg/easteregg_api_interface.dart';
import 'package:dio/dio.dart';

import '../../flow/auth/auth_repository.dart';

class EasterEggClient implements EasterEggApi {

  String baseUrl;
  String getEasterEggPath = "easterEgg";
  Dio dio = Dio();
  late AuthRepository repository;

  EasterEggClient({
    required this.baseUrl
  });

  @override
  Future initialize() async {
    repository = AuthRepository();
    await repository.initialize();
    dio.options.headers['x-access-token'] = repository.getToken();
  }

  @override
  Future postEasterEgg(int easterEggId) async {
    try {
      var response = await dio.post("$baseUrl/$getEasterEggPath", data: {"easterEggId": easterEggId});
      if (response.statusCode == 200) {
        return Future.value();
      } else {
        return Future.error(response.statusCode ?? 500);
      }
    } catch (e) {
      log(e.toString());
      return Future.error(e);
    }
  }

}