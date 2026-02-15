import 'package:bolixo/api/easteregg/easteregg_api_interface.dart';
import 'package:bolixo/api/model/user_model.dart';
import 'package:bolixo/api/ranking/ranking_client.dart';

import 'bolao_model.dart';

class RankingItemModel {
  UserModel? user;
  int? score;
  int? flies;
  int? results;
  String? avatarUrl;
  BolaoModel? bolao;
  bool easterEggComplete = false;

  RankingItemModel({
    this.user,
    this.score,
    this.flies,
    this.results,
    this.avatarUrl,
    this.bolao,
    required this.easterEggComplete
  });

  RankingItemModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
    score = json['score'];
    flies = json['flies'];
    results = json['results'];
    avatarUrl = json['avatarUrl'];
    bolao = json['bolao'] != null ? BolaoModel.fromJson(json['bolao']) : null;
    easterEggComplete = json['easterEggs'] != null ? json['easterEggs'].length >= EasterEggApi.easterEggTotal : false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = user;
    data['score'] = score;
    data['flies'] = flies;
    data['results'] = results;
    data['avatarUrl'] = avatarUrl;
    data['easterEggComplete'] = easterEggComplete;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (bolao != null) {
      data['bolao'] = bolao!.toJson();
    }
    return data;
  }
}

