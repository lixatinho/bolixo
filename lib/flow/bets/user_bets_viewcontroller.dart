import 'package:bolixo/api/bet/bet_api_interface.dart';
import 'package:bolixo/flow/bets/bet_view_content.dart';
import 'package:bolixo/flow/bets/user_bets_view.dart';
import 'dart:developer';

class UserBetsViewController {
  late UserBetsWidgetState _state;
  final int userId;
  final BetApi _betApi = BetApi.getInstance();

  UserBetsViewController({required this.userId});

  void onInit(UserBetsWidgetState state) {
    _state = state;
    _loadUserBets();
  }

  Future<void> _loadUserBets() async {
    try {
      _state.updateIsLoading(true);
      final betsInDayApi = await _betApi.getBetsByUser(userId);
      log("Retorno da API (getBetsByUser): $betsInDayApi");

      final viewContentList = betsInDayApi
          .map((e) {
            try {
              return BetsInDayViewContent.fromApiModel(e);
            } catch (mapError, mapStack) {
              log("Erro ao mapear BetsInDayModel para BetsInDayViewContent", error: mapError, stackTrace: mapStack);
              rethrow;
            }
          })
          .toList()
          .cast<BetsInDayViewContent>();

      _state.update(viewContentList);
      _selectClosestDate(viewContentList);
    } catch (e, s) {
      log("Erro capturado no _loadUserBets", error: e, stackTrace: s);
      _state.updateIsLoading(false);
      _state.showMessage("Erro ao carregar palpites do usuário.");
    }
  }

  void _selectClosestDate(List<BetsInDayViewContent> viewContentList) {
    if (viewContentList.isEmpty) return;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    int selectedIndex = 0;
    bool found = false;

    for (int i = 0; i < viewContentList.length; i++) {
      final betDate = viewContentList[i].date;
      final betDay = DateTime(betDate.year, betDate.month, betDate.day);

      if (!betDay.isBefore(today)) {
        selectedIndex = i;
        found = true;
        break;
      }
    }

    if (!found) {
      selectedIndex = viewContentList.length - 1;
    }

    _state.updateDate(selectedIndex);
  }

  void onDateChanged(int index) {
    _state.updateDate(index);
  }

  void onDispose() {}
}
