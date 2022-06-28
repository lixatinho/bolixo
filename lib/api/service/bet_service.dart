import 'dart:convert';
import 'dart:developer';

import 'package:bolixo/api/model/bet_model.dart';
import 'package:bolixo/flow/bets/bets_view.dart';
import 'package:dio/dio.dart';

import '../model/ranking_item_model.dart';
import '../model/user_model.dart';
import '../urls.dart';

class BetService {

    Future<List<BetModel>> getBetsFromUser(int idUser) async {
    Dio dio = Dio();
    Response response =  Response();
    List<BetModel> bets = [];

    response.data = '[      {        "idMatch": 64,        "away": {          "id": 1,          "name": "Brasil",          "urlImage": ""        },        "home": {          "id": 2,          "name": "Argentina",          "urlImage": ""        },        "goalsAway": 50,        "goalsHome": 0,        "dtHour": "2022-12-18",        "type": 5      },      {        "idMatch": 63,        "away": {          "id": 1,          "name": "Brasil",          "urlImage": ""        },        "home": {          "id": 2,          "name": "Alemanha",          "urlImage": ""        },        "goalsAway": 7,        "goalsHome": 1,        "dtHour": "2022-12-18",        "type": 4      },    ]';

    try {
      // response = await dio.get(ApiConstants.baseUrl + ApiConstants.usersEndpoint);
      // if (response.statusCode == 200) {
        print(response.data);
        Iterable l = json.decode(response.data);
        bets = List<BetModel>.from(l.map((model)=> BetModel.fromJson(model)));
      // }
    } catch (e) {
      log(e.toString());
    }
    return bets;
  }
}
