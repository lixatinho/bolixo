import 'package:flutter/widgets.dart';
import 'ranking_view_content.dart';

abstract class RankingViewContract {
  void update(RankingViewContent newViewContent);
  void makeShit();
  Future<void> playLoserSong();
  Future<void> playChampionSong();
  BuildContext get context;
  bool get mounted;
}
