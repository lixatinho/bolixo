import 'package:bolixo/api/easteregg/easteregg_api_interface.dart';
import 'package:bolixo/api/ranking/ranking_api_interface.dart';
import 'package:bolixo/flow/ranking/ranking_view.dart';
import 'package:bolixo/flow/ranking/ranking_view_content.dart';
import 'package:flutter/foundation.dart';

class RankingViewController {

  RankingApi api = RankingApi.getInstance();
  EasterEggApi easterEggApi = EasterEggApi.getInstance();
  late RankingWidgetState? view;
  RankingViewContent viewContent = RankingViewContent();

  void onInit(viewInstance) async {
    view = viewInstance;
    await _prepareApi();
    _fillRanking();
  }

  void onShake() {
    print('shaking');
    view!.makeShit();
    easterEggApi.postEasterEgg(EasterEggApi.shakeKey);
  }

  void onRankingItemTap(String position) {
    int intPosition = int.parse(position);
    if(intPosition == 1) {
      view!.playChampionSong();
      easterEggApi.postEasterEgg(EasterEggApi.rankingOneKey);
    } else if(intPosition == viewContent.rankingItems.length) {
      view!.playLoserSong();
      easterEggApi.postEasterEgg(EasterEggApi.rankingLastKey);
    }
  }

  Future _prepareApi() async {
    await api.initialize();
    await easterEggApi.initialize();
  }

  void _fillRanking() {
    api.getRanking().then((ranking) {
      viewContent = RankingViewContent.fromApiModel(ranking);
      view!.update(viewContent);
    }, onError: (error) {
      if (kDebugMode) {
        print(error);
      }
    });
  }

  void onDispose() {
    view = null;
  }

  onSortSelected(int id) {
    viewContent.selectSort(id);
    view!.update(viewContent);
  }
}