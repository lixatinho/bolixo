import 'package:bolixo/api/bolao/bolao_api_interface.dart';
import 'package:bolixo/api/model/competition_model.dart';
import 'package:bolixo/flow/bets/bets_view.dart';
import 'package:bolixo/ui/shared/app_bottom_nav.dart';
import 'package:bolixo/ui/shared/app_drawer.dart';
import 'package:bolixo/ui/shared/rules_dialog.dart';
import 'package:bolixo/ui/theme/bolixo_colors.dart';
import 'package:bolixo/ui/theme/bolixo_typography.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CompetitionsBetsView extends StatefulWidget {
  const CompetitionsBetsView({Key? key}) : super(key: key);

  @override
  _CompetitionsBetsViewState createState() => _CompetitionsBetsViewState();
}

class _CompetitionsBetsViewState extends State<CompetitionsBetsView> {
  final BolaoApi _api = BolaoApi.getInstance();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<CompetitionModel> _competitions = [];
  bool _isLoading = true;
  bool _isRedirecting = false;

  @override
  void initState() {
    super.initState();
    _fetchCompetitions();
  }

  Future<void> _fetchCompetitions() async {
    setState(() => _isLoading = true);
    await _api.initialize();
    try {
      final list = await _api.getActiveCompetitions();
      if (mounted) {
        setState(() {
          _competitions = list;
          _isLoading = false;
        });

        if (_competitions.length == 1 && !_isRedirecting) {
          _isRedirecting = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => CompetitionBetsDetailView(
                    competitionId: _competitions[0].id!,
                    competitionName: _competitions[0].name ?? "Palpites",
                    showDrawer: true,
                  ),
                  settings: const RouteSettings(name: '/competition_detail'),
                ),
              );
            }
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erro ao carregar competições ativas")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isRedirecting) {
      return const Scaffold(
        backgroundColor: BolixoColors.backgroundPrimary,
        body: Center(child: CircularProgressIndicator(color: BolixoColors.accentGreen)),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: BolixoColors.backgroundPrimary,
      appBar: AppBar(
        title: const Text("Palpites", style: TextStyle(color: Colors.white)),
        backgroundColor: BolixoColors.deepPlum,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          IconButton(
            onPressed: () => showRulesDialog(context),
            icon: const Icon(Icons.rule_outlined, color: Colors.white),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: BolixoColors.accentGreen))
          : RefreshIndicator(
              onRefresh: _fetchCompetitions,
              child: _competitions.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _competitions.length,
                      itemBuilder: (context, index) {
                        return _buildCompetitionCard(_competitions[index]);
                      },
                    ),
            ),
      bottomNavigationBar: const AppBottomNav(selectedIndex: 0),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.event_busy, size: 64, color: Colors.white38),
          const SizedBox(height: 16),
          Text(
            "Nenhuma competição ativa no momento.",
            style: BolixoTypography.bodyLarge.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildCompetitionCard(CompetitionModel comp) {
    final df = DateFormat('dd/MM/yyyy');
    return Card(
      color: BolixoColors.surfaceElevated,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CompetitionBetsDetailView(
                competitionId: comp.id!,
                competitionName: comp.name ?? "Palpites",
              ),
              settings: const RouteSettings(name: '/competition_detail'),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(comp.name ?? "Sem nome", style: BolixoTypography.titleLarge),
                    const SizedBox(height: 8),
                    Text(
                      "Período: ${comp.startDate != null ? df.format(comp.startDate!) : '-'} até ${comp.endDate != null ? df.format(comp.endDate!) : '-'}",
                      style: BolixoTypography.bodySmall.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: BolixoColors.accentGreen),
            ],
          ),
        ),
      ),
    );
  }
}

class CompetitionBetsDetailView extends StatelessWidget {
  final int competitionId;
  final String competitionName;
  final bool showDrawer;

  const CompetitionBetsDetailView({
    Key? key,
    required this.competitionId,
    required this.competitionName,
    this.showDrawer = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: BolixoColors.backgroundPrimary,
      appBar: AppBar(
        title: Text(competitionName, style: const TextStyle(color: Colors.white)),
        backgroundColor: BolixoColors.deepPlum,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: showDrawer
          ? IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => scaffoldKey.currentState?.openDrawer(),
            )
          : null,
        actions: [
          IconButton(
            onPressed: () => showRulesDialog(context),
            icon: const Icon(Icons.rule_outlined, color: Colors.white),
          ),
        ],
      ),
      drawer: showDrawer ? const AppDrawer() : null,
      body: BetsWidget(competitionId: competitionId),
      bottomNavigationBar: const AppBottomNav(selectedIndex: 0),
    );
  }
}
