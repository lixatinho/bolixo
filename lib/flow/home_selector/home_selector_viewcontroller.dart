import 'package:bolixo/api/bolao/bolao_api_interface.dart';
import 'package:bolixo/api/model/bolao_model.dart';
import 'package:bolixo/cache/bolao_cache.dart';
import 'package:bolixo/flow/home_selector/home_selector_view.dart';
import 'package:flutter/foundation.dart';

class HomeSelectorViewController {
  late HomeSelectorViewState? view;
  BolaoApi api = BolaoApi.getInstance();

  void onInit(HomeSelectorViewState state) {
    view = state;
    _loadBoloes();
  }

  void _loadBoloes() async {
    try {
      await api.initialize();
      final boloes = await api.getBoloes();

      if (boloes.isEmpty) {
        view?.updateState(HomeSelectorStatus.empty, []);
      } else if (boloes.length == 1) {
        // Automatically select the only one to update cache for RankingWidget
        BolaoCache().updateBolao(boloes[0].bolaoId!, boloes[0].name!);
        view?.updateState(HomeSelectorStatus.single, boloes);
      } else {
        view?.updateState(HomeSelectorStatus.multiple, boloes);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      view?.updateState(HomeSelectorStatus.error, []);
    }
  }

  void onBolaoSelected(BolaoModel bolao) {
    BolaoCache().updateBolao(bolao.bolaoId!, bolao.name!);
    view?.navigateToBolaoHome();
  }

  void onDispose() {
    view = null;
  }
}

enum HomeSelectorStatus { loading, empty, single, multiple, error }
