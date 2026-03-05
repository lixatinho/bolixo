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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCompetitions();
  }

  void _fetchCompetitions() async {
    setState(() => _isLoading = true);
    await _api.initialize();
    _api.getAllCompetitions().then((list) {
      setState(() {
        _competitions = list;
        _isLoading = false;
      });
    }).catchError((error) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao carregar competições")),
      );
    });
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
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
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
                const SizedBox(width: 8),
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
              ],
            )
          ],
        ),
      ),
    );
  }
}
