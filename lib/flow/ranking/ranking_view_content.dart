import 'package:flutter/material.dart';

import '../../api/model/ranking_item_model.dart';
import 'package:collection/collection.dart';

class RankingViewContent {
  List<RankingItemModel> ranking = [];
  List<RankingItemViewContent> rankingItems = [];
  bool isLoading = true;

  RankingViewContent();

  RankingViewContent.fromApiModel(List<RankingItemModel> ranking) {
    ranking = ranking;
    rankingItems = ranking.mapIndexed((index, model) =>
      RankingItemViewContent.fromApiModel(model, index)
    ).toList();
    isLoading = false;
  }
}

class RankingItemViewContent {
  String name = "";
  String points = "";
  String flies = "";
  Color backgroundColor = Colors.indigo;

  RankingItemViewContent({
    required this.name,
    required this.points,
    required this.flies,
    required this.backgroundColor,
  });

  static RankingItemViewContent fromApiModel(RankingItemModel rankingItem, int index) {
    return RankingItemViewContent(
      name: rankingItem.user?.username ?? "",
      points: rankingItem.score?.toString() ?? "",
      flies: rankingItem.flies?.toString() ?? "",
      backgroundColor: index.isEven ? Colors.indigo : Colors.indigoAccent
    );
  }
}
