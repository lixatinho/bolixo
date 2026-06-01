import 'dart:convert';
import 'dart:developer';

import 'package:bolixo/api/model/bet_model.dart';
import 'package:dio/dio.dart';

import '../../flow/auth/auth_repository.dart';
import '../model/bets_in_day_model.dart';
import 'bet_api_interface.dart';

class BetClient implements BetApi {
  String baseUrl;
  String getBets = "bet";
  String saveBet = "bet";
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
  Future<List<BetsInDayModel>> getUserBets({required int competitionId}) async {
    try {
      String url = "$baseUrl/$getBets/competition/$competitionId";
      print('getUserBets chamando URL: $url');
      var response = await dio.get(url);

      if (response.statusCode == 200) {
        var betInDaysList = List<BetsInDayModel>.from(
            response.data.map((model) => BetsInDayModel.fromJson(model)));
        return Future.value(betInDaysList);
      } else {
        return Future.error(response.statusCode ?? 500);
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<List<BetsInDayModel>> getBetsByUser(int userId, int bolaoId) async {
    try {
      String url = "$baseUrl/$getBets/$bolaoId/user/$userId";
      print("getBetsByUser bolaoId $bolaoId");
      var response = await dio.get(url);

      if (response.statusCode == 200) {
        var betInDaysList = List<BetsInDayModel>.from(
            response.data.map((model) => BetsInDayModel.fromJson(model)));
        return Future.value(betInDaysList);
      } else {
        return Future.error(response.statusCode ?? 500);
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future saveUserBets(List<BetModel> betList,
      {required int competitionId}) async {
    try {
      String url = "$baseUrl/$saveBet/competition/$competitionId";

      var response = await dio.put(url, data: jsonEncode(betList));
      if (response.statusCode == 200) {
        return Future.value();
      } else {
        return Future.error(response.statusCode ?? 500);
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<List<BetModel>> getBetsByMatch(int matchId) async {
    try {
      final url = "$baseUrl/$getBets/match/$matchId";
      var response = await dio.get(url);
      if (response.statusCode == 200) {
        var betList = List<BetModel>.from(
            response.data.map((model) => BetModel.fromJson(model)));
        return Future.value(betList);
      } else {
        return Future.error(response.statusCode ?? 500);
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
