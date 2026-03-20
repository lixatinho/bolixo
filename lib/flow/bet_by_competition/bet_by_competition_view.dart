import 'package:bolixo/api/model/bolao_model.dart';
import 'package:bolixo/flow/bet_by_competition/bet_by_competition_viewcontroller.dart';
import 'package:bolixo/ui/home.dart';
import 'package:bolixo/ui/shared/loading_widget.dart';
import 'package:bolixo/ui/theme/bolixo_colors.dart';
import 'package:bolixo/ui/theme/bolixo_typography.dart';
import 'package:flutter/material.dart';

class BetByCompetitionView extends StatefulWidget {
  const BetByCompetitionView({super.key});

  @override
  State<BetByCompetitionView> createState() => BetByCompetitionViewState();
}

class BetByCompetitionViewState extends State<BetByCompetitionView> {
  final BetByCompetitionViewController _controller = BetByCompetitionViewController();
  List<BolaoModel> _boloesWithCompetitions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller.onInit(this);
  }

  void updateCompetitions(List<BolaoModel> list) {
    if (mounted) {
      setState(() {
        _boloesWithCompetitions = list;
        _isLoading = false;
      });
    }
  }

  void navigateToBets() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const Home(title: 'Bolixo', initialIndex: 0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BolixoColors.backgroundPrimary,
      appBar: AppBar(
        title: const Text("Palpites por Competição"),
        backgroundColor: BolixoColors.deepPlum,
      ),
      body: _isLoading
        ? const Center(child: LoadingWidget())
        : _buildList(),
    );
  }

  Widget _buildList() {
    if (_boloesWithCompetitions.isEmpty) {
      return Center(
        child: Text(
          "Nenhuma competição encontrada nos seus bolões.",
          style: BolixoTypography.bodyLarge,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _boloesWithCompetitions.length,
      itemBuilder: (context, index) {
        final bolao = _boloesWithCompetitions[index];
        final competition = bolao.competition!;
        return Card(
          color: BolixoColors.surfaceCard,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: InkWell(
            onTap: () => _controller.onCompetitionSelected(bolao),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: BolixoColors.royalPurple,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.sports_soccer, color: BolixoColors.accentCyan, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          competition.name ?? "Competição",
                          style: BolixoTypography.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Bolão: ${bolao.name}",
                          style: BolixoTypography.bodySmall.copyWith(color: BolixoColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: BolixoColors.white15, size: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.onDispose();
    super.dispose();
  }
}
