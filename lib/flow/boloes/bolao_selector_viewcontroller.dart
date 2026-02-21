import 'package:bolixo/api/bolao/bolao_api_interface.dart';
import 'package:bolixo/cache/bolao_cache.dart';
import 'package:bolixo/flow/boloes/bolao_selector_view.dart';
import 'package:flutter/foundation.dart';

import 'boloes_view_content.dart';

class BolaoSelectorViewController {
  BolaoApi api = BolaoApi.getInstance();
  late BolaoSelectorViewState? view;

  void onInit(viewInstance) async {
    view = viewInstance;
    await _prepareApi();
    _fillBoloes();
  }

  void onBolaoSelected(int bolaoId, String name) {
    BolaoCache().updateBolao(bolaoId, name);
  }

  Future _prepareApi() async {
    await api.initialize();
  }

  void _fillBoloes() {
    api.getBoloes().then((boloes) {
      BoloesViewContent viewContent = BoloesViewContent.fromApiModel(boloes);
      view!.update(viewContent);
    }, onError: (error) {
      if (kDebugMode) {
        print('Erro ao carregar bolões: $error');
      }
    });
  }

  void onDispose() {
    view = null;
  }
}
