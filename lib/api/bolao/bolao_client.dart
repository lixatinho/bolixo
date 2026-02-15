import 'dart:developer';

import 'package:bolixo/api/bolao/bolao_api_interface.dart';
import 'package:bolixo/api/model/bolao_model.dart';
import 'package:bolixo/api/model/ranking_item_model.dart';
import 'package:dio/dio.dart';

import '../../flow/auth/auth_repository.dart';

class BolaoClient implements BolaoApi {

  String baseUrl;
  String getBoloesPath = "ranking";
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
      var response = await dio.get("$baseUrl/$getBoloesPath");
      if (response.statusCode == 200) {
        var ranking = List<RankingItemModel>.from(
            response.data.map(
                    (model) => RankingItemModel.fromJson(model)
            )
        );
        return Future.value(ranking.map((r) => r.bolao!).toList());
      } else {
        return Future.error(response.statusCode ?? 500);
      }
    } catch (e) {
      log(e.toString());
      return Future.error(e);
    }
  }
}