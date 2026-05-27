import 'package:shimmer/shimmer.dart';
import 'package:bolixo/api/model/user_model.dart';
import 'package:bolixo/flow/auth/auth_service.dart';
import 'package:bolixo/flow/competition/match_result_dialog.dart';
import 'package:bolixo/ui/shared/score_stepper.dart';
import 'package:bolixo/ui/shared/team_flag.dart';
import 'package:bolixo/ui/theme/bolixo_colors.dart';
import 'package:bolixo/ui/theme/bolixo_typography.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'bet_view_content.dart';

class BetItemView extends StatelessWidget {
  final BetViewContent bet;
  final Function homeGoalsChanged;
  final Function awayGoalsChanged;
  final VoidCallback? onResultSaved;

  const BetItemView({
    Key? key,
    required this.bet,
    required this.homeGoalsChanged,
    required this.awayGoalsChanged,
    this.onResultSaved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isAdmin = AuthService().repository.getRole() == UserRole.ADMIN;
    final showSaveButton = isAdmin && bet.model.match != null && onResultSaved != null;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: showSaveButton ? 12 : 16),
      decoration: BoxDecoration(
        color: BolixoColors.surfaceCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: BolixoColors.white6, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Home team
                teamColumn(bet.homeTeam),

                scoreArea(bet.homeTeam, homeGoalsChanged, true),

                // Middle
                Column(
                  children: [
                    betScoredPoints(),
                    versusText(),
                    dateText(bet.date),
                  ],
                ),

                scoreArea(bet.awayTeam, awayGoalsChanged, false),

                // Away team
                teamColumn(bet.awayTeam),
              ],
            ),
          ),
          if (showSaveButton)
            TextButton.icon(
              onPressed: () {
                if (onResultSaved != null) {
                  showMatchResultDialog(context, bet.model.match!, onResultSaved!);
                }
              },
              icon: const Icon(Icons.edit_note, color: BolixoColors.textSecondary, size: 16),
              label: const Text(
                "Incluir Resultado",
                style: TextStyle(color: BolixoColors.textSecondary, fontSize: 12, fontWeight: FontWeight.bold),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                minimumSize: const Size(0, 32),
              ),
            ),
        ],
      ),
    );
  }

  Widget scoreArea(TeamViewContent team, Function callback, bool isHomeTeam) {
    final initialValue = int.tryParse(team.scoreBet);
    return Padding(
      padding: EdgeInsets.only(
        left: isHomeTeam ? 16 : 24,
        right: !isHomeTeam ? 16 : 24,
      ),
      child: bet.isBetEnabled
          ? ScoreStepper(
              value: initialValue,
              onChanged: (v) => callback(v.toString()),
              enabled: bet.isBetEnabled,
            )
          : SizedBox(
              width: 48,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (team.scoreBet.isNotEmpty)
                    Tooltip(
                      message: bet.savedBetTooltip,
                      child: Text(
                        team.scoreBet,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: BolixoColors.textPrimary,
                        ),
                      ),
                    ),
                  if (team.actualScore.isNotEmpty)
                    Tooltip(
                      message: bet.scoreTooltip,
                      child: Text(
                        team.actualScore,
                        style: BolixoTypography.bodySmall.copyWith(
                          color: BolixoColors.textTertiary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Widget teamColumn(TeamViewContent team) {
    return Tooltip(
      message: team.tooltip,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 4, right: 4),
            child: TeamFlag(flagUrl: team.flagUrl, radius: 20),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              team.name,
              style: BolixoTypography.bodySmall.copyWith(
                color: BolixoColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget versusText() {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
      child: Text(
        'X',
        style: GoogleFonts.inter(
          color: BolixoColors.textTertiary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget dateText(DateViewContent? dateViewContent) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 2, bottom: 4),
      child: Text(
        dateViewContent?.value ?? "",
        style: GoogleFonts.inter(
          color: BolixoColors.textPrimary,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget betScoredPoints() {
    const double vPadding = 4;
    const double hPadding = 10;
    return Visibility(
      visible: bet.score.value.isNotEmpty,
      child: Tooltip(
        message: bet.earnedPointsTooltip,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: vPadding, horizontal: hPadding),
          decoration: BoxDecoration(
            color: bet.score.color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            bet.score.value,
            style: GoogleFonts.inter(
              color: bet.score.color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

/// Shimmer skeleton that mirrors BetItemView layout exactly.
class BetItemSkeleton extends StatelessWidget {
  const BetItemSkeleton({super.key});

  Widget _box(double w, double h, {double r = 8}) => Container(
    width: w, height: h,
    decoration: BoxDecoration(color: BolixoColors.surfaceCard, borderRadius: BorderRadius.circular(r)),
  );

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: BolixoColors.surfaceCard,
      highlightColor: BolixoColors.surfaceElevated,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: BolixoColors.surfaceCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: BolixoColors.white6, width: 1),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Home team
              Column(children: [
                _box(40, 40, r: 10),
                const SizedBox(height: 6),
                _box(30, 10),
              ]),
              // Home stepper
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 24),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  _box(48, 14, r: 4),
                  const SizedBox(height: 4),
                  _box(48, 28, r: 6),
                  const SizedBox(height: 4),
                  _box(48, 14, r: 4),
                ]),
              ),
              // Middle
              Column(children: [
                _box(14, 14, r: 4),
                const SizedBox(height: 8),
                _box(36, 10),
              ]),
              // Away stepper
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 16),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  _box(48, 14, r: 4),
                  const SizedBox(height: 4),
                  _box(48, 28, r: 6),
                  const SizedBox(height: 4),
                  _box(48, 14, r: 4),
                ]),
              ),
              // Away team
              Column(children: [
                _box(40, 40, r: 10),
                const SizedBox(height: 6),
                _box(30, 10),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
