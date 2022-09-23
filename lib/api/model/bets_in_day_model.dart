import 'bet_model.dart';

class BetsInDayModel {
  DateTime date = DateTime.now();
  List<BetModel> betList = List.empty();
  int maxPointsInDay = 0;

  BetsInDayModel({
    required this.date,
    required this.betList,
    required this.maxPointsInDay,
  });

  BetsInDayModel.fromJson(Map<String, dynamic> jsonMap) {
    date = DateTime.parse(jsonMap['date']);
    betList = List<BetModel>.from(
      jsonMap['betsPerDay'].map(
        (model)=> BetModel.fromJson(model)
      )
    );
    maxPointsInDay = betList.length * 5; // TODO - get this from backend
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonMap = <String, dynamic>{};
    jsonMap['date'] = date;
    jsonMap['betsPerDay'] = betList.map((bet) => bet.toJson());
    jsonMap['maxPointsInDay'] = maxPointsInDay;
    return jsonMap;
  }
}