import 'dart:math';

import 'package:bolixo/api/bolao/bolao_api_interface.dart';
import 'package:bolixo/api/model/bolao_model.dart';

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
}