import 'package:bolixo/flow/bets/bet_item_view.dart';
import 'package:bolixo/flow/bets/bet_view_content.dart';
import 'package:bolixo/flow/bets/bets_viewcontroller.dart';
import 'package:bolixo/ui/shared/loading_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:bolixo/ui/theme/bolixo_colors.dart';
import 'package:bolixo/ui/theme/bolixo_typography.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../ui/select_date_widget.dart';
import 'bet_view_item_view.dart';

class BetsWidget extends StatefulWidget {
  final int? competitionId;
  const BetsWidget({super.key, this.competitionId});

  @override
  State<StatefulWidget> createState() => BetsWidgetState();
}

class BetsWidgetState extends State<BetsWidget> {
  List<BetsInDayViewContent> betsByDay = [];
  List<BetsByBolaoAndMatchViewContent> betsByBolaoAndMatch = [];
  int dateIndex = 0;
  bool isLoading = true;
  bool isSaving = false;
  BetsViewController viewController = BetsViewController();

  @override
  initState() {
    super.initState();
    viewController.onInit(this, competitionId: widget.competitionId);
  }

  @override
  void didUpdateWidget(covariant BetsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.competitionId != widget.competitionId) {
      setState(() {
        isLoading = true;
      });
      viewController.onInit(this, competitionId: widget.competitionId);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const LoadingWidget();
    }

    if (betsByDay.isEmpty) {
      return Container(
        color: BolixoColors.backgroundPrimary,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.sentiment_dissatisfied, size: 64, color: BolixoColors.textSecondary),
              const SizedBox(height: 16),
              Text(
                "Nenhum jogo disponível.",
                style: BolixoTypography.titleMedium.copyWith(color: BolixoColors.textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                "Aguarde o administrador cadastrar as partidas.",
                style: BolixoTypography.bodyMedium.copyWith(color: BolixoColors.textSecondary),
              ),
            ],
          ),
        ),
      );
    }

    final content = Column(children: [
        // Date selector
        SelectDateWidget(
          viewContent: DateSelectionViewContent.from(
              betsByDay.map((e) => e.date).toList(), dateIndex),
          onTapCallback: (int index) => viewController.onDateChanged(index),
          isLoading: isSaving,
        ),
        // Score overview bar
        scoreOverview(),
        // Bet cards list
        Expanded(
          child: Stack(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final bets = betsByDay[dateIndex].betList;
                  const double minCardWidth = 340;
                  const double spacing = 12;
                  final columns = (constraints.maxWidth / (minCardWidth + spacing)).floor().clamp(1, 4);

                  final bottomPadding = 90 + MediaQuery.of(context).padding.bottom;

                  if (columns <= 1) {
                    return ListView.separated(
                      padding: EdgeInsets.fromLTRB(16, 12, 16, bottomPadding),
                      itemCount: bets.length,
                      itemBuilder: (context, index) => _wrapShimmer(_buildBetCard(index)),
                      separatorBuilder: (_, __) => const SizedBox(height: spacing),
                    );
                  }

                  return GridView.builder(
                    padding: EdgeInsets.fromLTRB(16, 12, 16, bottomPadding),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: spacing,
                      mainAxisSpacing: spacing,
                      childAspectRatio: 1.85,
                    ),
                    itemCount: bets.length,
                    itemBuilder: (context, index) => Center(child: _wrapShimmer(_buildBetCard(index))),
                  );
                },
              ),
              if (!isSaving)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 20 + MediaQuery.of(context).padding.bottom,
                  child: Center(
                    child: Material(
                      color: BolixoColors.gold,
                      borderRadius: BorderRadius.circular(14),
                      elevation: 4,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () => viewController.saveBets(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.save, color: BolixoColors.backgroundPrimary, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Salvar Palpites',
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: BolixoColors.backgroundPrimary,
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
      ]);

    return Container(
      color: BolixoColors.backgroundPrimary,
      child: isSaving ? IgnorePointer(child: content) : content,
    );
  }


  Widget _wrapShimmer(Widget child) {
    if (!isSaving) return child;
    return Shimmer.fromColors(
      baseColor: BolixoColors.surfaceCard,
      highlightColor: BolixoColors.surfaceElevated,
      child: child,
    );
  }

  Widget _buildBetCard(int index) {
    return GestureDetector(
      onTap: () {
        if (betsByDay[dateIndex]
                .betList[index]
                .model
                .match
                ?.matchDate
                .isBefore(DateTime.now().toUtc()) ==
            true) {
          viewController.getBetsByMatch(
              betsByDay[dateIndex].betList[index].model.match?.id);
        }
      },
      child: BetItemView(
        bet: betsByDay[dateIndex].betList[index],
        homeGoalsChanged: (goals) =>
            viewController.onGoalsTeam1Changed(index, goals),
        awayGoalsChanged: (goals) =>
            viewController.onGoalsTeam2Changed(index, goals),
        onResultSaved: () => viewController.onInit(this, competitionId: widget.competitionId),
      ),
    );
  }

  @override
  void dispose() {
    viewController.onDispose();
    super.dispose();
  }

  void update(List<BetsInDayViewContent> newBets) {
    if (!mounted) return;
    setState(() {
      betsByDay = newBets;
      isLoading = false;
    });
  }

  void updateViewBets(List<BetsByBolaoAndMatchViewContent> newBets) {
    if (!mounted) return;
    setState(() {
      betsByBolaoAndMatch = newBets;
      isLoading = false;
    });
  }

  Widget scoreOverview() {
    final currentDay = betsByDay[dateIndex];
    final String phase = currentDay.betList.isNotEmpty
        ? currentDay.betList[0].type
        : "N/A";

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
              phase,
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
                  "${currentDay.totalScore}/${currentDay.maxScore} pts",
                  style: BolixoTypography.bodySmall.copyWith(
                    color: BolixoColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: currentDay.accuracy,
                    backgroundColor: BolixoColors.white8,
                    valueColor: const AlwaysStoppedAnimation<Color>(BolixoColors.accentBlue),
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
    if (!mounted) return;
    setState(() {
      dateIndex = newDateIndex;
    });
  }

  void updateIsLoading(bool newIsLoadingValue) {
    if (!mounted) return;
    setState(() {
      isLoading = newIsLoadingValue;
    });
  }

  void updateIsSaving(bool value) {
    if (!mounted) return;
    setState(() {
      isSaving = value;
    });
  }

  void showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: BolixoColors.gold, fontWeight: FontWeight.w600),
        textAlign: TextAlign.center,
      ),
      backgroundColor: BolixoColors.backgroundPrimary,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height * 0.4,
        left: 40,
        right: 40,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 2),
    ));
  }

  void showBetsByMatch() {
    if (!mounted) return;
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
