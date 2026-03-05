import 'package:bolixo/api/competition/competition_api_interface.dart';
import 'package:bolixo/api/model/competition_model.dart';
import 'package:bolixo/api/model/match_model.dart';
import 'package:bolixo/api/model/team_model.dart';
import 'package:bolixo/ui/shared/app_elevated_button.dart';
import 'package:bolixo/ui/theme/bolixo_colors.dart';
import 'package:bolixo/ui/theme/bolixo_typography.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditMatchesView extends StatefulWidget {
  final CompetitionModel competition;
  const EditMatchesView({Key? key, required this.competition}) : super(key: key);

  @override
  _EditMatchesViewState createState() => _EditMatchesViewState();
}

class _EditMatchesViewState extends State<EditMatchesView> {
  final CompetitionApi _api = CompetitionApi.getInstance();
  List<MatchModel> _matches = [];
  List<TeamModel> _competitionTeams = [];
  bool _isLoading = true;
  bool _isSaving = false;

  int? _matchIndexToResult;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    await _api.initialize();
    _api.getMatchesByCompetition(widget.competition.id!).then((matches) {
      setState(() {
        _competitionTeams = widget.competition.teams ?? [];
        _matches = matches;
        _isLoading = false;
      });
    }).catchError((e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Erro ao carregar partidas")));
    });
  }

  void _addMatch() {
    setState(() {
      _matches.add(MatchModel(
        matchDate: DateTime.now(),
        type: 1,
      ));
    });
  }

  void _saveAllMatches() async {
    setState(() => _isSaving = true);
    _api.saveMatches(widget.competition.id!, _matches).then((_) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Partidas salvas!")));
      _fetchData();
    }).catchError((e) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Erro ao salvar partidas")));
    });
  }

  void _saveMatchResult(MatchModel match) async {
    if (match.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Salve a estrutura da partida antes de cadastrar o resultado")));
      return;
    }

    setState(() => _isSaving = true);
    _api.updateMatchResult(match).then((_) {
      setState(() {
        _isSaving = false;
        _matchIndexToResult = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Resultado salvo!")));
      _fetchData();
    }).catchError((e) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Erro ao salvar resultado")));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BolixoColors.backgroundPrimary,
      appBar: AppBar(
        title: Text("Partidas: ${widget.competition.name}", style: const TextStyle(color: Colors.white, fontSize: 16)),
        backgroundColor: BolixoColors.deepPlum,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: BolixoColors.accentGreen))
          : Column(
              children: [
                _buildTeamsRow(),
                const Divider(color: BolixoColors.white6, height: 1),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _matches.length,
                    itemBuilder: (context, index) => _buildMatchItem(index),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _addMatch,
                          icon: const Icon(Icons.add, color: BolixoColors.accentGreen),
                          label: const Text("Nova Partida", style: TextStyle(color: BolixoColors.accentGreen)),
                          style: OutlinedButton.styleFrom(side: const BorderSide(color: BolixoColors.accentGreen)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _isSaving
                        ? const CircularProgressIndicator(color: BolixoColors.accentGreen)
                        : SizedBox(
                            width: double.infinity,
                            child: AppElevatedButton(onPressedCallback: _saveAllMatches, text: "Salvar Estrutura de Partidas"),
                          ),
                    ],
                  ),
                )
              ],
            ),
    );
  }

  Widget _buildTeamsRow() {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: BolixoColors.surfaceElevated,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _competitionTeams.length,
        itemBuilder: (context, index) {
          final team = _competitionTeams[index];
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Draggable<TeamModel>(
              data: team,
              feedback: _buildTeamAvatar(team, isDragging: true),
              childWhenDragging: _buildTeamAvatar(team, opacity: 0.5),
              child: Column(
                children: [
                  _buildTeamAvatar(team),
                  const SizedBox(height: 4),
                  Text(team.abbreviation ?? "", style: BolixoTypography.bodySmall),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMatchItem(int index) {
    final match = _matches[index];
    final df = DateFormat('dd/MM HH:mm');
    bool isEditingResult = _matchIndexToResult == index;
    bool hasResult = match.homeScore != null && match.awayScore != null;

    return Card(
      color: BolixoColors.surfaceElevated,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Home Team
                Expanded(
                  child: Column(
                    children: [
                      _buildTeamDropZone(match, true),
                      if (hasResult && !isEditingResult)
                        Text("${match.homeScore}", style: const TextStyle(color: BolixoColors.accentGreen, fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                // VS
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text("VS", style: TextStyle(fontWeight: FontWeight.bold, color: hasResult ? BolixoColors.accentGreen : Colors.white, fontSize: 16)),
                ),
                // Away Team
                Expanded(
                  child: Column(
                    children: [
                      _buildTeamDropZone(match, false),
                      if (hasResult && !isEditingResult)
                        Text("${match.awayScore}", style: const TextStyle(color: BolixoColors.accentGreen, fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(color: BolixoColors.white6),
            if (!isEditingResult) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: TextEditingController(text: match.type?.toString() ?? "")..selection = TextSelection.fromPosition(TextPosition(offset: (match.type?.toString() ?? "").length)),
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Fase (Tipo)", labelStyle: TextStyle(color: Colors.grey, fontSize: 12)),
                      onChanged: (v) => match.type = int.tryParse(v),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: InkWell(
                      onTap: () => _editMatchDate(match),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Data/Hora", style: TextStyle(color: Colors.grey, fontSize: 10)),
                          const SizedBox(height: 4),
                          Text(df.format(match.matchDate), style: const TextStyle(color: Colors.white, fontSize: 13)),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.analytics_outlined, color: BolixoColors.accentGreen, size: 22),
                    onPressed: () => setState(() => _matchIndexToResult = index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent, size: 22),
                    onPressed: () => setState(() => _matches.removeAt(index)),
                  )
                ],
              ),
            ] else ...[
              const Text("Cadastrar Placar Final", style: TextStyle(color: BolixoColors.accentGreen, fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildScoreField(match.homeScore, (v) => match.homeScore = int.tryParse(v)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text("x", style: TextStyle(color: Colors.white, fontSize: 20)),
                  ),
                  _buildScoreField(match.awayScore, (v) => match.awayScore = int.tryParse(v)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => setState(() => _matchIndexToResult = null),
                    child: const Text("Cancelar", style: TextStyle(color: Colors.grey)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: BolixoColors.accentGreen),
                    onPressed: () => _saveMatchResult(match),
                    child: const Text("Salvar e Calcular", style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ],
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildScoreField(int? initialValue, Function(String) onChanged) {
    return SizedBox(
      width: 60,
      child: TextField(
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          hintText: "0",
          hintStyle: const TextStyle(color: Colors.grey),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: BolixoColors.accentGreen.withOpacity(0.5))),
        ),
        controller: TextEditingController(text: initialValue?.toString() ?? ""),
        onChanged: onChanged,
      ),
    );
  }

  void _editMatchDate(MatchModel match) async {
    final date = await showDatePicker(context: context, initialDate: match.matchDate, firstDate: DateTime(2020), lastDate: DateTime(2030));
    if (date != null) {
      final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(match.matchDate));
      if (time != null) {
        setState(() {
          match.matchDate = DateTime(date.year, date.month, date.day, time.hour, time.minute);
        });
      }
    }
  }

  Widget _buildTeamDropZone(MatchModel match, bool isHome) {
    final selectedTeam = isHome ? match.home : match.away;
    return DragTarget<TeamModel>(
      onWillAccept: (data) => true,
      onAccept: (team) {
        setState(() {
          if (isHome) match.home = team; else match.away = team;
        });
      },
      builder: (context, candidateData, rejectedData) {
        return Column(
          children: [
            _buildTeamAvatar(selectedTeam),
            const SizedBox(height: 4),
            Text(
              selectedTeam?.name ?? (isHome ? "Casa" : "Fora"),
              textAlign: TextAlign.center,
              style: TextStyle(color: selectedTeam == null ? Colors.grey : Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
      },
    );
  }

  Widget _buildTeamAvatar(TeamModel? team, {bool isDragging = false, double opacity = 1.0}) {
    return Opacity(
      opacity: opacity,
      child: Material(
        color: Colors.transparent,
        child: CircleAvatar(
          radius: isDragging ? 24 : 20,
          backgroundColor: BolixoColors.backgroundPrimary,
          child: team != null
            ? _buildTeamFlag(team)
            : const Icon(Icons.add, color: Colors.grey, size: 16),
        ),
      ),
    );
  }

  Widget _buildTeamFlag(TeamModel team) {
    String assetPath = "assets/images/teams/${team.abbreviation}.png";
    return ClipOval(
      child: Image.asset(
        assetPath,
        width: 40,
        height: 40,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.sports_soccer, color: BolixoColors.accentGreen),
      ),
    );
  }
}
