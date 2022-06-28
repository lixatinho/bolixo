import '../../api/model/ranking_item_model.dart';

class RankingViewContent {
  List<RankingItemModel> ranking = [];
  List<RankingItemViewContent> rankingItems = [];
  bool isLoading = true;

  RankingViewContent();

  RankingViewContent.fromApiModel(List<RankingItemModel> ranking) {
    ranking = ranking;
    rankingItems = ranking.map(RankingItemViewContent.fromApiModel).toList();
    isLoading = false;
  }
}

class RankingItemViewContent {
  String name = "";
  String points = "";

  RankingItemViewContent({
    required this.name,
    required this.points,
  });

  RankingItemViewContent.fromApiModel(RankingItemModel rankingItem) {
    name = rankingItem.user?.username ?? "";
    points = rankingItem.score?.toString() ?? "";
  }
}
