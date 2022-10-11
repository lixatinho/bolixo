import 'package:bolixo/flow/boloes/boloes_view.dart';
import 'package:bolixo/api/model/bolao_model.dart';

import '../../api/ranking/ranking_api_interface.dart';
import 'boloes_view_content.dart';

class BoloesViewController {

  RankingApi api = RankingApi.getInstance();
  late BoloesWidgetState? view;

  void onInit(viewInstance) async {
    view = viewInstance;
    await _prepareApi();
    _fillBoloes();
  }

  Future _prepareApi() async {
    await api.initialize();
  }

  void _fillBoloes() {
    api.getBoloes().then((ranking) {
      BoloesViewContent viewContent = BoloesViewContent.fromApiModel(ranking);
      view!.update(viewContent);
    }, onError: (error) {
      print(error);
    });
  }

  void onDispose() {
    view = null;
  }
}