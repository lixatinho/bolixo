import 'dart:convert';
import 'dart:developer';
import 'package:bolixo/api/competition/competition_api_interface.dart';
import 'package:bolixo/api/model/competition_model.dart';
import 'package:bolixo/api/model/match_model.dart';
import 'package:bolixo/api/model/team_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../flow/auth/auth_repository.dart';

class CompetitionClient implements CompetitionApi {
  String baseUrl;
  String competitionsPath = "competition";
  String teamsPath = "team";
  String matchPath = "match";
  Dio dio = Dio();
  late AuthRepository repository;

  CompetitionClient({required this.baseUrl});

  @override
  Future initialize() async {
    repository = AuthRepository();
    await repository.initialize();
    dio.options.headers['x-access-token'] = repository.getToken();
  }

  @override
  Future<List<CompetitionModel>> getAllCompetitions() async {
    try {
      var response = await dio.get("$baseUrl/$competitionsPath");
      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        return List<CompetitionModel>.from(
            response.data.map((model) => CompetitionModel.fromJson(model)));
      } else {
        return Future.error(response.statusCode ?? 500);
      }
    } catch (e) {
      log(e.toString());
      return Future.error(e);
    }
  }

  @override
  Future<List<TeamModel>> getAllTeams() async {
    try {
      var response = await dio.get("$baseUrl/$teamsPath");
      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        return List<TeamModel>.from(
            response.data.map((model) => TeamModel.fromJson(model)));
      } else {
        return Future.error(response.statusCode ?? 500);
      }
    } catch (e) {
      log(e.toString());
      return Future.error(e);
    }
  }

  @override
  Future<TeamModel> createTeam(TeamModel team) async {
    try {
      var response = await dio.post(
        "$baseUrl/$teamsPath",
        data: jsonEncode(team.toJson()),
      );
      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        return TeamModel.fromJson(response.data);
      } else {
        return Future.error(response.data?['msg'] ?? "Erro ao criar time");
      }
    } on DioException catch (e) {
      return Future.error(e.response?.data?['msg'] ?? "Erro ao criar time");
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future createCompetition(CompetitionModel competition, List<int> teamIds) async {
    try {
      competition.teams = teamIds.map((id) => TeamModel(id: id)).toList();
      String body = jsonEncode(competition.toJson());

      if (kDebugMode) {
        print("REQUEST POST: $baseUrl/$competitionsPath");
        print("BODY: $body");
      }

      var response = await dio.post(
        "$baseUrl/$competitionsPath",
        data: body,
      );

      if (kDebugMode) {
        print("RESPONSE STATUS: ${response.statusCode}");
        print("RESPONSE DATA: ${response.data}");
      }

      return (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300)
          ? Future.value()
          : Future.error(response.statusCode ?? 500);
    } on DioException catch (e) {
      if (kDebugMode) {
        print("DIO ERROR: ${e.message}");
        print("DIO RESPONSE: ${e.response?.data}");
      }
      return Future.error(e.response?.data?['msg'] ?? e.message ?? "Erro ao criar competição");
    } catch (e) {
      log(e.toString());
      return Future.error(e);
    }
  }

  @override
  Future updateCompetition(CompetitionModel competition, List<int> teamIds) async {
    try {
      competition.teams = teamIds.map((id) => TeamModel(id: id)).toList();
      String body = jsonEncode(competition.toJson());

      if (kDebugMode) {
        print("REQUEST PUT: $baseUrl/$competitionsPath/${competition.id}");
        print("BODY: $body");
      }

      var response = await dio.put(
        "$baseUrl/$competitionsPath/${competition.id}",
        data: body,
      );

      if (kDebugMode) {
        print("RESPONSE STATUS: ${response.statusCode}");
        print("RESPONSE DATA: ${response.data}");
      }

      return (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300)
          ? Future.value()
          : Future.error(response.statusCode ?? 500);
    } on DioException catch (e) {
      if (kDebugMode) {
        print("DIO ERROR: ${e.message}");
        print("DIO RESPONSE: ${e.response?.data}");
      }
      return Future.error(e.response?.data?['msg'] ?? e.message ?? "Erro ao atualizar competição");
    } catch (e) {
      log(e.toString());
      return Future.error(e);
    }
  }

  @override
  Future<List<MatchModel>> getMatchesByCompetition(int competitionId) async {
    try {
      var response = await dio.get("$baseUrl/$competitionsPath/$competitionId/match");
      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        return List<MatchModel>.from(
            response.data.map((model) => MatchModel.fromJson(model)));
      } else {
        return Future.error(response.statusCode ?? 500);
      }
    } catch (e) {
      log(e.toString());
      return Future.error(e);
    }
  }

  @override
  Future saveMatches(int competitionId, List<MatchModel> matches) async {
    try {
      var response = await dio.post(
        "$baseUrl/$competitionsPath/$competitionId/match",
        data: jsonEncode(matches.map((m) => m.toJson()).toList()),
      );
      return (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300)
          ? Future.value()
          : Future.error(response.statusCode ?? 500);
    } catch (e) {
      log(e.toString());
      return Future.error(e);
    }
  }

  @override
  Future updateMatchResult(MatchModel match) async {
    try {
      String body = jsonEncode(match.toJson());
      if (kDebugMode) {
        print("REQUEST PUT (RESULT): $baseUrl/$matchPath");
        print("BODY: $body");
      }

      var response = await dio.put(
        "$baseUrl/$matchPath",
        data: body,
      );

      if (kDebugMode) {
        print("RESPONSE STATUS: ${response.statusCode}");
        print("RESPONSE DATA: ${response.data}");
      }

      return (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300)
          ? Future.value()
          : Future.error(response.statusCode ?? 500);
    } on DioException catch (e) {
      if (kDebugMode) {
        print("DIO ERROR (RESULT): ${e.message}");
        print("DIO RESPONSE: ${e.response?.data}");
      }
      return Future.error(e.response?.data?['msg'] ?? e.message ?? "Erro ao atualizar resultado");
    } catch (e) {
      log(e.toString());
      return Future.error(e);
    }
  }
}
