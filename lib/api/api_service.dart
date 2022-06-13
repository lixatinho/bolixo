import 'dart:convert';
import 'dart:developer';

import 'package:bolixo/ui/palpites.dart';
import 'package:dio/dio.dart';

import 'model/rankingModel.dart';
import 'model/user.dart';
import 'urls.dart';

class ApiService {
  Dio dio = Dio();
  late Response response;

  Future<List<User>?> getUsers() async {
    List<User> users = [];
    try {
      response =
          await dio.get(ApiConstants.baseUrl + ApiConstants.usersEndpoint);
      if (response.statusCode == 200) {
        print(response.data);
        //lista
        var lista = (response.data as List).map((item) {
          return userFromJson(item);
        });
        User user = userFromJson(response.data);
        users.add(user);
        users.add(user);
        users.add(user);
        users.add(user);
        users.add(user);
        users.add(user);
        users.add(user);
        users.add(user);
      }
    } catch (e) {
      log(e.toString());
    }
    return users;
  }

  Future<List<RankingModel>> getRanking() async {
    List<RankingModel> ranking = [];
    String data = '[ {"idUser": 1, "name": "Andre", "score": 10, "flies": 1},      {"idUser": 2, "name": "Caldas", "score": 6, "flies": 0},      {"idUser": 3, "name": "User", "score": 5, "flies": 0},      {"idUser": 4, "name": "Silas", "score": 1, "flies": 0},      {"idUser": 5, "name": "PA", "score": 0, "flies": 0}    ]';

    try {
      // response = await dio.get(ApiConstants.baseUrl + ApiConstants.rankingEndpoint);
      // if (response.statusCode == 200) {
        print(data);
        Iterable l = json.decode(data);
        ranking = List<RankingModel>.from(l.map((model)=> RankingModel.fromJson(model)));
        // lista = (response.data as List).map((item) {
        //   return RankingModel.fromJson(item);
        // }).toList();
      // }
    } catch (e) {
      log(e.toString());
    }
    return ranking;
  }

  Future<List<PalpiteModel>> getPalpitesFromUser(int idUser) async {
    response.data = [
      {
        "id": 1,
        "idMatch": 10,
        "idUser": 1,
        "golsTeam1": 0,
        "golsTeam2": 0,
        "score": 5,
        "datetime": "2022-06-01"
      },
      {
        "id": 23,
        "idMatch": 10,
        "idUser": 1,
        "golsTeam1": 0,
        "golsTeam2": 0,
        "score": 5,
        "datetime": "2022-06-01"
      }
    ];

    List<PalpiteModel> palpites = [];
    try {
      response =
          await dio.get(ApiConstants.baseUrl + ApiConstants.usersEndpoint);
      if (response.statusCode == 200) {
        print(response.data);
        //lista
        var lista = (response.data as List).map((item) {
          return userFromJson(item);
        });
      }
    } catch (e) {
      log(e.toString());
    }
    return palpites;
  }
}
