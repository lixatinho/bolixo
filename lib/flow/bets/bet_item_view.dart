import 'package:bolixo/api/model/user_model.dart';
import 'package:bolixo/flow/auth/auth_service.dart';
import 'package:bolixo/flow/competition/match_result_dialog.dart';
import 'package:bolixo/ui/theme/bolixo_colors.dart';
import 'package:bolixo/ui/theme/bolixo_decorations.dart';
import 'package:bolixo/ui/theme/bolixo_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'bet_view_content.dart';

class BetItemView extends StatelessWidget {
  final BetViewContent bet;
  final Function homeGoalsChanged;
  final Function awayGoalsChanged;
  final VoidCallback? onResultSaved;

  final TextEditingController homeScoreTextFieldController;
  final TextEditingController awayScoreTextFieldController;

  BetItemView({
    Key? key,
    required this.bet,
    required this.homeGoalsChanged,
    required this.awayGoalsChanged,
    this.onResultSaved,
  })  : homeScoreTextFieldController = TextEditingController(text: bet.homeTeam.scoreBet),
        awayScoreTextFieldController = TextEditingController(text: bet.awayTeam.scoreBet),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final isAdmin = AuthService().repository.getRole() == UserRole.ADMIN;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BolixoColors.surfaceCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: BolixoColors.white6, width: 1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Home team
              Column(
                children: [
                  teamFlag(bet.homeTeam.flagUrl, bet.homeTeam.tooltip),
                  teamName(bet.homeTeam.name, bet.homeTeam.tooltip),
                ],
              ),

              betField(homeScoreTextFieldController, homeGoalsChanged, true),
              matchScoreAndBet(bet.homeTeam),

              // Middle
              Column(
                children: [
                  betScoredPoints(),
                  versusText(),
                  dateText(bet.date),
                ],
              ),

              betField(awayScoreTextFieldController, awayGoalsChanged, false),
              matchScoreAndBet(bet.awayTeam),

              // Away team
              Column(
                children: [
                  teamFlag(bet.awayTeam.flagUrl, bet.awayTeam.tooltip),
                  teamName(bet.awayTeam.name, bet.awayTeam.tooltip),
                ],
              ),
            ],
          ),
          if (isAdmin && bet.model.match != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextButton.icon(
                onPressed: () {
                  if (onResultSaved != null) {
                    showMatchResultDialog(context, bet.model.match!, onResultSaved!);
                  }
                },
                icon: const Icon(Icons.analytics_outlined, color: BolixoColors.accentGreen, size: 16),
                label: const Text(
                  "Inserir Resultado",
                  style: TextStyle(color: BolixoColors.accentGreen, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget betField(
    TextEditingController controller,
    Function callback,
    bool isHomeTeam,
  ) {
    double spaceBetweenTeams = 24;
    double space = 16;
    double marginLeft = isHomeTeam ? space : spaceBetweenTeams;
    double marginRight = !isHomeTeam ? space : spaceBetweenTeams;
    return Visibility(
      visible: bet.isBetEnabled,
      child: Tooltip(
        message: bet.betFieldTooltip,
        padding: EdgeInsets.only(left: marginLeft, right: marginRight),
        child: SizedBox(
          width: 48,
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
            controller: controller,
            onChanged: (goals) => callback(controller.text),
            enabled: bet.isBetEnabled,
          ),
        ),
      ),
    );
  }

  Widget matchScoreAndBet(TeamViewContent team) {
    return Visibility(
      visible: !bet.isBetEnabled,
      child: Column(
        children: [
          betText(team.scoreBet),
          actualScoreText(team.actualScore),
        ],
      ),
    );
  }

  Widget betText(String text) {
    return Visibility(
      visible: !bet.isBetEnabled && text.isNotEmpty,
      child: Tooltip(
        message: bet.savedBetTooltip,
        padding: const EdgeInsets.only(left: 4, right: 4),
        child: SizedBox(
          width: 50,
          child: Center(
            child: Text(
              text,
              style: BolixoTypography.bodyLarge.copyWith(
                color: BolixoColors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget actualScoreText(String text) {
    return Visibility(
      visible: !bet.isBetEnabled && text.isNotEmpty,
      child: Tooltip(
        message: bet.scoreTooltip,
        padding: const EdgeInsets.only(left: 4, right: 4),
        child: SizedBox(
          width: 50,
          child: Center(
            child: Text(
              text,
              style: BolixoTypography.bodyMedium.copyWith(
                color: BolixoColors.textTertiary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget teamFlag(String flagUrl, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: Padding(
        padding: const EdgeInsets.only(top: 8, left: 4, right: 4),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: BolixoColors.white10, width: 1.5),
          ),
          child: CircleAvatar(
            backgroundImage: flagUrl.isNotEmpty ? AssetImage(flagUrl) : null,
            backgroundColor: BolixoColors.surfaceCard,
            child: flagUrl.isEmpty ? const Icon(Icons.sports_soccer, color: Colors.white24) : null,
          ),
        ),
      ),
    );
  }

  Widget teamName(String name, String tooltip) {
    return Tooltip(
      padding: const EdgeInsets.only(top: 6),
      message: tooltip,
      child: Text(
        name,
        style: BolixoTypography.bodySmall.copyWith(
          color: BolixoColors.textSecondary,
        ),
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
      padding: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
      child: Text(
        dateViewContent?.value ?? "",
        style: GoogleFonts.inter(
          color: BolixoColors.textTertiary,
          fontSize: 11,
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
            color: bet.score.color.withOpacity(0.15),
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
