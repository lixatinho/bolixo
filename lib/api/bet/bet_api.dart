import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import '../model/bets_in_day_model.dart';
import 'bet_api_interface.dart';

class BetClient implements BetApi {

  String baseUrl;
  String getBets = "bet";
  Dio dio = Dio();

  BetClient({
    required this.baseUrl
  });

  @override
  Future<List<BetsInDayModel>> getUserBets() async {
    try {
      var response = await dio.get("$baseUrl/$getBets/1");
      if (response.statusCode == 200) {
        print(response.data);
        var betInDaysList = List<BetsInDayModel>.from(
            response.data.map(
                    (model) => BetsInDayModel.fromJson(model)
            )
        );
        return Future.value(betInDaysList);
      } else {
        return Future.error(response.statusCode);
      }
    } catch (e) {
      log(e.toString());
      return Future.error(e);
    }
  }
}