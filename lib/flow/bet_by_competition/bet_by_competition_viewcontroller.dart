import 'package:bolixo/api/bolao/bolao_api_interface.dart';
import 'package:bolixo/api/model/bolao_model.dart';
import 'package:bolixo/cache/bolao_cache.dart';
import 'package:flutter/foundation.dart';
import 'bet_by_competition_view.dart';

class BetByCompetitionViewController {
  late BetByCompetitionViewState? view;
  BolaoApi api = BolaoApi.getInstance();

  void onInit(BetByCompetitionViewState state) {
    view = state;
    _loadCompetitionsFromBoloes();
  }

  void _loadCompetitionsFromBoloes() async {
    try {
      await api.initialize();
      final boloes = await api.getBoloes();

      // Filter to show only one card per competition
      final Map<int, BolaoModel> uniqueCompetitions = {};

      for (var bolao in boloes) {
        if (bolao.competition != null && bolao.competition!.id != null) {
          int compId = bolao.competition!.id!;
          // If we haven't added this competition yet, add it
          if (!uniqueCompetitions.containsKey(compId)) {
            uniqueCompetitions[compId] = bolao;
          }
        }
      }

      view?.updateCompetitions(uniqueCompetitions.values.toList());
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      view?.updateCompetitions([]);
    }
  }

  void onCompetitionSelected(BolaoModel bolao) {
    // When selected, we use the bolaoId from this specific pool to navigate.
    // If there were multiple pools for the same competition, we chose the first one found.
    BolaoCache().updateBolao(bolao.bolaoId!, bolao.name!);
    view?.navigateToBets();
  }

  void onDispose() {
    view = null;
  }
}
