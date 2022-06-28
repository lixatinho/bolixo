import 'package:bolixo/api/ranking/ranking_api_interface.dart';
import 'package:bolixo/flow/ranking/ranking_view.dart';
import 'package:bolixo/flow/ranking/ranking_view_content.dart';

class RankingViewController {

  RankingApi api = RankingApi.getInstance();
  late RankingWidgetState? view;

  void onInit(viewInstance) async {
    view = viewInstance;
    await _prepareApi();
    _fillRanking();
  }

  Future _prepareApi() async {
    await api.initialize();
  }

  void _fillRanking() {
    api.getRanking().then((ranking) {
      RankingViewContent viewContent = RankingViewContent.fromApiModel(ranking);
      view!.update(viewContent);
    }, onError: (error) {
      print(error);
    });
  }

  void onDispose() {
    view = null;
  }
}