import 'dart:math';

import 'package:bolixo/ui/shared/shared_color.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../api/model/ranking_item_model.dart';

class RankingViewContent {
  List<RankingItemModel> ranking = [];
  List<RankingItemViewContent> rankingItems = [];
  double padding = 16;
  bool isLoading = true;

  Map<int, RankingInfoHeader> infoHeaders = <int, RankingInfoHeader>{};
  static const int positionHeaderId = 1;
  static const int nameHeaderId = 2;
  static const int fliesHeaderId = 3;
  static const int pointsHeaderId = 4;
  int selectedSort = 1;

  RankingViewContent();

  RankingViewContent.fromApiModel(List<RankingItemModel> ranking) {
    ranking = ranking;
    generateInfoHeaders();
    rankingItems = ranking.mapIndexed((index, model) =>
      RankingItemViewContent.fromApiModel(model, index)
    ).toList();
    isLoading = false;
  }

  void generateInfoHeaders() {
    infoHeaders.putIfAbsent(positionHeaderId, () => RankingInfoHeader(id: 1, name: 'Posição', widthWeight: 2));
    infoHeaders.putIfAbsent(nameHeaderId, () => RankingInfoHeader(id: 2, name: 'Nome', widthWeight: 4));
    infoHeaders.putIfAbsent(fliesHeaderId, () => RankingInfoHeader(id: 3, name: 'Mitou', widthWeight: 2));
    infoHeaders.putIfAbsent(pointsHeaderId, () => RankingInfoHeader(id: 4, name: 'Pontos', widthWeight: 2));
  }

  void selectSort(int headerId) {
    infoHeaders[selectedSort]?.textColor = RankingInfoHeader.notSelectedColor;
    selectedSort = headerId;
    infoHeaders[selectedSort]?.textColor = RankingInfoHeader.selectedColor;
    sortRankingItems(headerId);
    rankingItems.forEachIndexed((index, element) { element.updateSortedItem(index); });
  }

  void sortRankingItems(int headerId) {
    switch (headerId) {
      case positionHeaderId: {
        rankingItems.sort((a, b) {
          return int.parse(a.position) - int.parse(b.position);
        });
      }
      break;
      case nameHeaderId: {
        rankingItems.sort((a, b) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
      }
      break;
      case fliesHeaderId: {
        rankingItems.sort((a, b) {
          return int.parse(b.flies) - int.parse(a.flies);
        });
      }
      break;
      case pointsHeaderId: {
        rankingItems.sort((a, b) {
          return int.parse(b.points) - int.parse(a.points);
        });
      }
      break;
    }
  }
}

class RankingItemViewContent {
  String position = "";
  String name = "";
  String points = "";
  String flies = "";
  double rotationAngle;
  Color backgroundColor = Colors.indigo;

  RankingItemViewContent({
    required this.position,
    required this.name,
    required this.points,
    required this.flies,
    required this.backgroundColor,
    required this.rotationAngle,
  });

  static RankingItemViewContent fromApiModel(RankingItemModel rankingItem, int index) {
    return RankingItemViewContent(
      position: "${index + 1}",
      name: rankingItem.user?.username ?? "",
      points: rankingItem.score?.toString() ?? "0",
      flies: rankingItem.flies?.toString() ?? "0",
      backgroundColor: shadeByIndex(Colors.indigo, index),
      rotationAngle: 0
    );
  }

  void updateSortedItem(int newPosition) {
    backgroundColor = shadeByIndex(Colors.indigo, newPosition);
  }
}

class RankingInfoHeader {
  int id = 0;
  String name = "";
  int widthWeight = 0;
  Color textColor = Colors.indigo;

  static const selectedColor = Colors.indigoAccent;
  static const notSelectedColor = Colors.indigo;

  RankingInfoHeader({
    required this.id,
    required this.name,
    required this.widthWeight,
  });
}
