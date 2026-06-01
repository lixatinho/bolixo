import 'package:bolixo/ui/shared/team_flag.dart';
import 'package:bolixo/ui/theme/bolixo_colors.dart';
import 'package:bolixo/ui/theme/bolixo_decorations.dart';
import 'package:bolixo/ui/theme/bolixo_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'bet_view_content.dart';

class BetViewItemView extends StatelessWidget {
  final BetsByBolaoAndMatchViewContent bet;

  BetViewItemView({Key? key, required this.bet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: BolixoColors.surfaceCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: BolixoColors.white6, width: 1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Home team
              Expanded(
                child: Column(children: [
                  teamFlag(bet.homeTeam.flagUrl),
                  teamName(bet.homeTeam.name, bet.homeTeam.tooltip),
                ]),
              ),

              betField(true),
              matchScoreAndBet(bet.homeTeam),

              // Middle - Fixed width to align columns
              SizedBox(
                width: 100,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    textCell(bet.model.user?.username),
                    versusText(),
                    betScoredPoints(),
                  ],
                ),
              ),

              betField(false),
              matchScoreAndBet(bet.awayTeam),

              // Away team
              Expanded(
                child: Column(children: [
                  teamFlag(bet.awayTeam.flagUrl),
                  teamName(bet.awayTeam.name, bet.awayTeam.tooltip),
                ]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget textCell(String? text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      alignment: Alignment.center,
      child: Text(
        text ?? "Username",
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: BolixoTypography.bodyMedium.copyWith(
          color: BolixoColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget betField(bool isHomeTeam) {
    return Visibility(
      visible: bet.isBetEnabled,
      child: SizedBox(
        width: 50,
        height: 48,
        child: TextField(
          keyboardType: TextInputType.number,
          decoration: BolixoDecorations.betInputDecoration,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
          ],
          maxLength: 3,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: BolixoColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget matchScoreAndBet(TeamViewContent team) {
    return Visibility(
      visible: !bet.isBetEnabled,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          betText(team.scoreBet),
          actualScoreText(team.actualScore),
        ],
      ),
    );
  }

  Widget betText(String text) {
    return SizedBox(
      width: 50,
      child: Center(
        child: Text(
          text.isEmpty ? "-" : text,
          style: BolixoTypography.bodyLarge.copyWith(
            color: BolixoColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget actualScoreText(String text) {
    return SizedBox(
      width: 50,
      child: Center(
        child: Text(
          text.isEmpty ? "-" : text,
          style: BolixoTypography.bodyMedium.copyWith(
            color: BolixoColors.textTertiary,
          ),
        ),
      ),
    );
  }

  Widget teamFlag(String flagUrl) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 4, right: 4),
      child: TeamFlag(flagUrl: flagUrl, radius: 20),
    );
  }

  Widget teamName(String name, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: Padding(
        padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
        child: Text(
          name,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: BolixoTypography.bodySmall.copyWith(
            color: BolixoColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget versusText() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2),
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

  Widget betScoredPoints() {
    return Visibility(
      visible: bet.score.value.isNotEmpty,
      child: Container(
        margin: const EdgeInsets.only(top: 4),
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
        decoration: BoxDecoration(
          color: bet.score.color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          bet.score.value,
          style: GoogleFonts.inter(
            color: bet.score.color,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
