import 'dart:developer';

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
      response = await dio.get(ApiConstants.baseUrl + ApiConstants.usersEndpoint);
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
    ranking.add(RankingModel(1, "Andre", 10, 1));
    ranking.add(RankingModel(2, "Caldas", 1, 0));
    ranking.add(RankingModel(3, "PA", 0, 0));
    ranking.add(RankingModel(4, "Silas", 6, 0));
    ranking.add(RankingModel(5, "User", 5, 0));

    // try {
    //   response = await dio.get(ApiConstants.baseUrl + ApiConstants.rankingEndpoint);
    //   if (response.statusCode == 200) {
    //     print(response.data);
    //     ranking = (response.data as List).map((item) {
    //       return RankingModel.fromJson(item);
    //     }).toList();
    //   }
    // } catch (e) {
    //   log(e.toString());
    // }
    return ranking;
  }
}
