import 'package:bolixo/flow/bets/bet_item_view.dart';
import 'package:bolixo/flow/bets/bet_view_content.dart';
import 'package:bolixo/flow/bets/user_bets_viewcontroller.dart';
import 'package:bolixo/ui/shared/loading_widget.dart';
import 'package:bolixo/ui/theme/bolixo_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../ui/select_date_widget.dart';

class UserBetsWidget extends StatefulWidget {
  final int userId;
  final String userName;

  const UserBetsWidget({super.key, required this.userId, required this.userName});

  @override
  State<StatefulWidget> createState() => UserBetsWidgetState();
}

class UserBetsWidgetState extends State<UserBetsWidget> {
  List<BetsInDayViewContent> betsByDay = [];
  int dateIndex = 0;
  bool isLoading = true;
  late UserBetsViewController viewController;

  @override
  initState() {
    super.initState();
    viewController = UserBetsViewController(userId: widget.userId);
    viewController.onInit(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Palpites de ${widget.userName}",
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: BolixoColors.textPrimary,
          ),
        ),
        backgroundColor: BolixoColors.backgroundSecondary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: BolixoColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: BolixoColors.backgroundPrimary,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const LoadingWidget();
    }

    if (betsByDay.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            "${widget.userName} ainda não realizou nenhum palpite!",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: BolixoColors.textSecondary,
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    return Column(children: [
      // Date selector
      SizedBox(
        height: 160,
        child: SelectDateWidget(
          viewContent: DateSelectionViewContent.from(
              betsByDay.map((e) => e.date).toList(), dateIndex),
          onTapCallback: (int index) => viewController.onDateChanged(index),
        ),
      ),
      // Bet cards list
      Expanded(
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          itemCount: betsByDay[dateIndex].betList.length,
          itemBuilder: (context, index) {
            final bet = betsByDay[dateIndex].betList[index];
            // Force bet to be disabled as it's viewing someone else's bets
            bet.isBetEnabled = false;
            return BetItemView(
              bet: bet,
              homeGoalsChanged: (goals) {},
              awayGoalsChanged: (goals) {},
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 12),
        ),
      ),
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    viewController.onDispose();
  }

  void update(List<BetsInDayViewContent> newBets) {
    setState(() {
      betsByDay = newBets;
      isLoading = false;
    });
  }

  void updateDate(int newDateIndex) {
    setState(() {
      dateIndex = newDateIndex;
    });
  }

  void updateIsLoading(bool newIsLoadingValue) {
    setState(() {
      isLoading = newIsLoadingValue;
    });
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
