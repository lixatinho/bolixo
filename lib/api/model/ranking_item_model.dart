import 'package:bolixo/api/model/user_model.dart';

class RankingItemModel {
  UserModel? user;
  int? score;
  int? flies;
  int? results;

  RankingItemModel({
    this.user,
    this.score,
    this.flies,
    this.results
  });

  RankingItemModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
    score = json['score'];
    flies = json['flies'];
    results = json['results'];
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
    return data;
  }
}
