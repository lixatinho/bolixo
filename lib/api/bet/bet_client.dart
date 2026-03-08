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
  int get bolaoId => BolaoCache().bolaoId;
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
      final url = "$baseUrl/$getBets/$bolaoId";
      log('GET UserBets - URL: $url');
      log('GET UserBets - BolaoId from Cache: $bolaoId');

      var response = await dio.get(url);

      log('GET UserBets - Status: ${response.statusCode}');
      log('GET UserBets - Data: ${response.data}');

      if (response.statusCode == 200) {
        var betInDaysList = List<BetsInDayModel>.from(
            response.data.map((model) => BetsInDayModel.fromJson(model)));
        log('GET UserBets - Mapped ${betInDaysList.length} days');
        return Future.value(betInDaysList);
      } else {
        return Future.error(response.statusCode ?? 500);
      }
    } catch (e) {
      log('GET UserBets - Error: ${e.toString()}');
      return Future.error(e);
    }
  }

  @override
  Future<List<BetsInDayModel>> getBetsByUser(int userId) async {
    try {
      String url = "$baseUrl/$getBets/$bolaoId/user/$userId";
      log('GET BetsByUser - URL: $url');
      var response = await dio.get(url);
      if (response.statusCode == 200) {
        var betInDaysList = List<BetsInDayModel>.from(
            response.data.map((model) => BetsInDayModel.fromJson(model)));
        return Future.value(betInDaysList);
      } else {
        return Future.error(response.statusCode ?? 500);
      }
    } catch (e) {
      log('GET BetsByUser - Error: ${e.toString()}');
      return Future.error(e);
    }
  }

  @override
  Future saveUserBets(List<BetModel> betList) async {
    try {
      final url = "$baseUrl/$saveBet/$bolaoId";
      log('PUT SaveUserBets - URL: $url');
      var response = await dio.put(url, data: jsonEncode(betList));
      if (response.statusCode == 200) {
        return Future.value();
      } else {
        return Future.error(response.statusCode ?? 500);
      }
    } catch (e) {
      log('PUT SaveUserBets - Error: ${e.toString()}');
      return Future.error(e);
    }
  }

  @override
  Future<List<BetModel>> getBetsByBolaoAndMatch(int? matchId) async {
    try {
      final url = "$baseUrl/$getBets/$bolaoId/$matchId";
      log('GET BetsByBolaoAndMatch - URL: $url');
      var response = await dio.get(url);
      if (response.statusCode == 200) {
        var betList = List<BetModel>.from(
            response.data.map((model) => BetModel.fromJson(model)));
        return Future.value(betList);
      } else {
        return Future.error(response.statusCode ?? 500);
      }
    } catch (e) {
      log('GET BetsByBolaoAndMatch - Error: ${e.toString()}');
      return Future.error(e);
    }
  }
}
