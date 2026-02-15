import 'dart:convert';
import 'dart:developer';

import 'package:bolixo/api/model/bet_model.dart';
import 'package:bolixo/cache/bolao_cache.dart';
import 'package:dio/dio.dart';

import '../../flow/auth/auth_repository.dart';
import '../model/bets_in_day_model.dart';
import 'bet_api_interface.dart';

class BetClient implements BetApi {
  String baseUrl;
  String getBets = "bet";
  String saveBet = "bet";
  int bolaoId = BolaoCache().bolaoId;
  Dio dio = Dio();
  late AuthRepository repository;

  BetClient({required this.baseUrl});

  @override
  Future initialize() async {
    repository = AuthRepository();
    await repository.initialize();
    dio.options.headers['x-access-token'] = repository.getToken();
  }

  @override
  Future<List<BetsInDayModel>> getUserBets() async {
    try {
      var response = await dio.get("$baseUrl/$getBets/$bolaoId");
      if (response.statusCode == 200) {
        var betInDaysList = List<BetsInDayModel>.from(
            response.data.map((model) => BetsInDayModel.fromJson(model)));
        return Future.value(betInDaysList);
      } else {
        return Future.error(response.statusCode ?? 500);
      }
    } catch (e) {
      log(e.toString());
      return Future.error(e);
    }
  }

  @override
  Future saveUserBets(List<BetModel> betList) async {
    try {
      var response = await dio.put("$baseUrl/$saveBet/$bolaoId",
          data: jsonEncode(betList));
      if (response.statusCode == 200) {
        return Future.value();
      } else {
        return Future.error(response.statusCode ?? 500);
      }
    } catch (e) {
      log(e.toString());
      return Future.error(e);
    }
  }

  @override
  Future<List<BetModel>> getBetsByBolaoAndMatch(int? matchId) async {
    try {
      var response = await dio.get("$baseUrl/$getBets/$bolaoId/$matchId");
      if (response.statusCode == 200) {
        var betList = List<BetModel>.from(
            response.data.map((model) => BetModel.fromJson(model)));
        return Future.value(betList);
      } else {
        return Future.error(response.statusCode ?? 500);
      }
    } catch (e) {
      log(e.toString());
      return Future.error(e);
    }
  }
}
