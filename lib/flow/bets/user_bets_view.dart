import 'package:bolixo/flow/bets/bet_item_view.dart';
import 'package:bolixo/flow/bets/bet_view_content.dart';
import 'package:bolixo/flow/bets/user_bets_viewcontroller.dart';
import 'package:bolixo/ui/shared/gold_title.dart';
import 'package:bolixo/ui/shared/loading_widget.dart';
import 'package:bolixo/ui/theme/bolixo_colors.dart';
import 'package:bolixo/ui/theme/bolixo_typography.dart';
import 'package:flutter/material.dart';

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
        title: GoldTitle("Palpites de ${widget.userName}"),
        backgroundColor: BolixoColors.deepPlum,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: BolixoColors.textPrimary),
      ),
      backgroundColor: BolixoColors.backgroundPrimary,
      body: SafeArea(child: _buildBody()),
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
            "Nada para ver aqui...",
            textAlign: TextAlign.center,
            style: BolixoTypography.bodyLarge.copyWith(color: BolixoColors.textSecondary),
          ),
        ),
      );
    }

    return Column(children: [
      SelectDateWidget(
        viewContent: DateSelectionViewContent.from(
            betsByDay.map((e) => e.date).toList(), dateIndex),
        onTapCallback: (int index) => viewController.onDateChanged(index),
      ),
      Expanded(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bets = betsByDay[dateIndex].betList;
            const double minCardWidth = 340;
            const double spacing = 12;
            final columns = (constraints.maxWidth / (minCardWidth + spacing)).floor().clamp(1, 4);

            if (columns <= 1) {
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
                itemCount: bets.length,
                itemBuilder: (context, index) => _buildBetCard(index),
                separatorBuilder: (_, __) => const SizedBox(height: spacing),
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: spacing,
                mainAxisSpacing: spacing,
                childAspectRatio: 1.85,
              ),
              itemCount: bets.length,
              itemBuilder: (context, index) => Center(child: _buildBetCard(index)),
            );
          },
        ),
      ),
    ]);
  }

  Widget _buildBetCard(int index) {
    final bet = betsByDay[dateIndex].betList[index];
    bet.isBetEnabled = false;
    return BetItemView(
      bet: bet,
      homeGoalsChanged: (goals) {},
      awayGoalsChanged: (goals) {},
    );
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
