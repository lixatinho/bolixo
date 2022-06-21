import 'bet_model.dart';

class BetsInDay {
  DateTime date;
  List<BetModel> betList;

  BetsInDay({
    required this.date,
    required this.betList
  });
}