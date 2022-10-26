import 'dart:ui';

import 'package:flutter/material.dart';

import '../../api/model/bolao_model.dart';
import '../../ui/shared/shared_color.dart';

class BoloesViewContent {
  List<BolaoViewContent> boloes = [];
  bool isLoading = true;
  List<BolaoModel> _models = [];

  BoloesViewContent();

  BoloesViewContent.fromApiModel(List<BolaoModel> models) {
    _models = models;
    boloes = [];
    int index = 0;
    for (final bolao in models) {
      boloes.add(BolaoViewContent.fromApiModel(bolao, index));
      index++;
    }
    isLoading = false;
  }
}

class BolaoViewContent {
  int id;
  String name;
  Color backgroundColor;
  Color textColor;

  BolaoViewContent({
    required this.id,
    required this.name,
    required this.backgroundColor,
    required this.textColor,
  });

  static fromApiModel(BolaoModel? model, int index) {
    Color background = shadeByIndex(Colors.deepOrange, index);
    return BolaoViewContent(
      id: model?.bolaoId ?? 0,
      name: model?.name ?? "",
      backgroundColor: background,
      textColor: Colors.white
    );
  }
}



