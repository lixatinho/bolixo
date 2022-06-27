import 'dart:convert';
import 'dart:developer';

import 'package:bolixo/api/model/bet_model.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../service/AuthRepository.dart';
import '../model/bets_in_day_model.dart';
import 'bet_api_interface.dart';

class BetClient implements BetApi {

  String baseUrl;
  String getBets = "bet";
  String saveBet = "bet";
  String idBolao = "2";
  Dio dio = Dio();
  late AuthRepository repository;

  BetClient({
    required this.baseUrl
  });

  @override
  Future initialize() async {
    repository = AuthRepository();
    await repository.initialize();
    dio.options.headers['x-access-token'] = repository.getToken();
  }

  @override
  Future<List<BetsInDayModel>> getUserBets() async {
    try {
      var response = await dio.get("$baseUrl/$getBets/$idBolao");
      var prefsInstance = await SharedPreferences.getInstance();
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

  @override
  Future saveUserBets(List<BetModel> betList) async {
    try {
      var response = await dio.put(
          "$baseUrl/$saveBet/$idBolao",
          data: jsonEncode(betList)
      );
      if (response.statusCode == 200) {
        print(response.data);
        return Future.value();
      } else {
        return Future.error(response.statusCode);
      }
    } catch (e) {
      log(e.toString());
      return Future.error(e);
    }
  }
}