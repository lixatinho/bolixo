import 'dart:math';

import 'package:bolixo/api/easteregg/easteregg_api_interface.dart';
import 'package:bolixo/api/model/ranking_item_model.dart';
import 'package:bolixo/api/model/user_model.dart';

class EasterEggMockClient extends EasterEggApi {

  var random = Random();

  @override
  Future<List<RankingItemModel>> getRanking() {
    int rankingSize = 10;
    List<RankingItemModel> ranking = List.generate(rankingSize, (index) {
      return RankingItemModel(
        user: UserModel(
          id: index,
          email: "user${index + 1}@mail.com",
          password: "",
          username: "User ${index + 1}"
        ),
        score: random.nextInt((rankingSize-index) * 10),
        flies: 0,
        results: 0,
        easterEggComplete: false
      );
    });
    return Future.value(ranking);
  }

  @override
  Future initialize() {
    return Future.value();
  }

  @override
  Future postEasterEgg(int easterEggId) {
    return Future.value();
  }
}