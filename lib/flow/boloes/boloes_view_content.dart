import '../../api/model/bolao_model.dart';
import '../../api/model/ranking_item_model.dart';

class BoloesViewContent {
  List<BolaoModel?> boloes = [];
  bool isLoading = true;

  BoloesViewContent();

  BoloesViewContent.fromApiModel(List<RankingItemModel> ranking) {
    for (final e in ranking) {
      boloes.add(e.bolao);
    }
    isLoading = false;
  }
}
