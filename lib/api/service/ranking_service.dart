import 'dart:convert';
import 'dart:developer';

import 'package:bolixo/api/model/bet_model.dart';
import 'package:bolixo/flow/bets/bets_view.dart';
import 'package:dio/dio.dart';

import '../model/ranking_item_model.dart';
import '../model/user_model.dart';
import '../urls.dart';

class RankingService {
  Dio dio = Dio();
  late Response response;

  Future<List<RankingItemModel>> getRanking() async {
    List<RankingItemModel> ranking = [];
    String data = '[ {"idUser": 1, "name": "Andre", "score": 10, "flies": 1},      {"idUser": 2, "name": "Caldas", "score": 6, "flies": 0},      {"idUser": 3, "name": "User", "score": 5, "flies": 0},      {"idUser": 4, "name": "Silas", "score": 1, "flies": 0},      {"idUser": 5, "name": "PA", "score": 0, "flies": 0}    ]';

    try {
      // response = await dio.get(ApiConstants.baseUrl + ApiConstants.rankingEndpoint);
      // if (response.statusCode == 200) {
        print(data);
        Iterable l = json.decode(data);
        ranking = List<RankingItemModel>.from(l.map((model)=> RankingItemModel.fromJson(model)));
        // lista = (response.data as List).map((item) {
        //   return RankingModel.fromJson(item);
        // }).toList();
      // }
    } catch (e) {
      log(e.toString());
    }
    return ranking;
  }

}
