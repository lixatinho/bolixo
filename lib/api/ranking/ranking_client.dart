import 'dart:developer';

import 'package:bolixo/api/model/ranking_item_model.dart';
import 'package:bolixo/api/ranking/ranking_api_interface.dart';
import 'package:bolixo/cache/bolao_cache.dart';
import 'package:dio/dio.dart';

import '../../flow/auth/auth_repository.dart';

class RankingClient implements RankingApi {

  String baseUrl;
  String getRankingPath = "ranking";
  int bolaoId = BolaoCache().bolaoId;
  Dio dio = Dio();
  late AuthRepository repository;

  RankingClient({
    required this.baseUrl
  });

  @override
  Future initialize() async {
    repository = AuthRepository();
    await repository.initialize();
    dio.options.headers['x-access-token'] = repository.getToken();
  }

  @override
  Future<List<RankingItemModel>> getRanking() async {
    try {
      var response = await dio.get("$baseUrl/$getRankingPath/$bolaoId");
      if (response.statusCode == 200) {
        var ranking = List<RankingItemModel>.from(
          response.data.map(
            (model) => RankingItemModel.fromJson(model)
          )
        );
        return Future.value(ranking);
      } else {
        return Future.error(response.statusCode);
      }
    } catch (e) {
      log(e.toString());
      return Future.error(e);
    }
  }
}