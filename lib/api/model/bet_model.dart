class BetModel {
  int? id;
  int? matchId;
  int? userId;
  int? teamOneGoals;
  int? teamTwoGoals;
  int? score;
  String? matchDate;

  BetModel(
      this.id,
      this.matchId,
      this.userId,
      this.teamOneGoals,
      this.teamTwoGoals,
      this.score,
      this.matchDate);

  BetModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    matchId = json['idMatch'];
    userId = json['idUser'];
    teamOneGoals = json['golsTeam1'];
    teamTwoGoals = json['golsTeam2'];
    score = json['score'];
    matchDate = json['datetime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idMatch'] = this.matchId;
    data['idUser'] = this.userId;
    data['golsTeam1'] = this.teamOneGoals;
    data['golsTeam2'] = this.teamTwoGoals;
    data['score'] = this.score;
    data['datetime'] = this.matchDate;
    return data;
  }
}
