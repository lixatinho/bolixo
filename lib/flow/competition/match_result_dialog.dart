import 'package:bolixo/api/competition/competition_api_interface.dart';
import 'package:bolixo/api/model/match_model.dart';
import 'package:bolixo/ui/shared/loading_widget.dart';
import 'package:bolixo/ui/shared/score_stepper.dart';
import 'package:bolixo/ui/theme/bolixo_colors.dart';
import 'package:bolixo/ui/theme/bolixo_typography.dart';
import 'package:flutter/material.dart';

class MatchResultDialog extends StatefulWidget {
  final MatchModel match;
  final VoidCallback onSaved;

  const MatchResultDialog({
    Key? key,
    required this.match,
    required this.onSaved,
  }) : super(key: key);

  @override
  _MatchResultDialogState createState() => _MatchResultDialogState();
}

class _MatchResultDialogState extends State<MatchResultDialog> {
  final CompetitionApi _api = CompetitionApi.getInstance();
  late int _homeScore;
  late int _awayScore;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _homeScore = widget.match.homeScore ?? 0;
    _awayScore = widget.match.awayScore ?? 0;
  }

  void _save() async {
    setState(() => _isSaving = true);

    widget.match.homeScore = _homeScore;
    widget.match.awayScore = _awayScore;

    try {
      await _api.initialize();
      await _api.updateMatchResult(widget.match);
      if (mounted) {
        Navigator.of(context).pop();
        widget.onSaved();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Resultado salvo e pontos calculados!")),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erro ao salvar resultado")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: BolixoColors.surfaceElevated,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text("Cadastrar Placar Final", style: BolixoTypography.titleLarge),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTeamCol(widget.match.home?.abbreviation ?? "Casa", _homeScore, (v) => setState(() => _homeScore = v)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text("x", style: BolixoTypography.headlineMedium.copyWith(color: BolixoColors.textTertiary)),
              ),
              _buildTeamCol(widget.match.away?.abbreviation ?? "Fora", _awayScore, (v) => setState(() => _awayScore = v)),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Cancelar", style: BolixoTypography.bodyMedium.copyWith(color: BolixoColors.textTertiary)),
        ),
        _isSaving
            ? const SizedBox(width: 24, height: 24, child: BolixoLoadingBall(size: 20))
            : ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: BolixoColors.accentGreen),
                onPressed: _save,
                child: Text("Salvar", style: BolixoTypography.labelLarge.copyWith(color: BolixoColors.backgroundPrimary)),
              ),
      ],
    );
  }

  Widget _buildTeamCol(String name, int score, ValueChanged<int> onChanged) {
    return Column(
      children: [
        Text(name, style: BolixoTypography.bodySmall),
        const SizedBox(height: 8),
        ScoreStepper(value: score, onChanged: onChanged),
      ],
    );
  }
}

void showMatchResultDialog(BuildContext context, MatchModel match, VoidCallback onSaved) {
  showDialog(
    context: context,
    builder: (context) => MatchResultDialog(match: match, onSaved: onSaved),
  );
}
