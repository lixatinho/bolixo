import 'package:bolixo/api/model/user_model.dart';

import 'bolao_model.dart';

class RankingItemModel {
  UserModel? user;
  int? score;
  int? flies;
  int? results;
  BolaoModel? bolao;

  RankingItemModel({
    this.user,
    this.score,
    this.flies,
    this.results,
    this.bolao
  });

  RankingItemModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
    score = json['score'];
    flies = json['flies'];
    results = json['results'];
    bolao = json['bolao'] != null ? BolaoModel.fromJson(json['bolao']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = user;
    data['score'] = score;
    data['flies'] = flies;
    data['results'] = results;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (bolao != null) {
      data['bolao'] = bolao!.toJson();
    }
    return data;
  }
}

