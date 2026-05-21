import 'package:bolixo/api/competition/competition_api_interface.dart';
import 'package:bolixo/api/model/competition_model.dart';
import 'package:bolixo/api/model/match_model.dart';
import 'package:bolixo/api/model/team_model.dart';
import 'package:bolixo/ui/shared/app_elevated_button.dart';
import 'package:bolixo/ui/shared/loading_widget.dart';
import 'package:bolixo/ui/shared/score_stepper.dart';
import 'package:bolixo/ui/shared/team_flag.dart';
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

  // Filtros
  TeamModel? _selectedFilterTeam;
  int? _selectedFilterType;
  DateTime? _selectedFilterDate;
  final TextEditingController _typeFilterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void dispose() {
    _typeFilterController.dispose();
    super.dispose();
  }

  void _fetchData() async {
    await _api.initialize();
    _api.getMatchesByCompetition(widget.competition.id!).then((matches) {
      setState(() {
        _competitionTeams = List<TeamModel>.from(widget.competition.teams ?? []);
        _competitionTeams.sort((a, b) => (a.name ?? "").compareTo(b.name ?? ""));
        _matches = matches;
        _isLoading = false;
      });
    }).catchError((e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Erro ao carregar partidas")));
    });
  }

  List<MatchModel> get _filteredMatches {
    return _matches.where((match) {
      final teamMatch = _selectedFilterTeam == null ||
          match.home?.id == _selectedFilterTeam?.id ||
          match.away?.id == _selectedFilterTeam?.id;

      final typeMatch = _selectedFilterType == null || match.type == _selectedFilterType;

      final dateMatch = _selectedFilterDate == null ||
          (match.matchDate.year == _selectedFilterDate!.year &&
           match.matchDate.month == _selectedFilterDate!.month &&
           match.matchDate.day == _selectedFilterDate!.day);

      return teamMatch && typeMatch && dateMatch;
    }).toList();
  }

  void _addMatch() {
    setState(() {
      _clearFilters();
      _matches.insert(0, MatchModel(
        matchDate: DateTime.now(),
        type: 1,
      ));
      _matchIndexToResult = null;
    });
  }

  void _clearFilters() {
    setState(() {
      _selectedFilterTeam = null;
      _selectedFilterType = null;
      _selectedFilterDate = null;
      _typeFilterController.clear();
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
    final displayMatches = _filteredMatches;

    return Scaffold(
      backgroundColor: BolixoColors.backgroundPrimary,
      appBar: AppBar(
        title: Text("Partidas: ${widget.competition.name}", style: BolixoTypography.titleMedium),
        backgroundColor: BolixoColors.deepPlum,
        iconTheme: const IconThemeData(color: BolixoColors.textPrimary),
      ),
      body: _isLoading
          ? const Center(child: BolixoLoadingBall())
          : Column(
              children: [
                // Nova Área de Filtros mais visível
                Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    title: const Text("Filtros de Busca", style: TextStyle(color: BolixoColors.accentGreen, fontSize: 14, fontWeight: FontWeight.bold)),
                    leading: const Icon(Icons.filter_alt, color: BolixoColors.accentGreen),
                    collapsedBackgroundColor: BolixoColors.surfaceElevated,
                    backgroundColor: BolixoColors.surfaceElevated,
                    children: [
                      _buildFilterContent(),
                    ],
                  ),
                ),
                _buildTeamsRow(),
                const Divider(color: BolixoColors.white6, height: 1),
                Expanded(
                  child: displayMatches.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: displayMatches.length,
                        itemBuilder: (context, index) => _buildMatchItem(displayMatches[index]),
                      ),
                ),
              ],
            ),
      bottomNavigationBar: _isLoading ? null : Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: BolixoColors.backgroundPrimary,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                ? const BolixoLoadingBall(size: 32)
                : SizedBox(
                    width: double.infinity,
                    child: AppElevatedButton(onPressedCallback: _saveAllMatches, text: "Salvar Estrutura de Partidas"),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: [
          Row(
            children: [
              // Filtro de Time
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("TIME", style: BolixoTypography.labelSmall.copyWith(color: BolixoColors.textTertiary, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    _buildFilterDropdown<TeamModel>(
                      value: _selectedFilterTeam,
                      hint: "Selecionar Time",
                      items: _competitionTeams.map((t) => DropdownMenuItem(
                        value: t,
                        child: Text(t.name ?? "", style: BolixoTypography.bodySmall.copyWith(color: BolixoColors.textPrimary))
                      )).toList(),
                      onChanged: (v) => setState(() => _selectedFilterTeam = v),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Filtro de Tipo/Fase
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("FASE", style: BolixoTypography.labelSmall.copyWith(color: BolixoColors.textTertiary, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    TextField(
                      controller: _typeFilterController,
                      style: BolixoTypography.bodySmall.copyWith(color: BolixoColors.textPrimary),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Ex: 1",
                        hintStyle: const TextStyle(color: BolixoColors.textTertiary),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                        enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: BolixoColors.white10), borderRadius: BorderRadius.circular(8)),
                        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: BolixoColors.accentGreen), borderRadius: BorderRadius.circular(8)),
                      ),
                      onChanged: (v) => setState(() => _selectedFilterType = int.tryParse(v)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // Filtro de Data
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("DATA", style: BolixoTypography.labelSmall.copyWith(color: BolixoColors.textTertiary, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    InkWell(
                      onTap: _pickFilterDate,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: _selectedFilterDate != null ? BolixoColors.accentGreen : BolixoColors.white10),
                          borderRadius: BorderRadius.circular(8)
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_month, size: 16, color: BolixoColors.accentGreen),
                            const SizedBox(width: 8),
                            Text(
                              _selectedFilterDate == null ? "Filtrar por dia" : DateFormat('dd/MM/yyyy').format(_selectedFilterDate!),
                              style: TextStyle(color: _selectedFilterDate == null ? BolixoColors.textTertiary : BolixoColors.textPrimary, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_hasActiveFilters) ...[
                const SizedBox(width: 12),
                Padding(
                  padding: const EdgeInsets.only(top: 18),
                  child: TextButton.icon(
                    onPressed: _clearFilters,
                    icon: const Icon(Icons.clear_all, color: BolixoColors.error, size: 18),
                    label: const Text("LIMPAR", style: TextStyle(color: BolixoColors.error, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ),
              ]
            ],
          )
        ],
      ),
    );
  }

  void _pickFilterDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedFilterDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: BolixoColors.accentGreen,
              onPrimary: Colors.black,
              surface: BolixoColors.surfaceElevated,
              onSurface: BolixoColors.textPrimary,
            ),
          ),
          child: child!,
        );
      }
    );
    if (date != null) setState(() => _selectedFilterDate = date);
  }

  bool get _hasActiveFilters => _selectedFilterTeam != null || _selectedFilterType != null || _selectedFilterDate != null;

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 48, color: BolixoColors.textTertiary),
          const SizedBox(height: 16),
          Text("Nenhum jogo encontrado com estes filtros.", style: TextStyle(color: BolixoColors.textSecondary)),
          TextButton(onPressed: _clearFilters, child: const Text("Ver todos os jogos", style: TextStyle(color: BolixoColors.accentGreen))),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown<T>({required T? value, required String hint, required List<DropdownMenuItem<T>> items, required Function(T?) onChanged}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: value != null ? BolixoColors.accentGreen : BolixoColors.white10),
        borderRadius: BorderRadius.circular(8)
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          hint: Text(hint, style: const TextStyle(color: BolixoColors.textTertiary, fontSize: 12)),
          dropdownColor: BolixoColors.surfaceElevated,
          items: items,
          onChanged: onChanged,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: BolixoColors.accentGreen, size: 20),
          style: BolixoTypography.bodySmall.copyWith(color: BolixoColors.textPrimary),
        ),
      ),
    );
  }

  Widget _buildTeamsRow() {
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(vertical: 8),
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
                  Text(team.abbreviation ?? "", style: const TextStyle(color: BolixoColors.textSecondary, fontSize: 10)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMatchItem(MatchModel match) {
    final int originalIndex = _matches.indexOf(match);
    final df = DateFormat('dd/MM HH:mm');
    bool isEditingResult = _matchIndexToResult == originalIndex;
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
                Expanded(
                  child: Column(
                    children: [
                      _buildTeamDropZone(match, true),
                      const SizedBox(height: 8),
                      if (!isEditingResult)
                        Text(
                          match.homeScore?.toString() ?? "-",
                          style: TextStyle(
                            color: hasResult ? BolixoColors.accentGreen : BolixoColors.textTertiary,
                            fontSize: 24,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      Text("VS", style: TextStyle(fontWeight: FontWeight.bold, color: hasResult ? BolixoColors.accentGreen : BolixoColors.textPrimary, fontSize: 16)),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      _buildTeamDropZone(match, false),
                      const SizedBox(height: 8),
                      if (!isEditingResult)
                        Text(
                          match.awayScore?.toString() ?? "-",
                          style: TextStyle(
                            color: hasResult ? BolixoColors.accentGreen : BolixoColors.textTertiary,
                            fontSize: 24,
                            fontWeight: FontWeight.bold
                          ),
                        ),
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
                      style: BolixoTypography.bodySmall.copyWith(color: BolixoColors.textPrimary),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Fase (Tipo)", labelStyle: TextStyle(color: BolixoColors.textTertiary, fontSize: 12)),
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
                          const Text("Data/Hora", style: TextStyle(color: BolixoColors.textTertiary, fontSize: 10)),
                          const SizedBox(height: 4),
                          Text(df.format(match.matchDate), style: BolixoTypography.bodySmall.copyWith(color: BolixoColors.textPrimary)),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.analytics_outlined, color: BolixoColors.accentGreen, size: 22),
                    onPressed: () => setState(() => _matchIndexToResult = originalIndex),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: BolixoColors.error, size: 22),
                    onPressed: () => setState(() => _matches.remove(match)),
                  )
                ],
              ),
            ] else ...[
              const Text("Cadastrar Placar Final", style: TextStyle(color: BolixoColors.accentGreen, fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScoreStepper(
                    value: match.homeScore ?? 0,
                    onChanged: (v) => setState(() => match.homeScore = v),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text("x", style: BolixoTypography.headlineMedium.copyWith(color: BolixoColors.textTertiary)),
                  ),
                  ScoreStepper(
                    value: match.awayScore ?? 0,
                    onChanged: (v) => setState(() => match.awayScore = v),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => setState(() => _matchIndexToResult = null),
                    child: const Text("Cancelar", style: TextStyle(color: BolixoColors.textTertiary)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: BolixoColors.accentGreen),
                    onPressed: () => _saveMatchResult(match),
                    child: const Text("Salvar e Calcular", style: TextStyle(color: BolixoColors.backgroundPrimary, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ],
              )
            ]
          ],
        ),
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

  void _showTeamSearch(MatchModel match, bool isHome) async {
    final TeamModel? selected = await showSearch<TeamModel?>(
      context: context,
      delegate: TeamSearchDelegate(_competitionTeams),
    );
    if (selected != null) {
      setState(() {
        if (isHome) {
          match.home = selected;
        } else {
          match.away = selected;
        }
      });
    }
  }

  Widget _buildTeamDropZone(MatchModel match, bool isHome) {
    final selectedTeam = isHome ? match.home : match.away;
    return DragTarget<TeamModel>(
      onWillAccept: (data) => true,
      onAccept: (team) {
        setState(() {
          if (isHome) {
            match.home = team;
          } else {
            match.away = team;
          }
        });
      },
      builder: (context, candidateData, rejectedData) {
        return InkWell(
          onTap: () => _showTeamSearch(match, isHome),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
              color: candidateData.isNotEmpty ? BolixoColors.accentGreen.withValues(alpha:0.2) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: candidateData.isNotEmpty ? BolixoColors.accentGreen : BolixoColors.white6),
            ),
            child: selectedTeam == null
                ? const Icon(Icons.add_circle_outline, color: BolixoColors.textTertiary)
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTeamAvatar(selectedTeam),
                      const SizedBox(height: 4),
                      Text(
                        selectedTeam.name ?? "",
                        style: BolixoTypography.bodySmall.copyWith(fontWeight: FontWeight.bold, fontSize: 11),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Widget _buildTeamAvatar(TeamModel team, {bool isDragging = false, double opacity = 1.0}) {
    return Opacity(
      opacity: opacity,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isDragging ? BolixoColors.accentGreen.withValues(alpha: 0.5) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TeamFlag(abbreviation: team.abbreviation, radius: 18),
      ),
    );
  }
}

class TeamSearchDelegate extends SearchDelegate<TeamModel?> {
  final List<TeamModel> teams;
  TeamSearchDelegate(this.teams);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: const AppBarTheme(backgroundColor: BolixoColors.deepPlum),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: BolixoColors.textTertiary),
        border: InputBorder.none,
      ),
      textTheme: const TextTheme(titleLarge: TextStyle(color: BolixoColors.textPrimary)),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) => _buildList();

  @override
  Widget buildSuggestions(BuildContext context) => _buildList();

  Widget _buildList() {
    final filtered = teams.where((t) =>
      (t.name?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
      (t.abbreviation?.toLowerCase().contains(query.toLowerCase()) ?? false)
    ).toList();

    return Container(
      color: BolixoColors.backgroundPrimary,
      child: ListView.builder(
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          final team = filtered[index];
          return ListTile(
            leading: TeamFlag(abbreviation: team.abbreviation, radius: 15),
            title: Text(team.name ?? "", style: const TextStyle(color: BolixoColors.textPrimary)),
            subtitle: Text(team.abbreviation ?? "", style: const TextStyle(color: BolixoColors.textTertiary)),
            onTap: () => close(context, team),
          );
        },
      ),
    );
  }
}
