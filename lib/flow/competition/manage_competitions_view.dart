import 'package:bolixo/api/competition/competition_api_interface.dart';
import 'package:bolixo/api/model/competition_model.dart';
import 'package:bolixo/flow/competition/edit_competition_view.dart';
import 'package:bolixo/flow/competition/edit_matches_view.dart';
import 'package:bolixo/ui/theme/bolixo_colors.dart';
import 'package:bolixo/ui/theme/bolixo_typography.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ManageCompetitionsView extends StatefulWidget {
  const ManageCompetitionsView({Key? key}) : super(key: key);

  @override
  _ManageCompetitionsViewState createState() => _ManageCompetitionsViewState();
}

class _ManageCompetitionsViewState extends State<ManageCompetitionsView> {
  final CompetitionApi _api = CompetitionApi.getInstance();
  List<CompetitionModel> _competitions = [];
  Map<int, int> _matchCounts = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCompetitions();
  }

  void _fetchCompetitions() async {
    setState(() => _isLoading = true);
    await _api.initialize();

    try {
      final list = await _api.getAllCompetitions();
      final Map<int, int> counts = {};

      // Busca a quantidade de partidas para cada competição para validar a exclusão
      await Future.wait(list.map((comp) async {
        if (comp.id != null) {
          try {
            final matches = await _api.getMatchesByCompetition(comp.id!);
            counts[comp.id!] = matches.length;
          } catch (e) {
            counts[comp.id!] = 0;
          }
        }
      }));

      setState(() {
        _competitions = list;
        _matchCounts = counts;
        _isLoading = false;
      });
    } catch (error) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao carregar competições")),
      );
    }
  }

  void _deleteCompetition(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Excluir Competição"),
        content: const Text("Tem certeza que deseja excluir esta competição?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Excluir", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isLoading = true);
      _api.deleteCompetition(id).then((_) {
        _fetchCompetitions();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Competição excluída com sucesso")),
        );
      }).catchError((error) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao excluir competição: $error")),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BolixoColors.backgroundPrimary,
      appBar: AppBar(
        title: const Text("Gerenciar Competições", style: TextStyle(color: Colors.white)),
        backgroundColor: BolixoColors.deepPlum,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: BolixoColors.accentGreen))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _competitions.length,
              itemBuilder: (context, index) {
                final comp = _competitions[index];
                return _buildCompetitionCard(comp);
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: BolixoColors.accentGreen,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EditCompetitionView()),
          );
          if (result == true) _fetchCompetitions();
        },
      ),
    );
  }

  Widget _buildCompetitionCard(CompetitionModel comp) {
    final df = DateFormat('dd/MM/yyyy');
    final int matchCount = _matchCounts[comp.id] ?? 0;

    // Condições para excluir:
    // 1. Data de início nula ou futura
    // 2. Não possui nenhuma partida cadastrada
    final bool canDelete = (comp.startDate == null || comp.startDate!.isAfter(DateTime.now()))
        && matchCount == 0;

    return Card(
      color: BolixoColors.surfaceElevated,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(comp.name ?? "", style: BolixoTypography.titleLarge),
            const SizedBox(height: 8),
            Text(
              "Início: ${comp.startDate != null ? df.format(comp.startDate!) : '-'} | Fim: ${comp.endDate != null ? df.format(comp.endDate!) : '-'}",
              style: BolixoTypography.bodySmall,
            ),
            Text(
              "Partidas cadastradas: $matchCount",
              style: BolixoTypography.bodySmall.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              alignment: WrapAlignment.end,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditCompetitionView(competition: comp)),
                    );
                    if (result == true) _fetchCompetitions();
                  },
                  icon: const Icon(Icons.edit, color: BolixoColors.accentGreen),
                  label: const Text("Editar", style: TextStyle(color: BolixoColors.accentGreen)),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditMatchesView(competition: comp)),
                    );
                  },
                  icon: const Icon(Icons.sports_soccer, color: BolixoColors.accentGreen),
                  label: const Text("Partidas", style: TextStyle(color: BolixoColors.accentGreen)),
                ),
                if (canDelete && comp.id != null)
                  TextButton.icon(
                    onPressed: () => _deleteCompetition(comp.id!),
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                    label: const Text("Excluir", style: TextStyle(color: Colors.redAccent)),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
