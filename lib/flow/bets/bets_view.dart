import 'package:bolixo/flow/bets/bet_item_view.dart';
import 'package:bolixo/flow/bets/bet_view_content.dart';
import 'package:bolixo/flow/bets/bets_viewcontroller.dart';
import 'package:bolixo/ui/shared/loading_widget.dart';
import 'package:bolixo/ui/theme/bolixo_colors.dart';
import 'package:bolixo/ui/theme/bolixo_typography.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../ui/select_date_widget.dart';
import 'bet_view_item_view.dart';

class BetsWidget extends StatefulWidget {
  const BetsWidget({super.key});

  @override
  State<StatefulWidget> createState() => BetsWidgetState();
}

class BetsWidgetState extends State<BetsWidget> {
  List<BetsInDayViewContent> betsByDay = [];
  List<BetsByBolaoAndMatchViewContent> betsByBolaoAndMatch = [];
  int dateIndex = 0;
  bool isLoading = true;
  BetsViewController viewController = BetsViewController();

  @override
  initState() {
    super.initState();
    viewController.onInit(this);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const LoadingWidget();
    } else {
      return Container(
        color: BolixoColors.backgroundPrimary,
        child: Column(children: [
          // Date selector
          SizedBox(
            height: 160,
            child: SelectDateWidget(
              viewContent: DateSelectionViewContent.from(
                  betsByDay.map((e) => e.date).toList(), dateIndex),
              onTapCallback: (int index) => viewController.onDateChanged(index),
            ),
          ),
          // Score overview bar
          scoreOverview(),
          // Bet cards list
          Expanded(
            child: Stack(
              children: [
                ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
                  itemCount: betsByDay[dateIndex].betList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        if (betsByDay[dateIndex]
                                .betList[index]
                                .model
                                .match
                                ?.matchDate
                                .isBefore(DateTime.now().toUtc()) ==
                            true) {
                          viewController.getBetsByBolaoAndMatch(
                              betsByDay[dateIndex].betList[index].model.match?.id);
                        }
                      },
                      child: BetItemView(
                        bet: betsByDay[dateIndex].betList[index],
                        homeGoalsChanged: (goals) =>
                            viewController.onGoalsTeam1Changed(index, goals),
                        awayGoalsChanged: (goals) =>
                            viewController.onGoalsTeam2Changed(index, goals),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                ),
                // Save button - solid green at bottom
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 16,
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: BolixoColors.accentGreen,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => viewController.saveBets(),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.save, color: BolixoColors.textOnAccent, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Salvar Palpites',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: BolixoColors.textOnAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      );
    }
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

  void updateViewBets(List<BetsByBolaoAndMatchViewContent> newBets) {
    setState(() {
      betsByBolaoAndMatch = newBets;
      isLoading = false;
    });
  }

  Widget scoreOverview() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: BolixoColors.backgroundSecondary,
      child: Row(
        children: [
          // Phase badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: BolixoColors.electricViolet.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              betsByDay[dateIndex].betList[0].type,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: BolixoColors.textLink,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Score + progress
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${betsByDay[dateIndex].totalScore}/${betsByDay[dateIndex].maxScore} pts",
                  style: BolixoTypography.bodySmall.copyWith(
                    color: BolixoColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: betsByDay[dateIndex].accuracy,
                    backgroundColor: BolixoColors.white8,
                    valueColor: const AlwaysStoppedAnimation<Color>(BolixoColors.accentCyan),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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

  void showBetsByMatch() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: BolixoColors.backgroundSecondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (_, controller) {
            return ListView.builder(
              itemCount: betsByBolaoAndMatch.length,
              controller: controller,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                return BetViewItemView(bet: betsByBolaoAndMatch[index]);
              },
            );
          },
        );
      },
    );
  }
}
