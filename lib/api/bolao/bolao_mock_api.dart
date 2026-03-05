import 'dart:math';

import 'package:bolixo/api/bolao/bolao_api_interface.dart';
import 'package:bolixo/api/model/bolao_model.dart';
import 'package:bolixo/api/model/competition_model.dart';

class BolaoMockApi extends BolaoApi {

  var random = Random();

  @override
  Future initialize() {
    return Future.value();
  }

  @override
  Future<List<BolaoModel>> getBoloes() {
    int boloesSize = 10;
    List<BolaoModel> ranking = List.generate(boloesSize, (index) {
      return BolaoModel(
          name: "Bolao $index",
      );
    });
    return Future.value(ranking);
  }

  @override
  Future<List<CompetitionModel>> getActiveCompetitions() {
    return Future.value([
      CompetitionModel(id: 1, name: "Copa do Mundo 2026"),
      CompetitionModel(id: 2, name: "Champions League 24/25"),
    ]);
  }

  @override
  Future createBolao(String name, int competitionId) {
    return Future.value();
  }
}
