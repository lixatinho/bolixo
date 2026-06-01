import 'package:bolixo/api/competition/competition_api_interface.dart';
import 'package:bolixo/api/model/match_model.dart';
import 'package:bolixo/ui/shared/skeleton_loading.dart';
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

  void _confirmReset() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: BolixoColors.surfaceElevated,
        title: const Text("Zerar Placar", style: TextStyle(color: BolixoColors.textPrimary)),
        content: const Text(
          "Tem certeza que deseja zerar o placar desta partida? Os pontos dos usuários serão recalculados.",
          style: TextStyle(color: BolixoColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _reset();
            },
            child: const Text("Zerar", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  void _reset() async {
    if (widget.match.id == null) return;
    setState(() => _isSaving = true);
    try {
      await _api.initialize();
      await _api.resetMatchResult(widget.match.id!);
      if (mounted) {
        Navigator.of(context).pop();
        widget.onSaved();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Resultado zerado com sucesso!")),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erro ao zerar resultado")),
        );
      }
    }
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
    final hasResult = widget.match.homeScore != null || widget.match.awayScore != null;

    return AlertDialog(
      backgroundColor: BolixoColors.surfaceElevated,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              "Placar Final",
              style: BolixoTypography.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
          if (hasResult)
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: _isSaving ? null : _confirmReset,
                icon: const Icon(Icons.restart_alt, color: Colors.redAccent, size: 22),
                tooltip: "Zerar Scores",
                visualDensity: VisualDensity.compact,
              ),
            ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTeamCol(widget.match.home?.abbreviation ?? "Casa", _homeScore, (v) => setState(() => _homeScore = v)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text("x", style: BolixoTypography.headlineMedium.copyWith(color: BolixoColors.textTertiary)),
              ),
              _buildTeamCol(widget.match.away?.abbreviation ?? "Fora", _awayScore, (v) => setState(() => _awayScore = v)),
            ],
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Cancelar", style: BolixoTypography.bodyMedium.copyWith(color: BolixoColors.textTertiary)),
        ),
        _isSaving
            ? const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: SkeletonLoading(type: SkeletonType.buttonInline),
                ),
              )
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: BolixoColors.accentBlue.withAlpha(30),
                  foregroundColor: BolixoColors.accentBlue,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _save,
                child: const Text("Salvar"),
              ),
      ],
    );
  }

  Widget _buildTeamCol(String name, int score, ValueChanged<int> onChanged) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(name, style: BolixoTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
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
