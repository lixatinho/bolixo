import 'package:bolixo/api/competition/competition_api_interface.dart';
import 'package:bolixo/api/model/match_model.dart';
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
  late TextEditingController _homeController;
  late TextEditingController _awayController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _homeController = TextEditingController(text: widget.match.homeScore?.toString() ?? "");
    _awayController = TextEditingController(text: widget.match.awayScore?.toString() ?? "");
  }

  @override
  void dispose() {
    _homeController.dispose();
    _awayController.dispose();
    super.dispose();
  }

  void _save() async {
    setState(() => _isSaving = true);

    widget.match.homeScore = int.tryParse(_homeController.text);
    widget.match.awayScore = int.tryParse(_awayController.text);

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
              _buildTeamCol(widget.match.home?.abbreviation ?? "Casa", _homeController),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text("x", style: TextStyle(color: Colors.white, fontSize: 24)),
              ),
              _buildTeamCol(widget.match.away?.abbreviation ?? "Fora", _awayController),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancelar", style: TextStyle(color: Colors.grey)),
        ),
        _isSaving
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
            : ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: BolixoColors.accentGreen),
                onPressed: _save,
                child: const Text("Salvar", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
      ],
    );
  }

  Widget _buildTeamCol(String name, TextEditingController controller) {
    return Column(
      children: [
        Text(name, style: BolixoTypography.bodySmall),
        const SizedBox(height: 8),
        SizedBox(
          width: 60,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(
              hintText: "0",
              hintStyle: TextStyle(color: Colors.white24),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: BolixoColors.accentGreen)),
            ),
          ),
        ),
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
