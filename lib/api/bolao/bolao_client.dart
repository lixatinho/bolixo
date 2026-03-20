import 'dart:convert';
import 'dart:developer';

import 'package:bolixo/api/bolao/bolao_api_interface.dart';
import 'package:bolixo/api/model/bolao_model.dart';
import 'package:bolixo/api/model/competition_model.dart';
import 'package:bolixo/api/model/ranking_item_model.dart';
import 'package:dio/dio.dart';

import '../../flow/auth/auth_repository.dart';

class BolaoClient implements BolaoApi {

  String baseUrl;
  String getBoloesPath = "ranking";
  String getCompetitionsPath = "competition/active";
  String createBolaoPath = "bolao";
  Dio dio = Dio();
  late AuthRepository repository;

  BolaoClient({
    required this.baseUrl
  });

  @override
  Future initialize() async {
    repository = AuthRepository();
    await repository.initialize();
    dio.options.headers['x-access-token'] = repository.getToken();
  }

  @override
  Future<List<BolaoModel>> getBoloes() async {
    try {
      final url = "$baseUrl/$getBoloesPath";
      log('GET Boloes - URL: $url');

      var response = await dio.get(url);

      log('GET Boloes - Status: ${response.statusCode}');
      // Print the full response to the terminal for debugging
      print('DEBUG: Full Ranking Response: ${jsonEncode(response.data)}');

      if (response.statusCode == 200) {
        var ranking = List<RankingItemModel>.from(
            response.data.map(
                    (model) {
                      print('DEBUG: Ranking Item JSON: $model');
                      return RankingItemModel.fromJson(model);
                    }
            )
        );
        var boloes = ranking.map((r) => r.bolao!).toList();
        log('GET Boloes - Found ${boloes.length} boloes');
        return Future.value(boloes);
      } else {
        log('GET Boloes - Error status: ${response.statusCode}');
        return Future.error(response.statusCode ?? 500);
      }
    } catch (e) {
      log('GET Boloes - Exception: $e');
      print('DEBUG: getBoloes Exception: $e');
      return Future.error(e);
    }
  }

  @override
  Future<List<CompetitionModel>> getActiveCompetitions() async {
    try {
      var response = await dio.get("$baseUrl/$getCompetitionsPath");
      if (response.statusCode == 200) {
        return List<CompetitionModel>.from(
            response.data.map((model) => CompetitionModel.fromJson(model))
        );
      } else {
        return Future.error(response.statusCode ?? 500);
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future createBolao(String name, int competitionId, bool isGlobal) async {
    try {
      var response = await dio.post(
          "$baseUrl/$createBolaoPath",
          data: jsonEncode({
            "name": name,
            "isGlobal": isGlobal,
            "competition": {
              "id": competitionId
            }
          })
      );
      if (response.statusCode == 200) {
        return Future.value();
      } else {
        return Future.error(response.statusCode ?? 500);
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
