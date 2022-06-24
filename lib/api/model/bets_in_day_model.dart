import 'bet_model.dart';

class BetsInDayModel {
  DateTime date = DateTime.now();
  List<BetModel> betList = List.empty();

  BetsInDayModel({
    required this.date,
    required this.betList
  });

  BetsInDayModel.fromJson(Map<String, dynamic> jsonMap) {
    date = DateTime.parse(jsonMap['date']);
    betList = List<BetModel>.from(
      jsonMap['betsPerDay'].map(
        (model)=> BetModel.fromJson(model)
      )
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonMap = <String, dynamic>{};
    jsonMap['date'] = date;
    jsonMap['betsPerDay'] = betList.map((bet) => bet.toJson());
    return jsonMap;
  }
}