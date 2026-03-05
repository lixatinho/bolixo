import 'package:bolixo/api/competition/competition_api_interface.dart';
import 'package:bolixo/api/model/competition_model.dart';
import 'package:bolixo/api/model/team_model.dart';
import 'package:bolixo/ui/shared/app_elevated_button.dart';
import 'package:bolixo/ui/theme/bolixo_colors.dart';
import 'package:bolixo/ui/theme/bolixo_decorations.dart';
import 'package:bolixo/ui/theme/bolixo_typography.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditCompetitionView extends StatefulWidget {
  final CompetitionModel? competition;
  const EditCompetitionView({Key? key, this.competition}) : super(key: key);

  @override
  _EditCompetitionViewState createState() => _EditCompetitionViewState();
}

class _EditCompetitionViewState extends State<EditCompetitionView> {
  final _formKey = GlobalKey<FormState>();
  final _teamFormKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  // Controllers para o novo time
  final _teamNameController = TextEditingController();
  final _teamAbbrController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;

  List<TeamModel> _availableTeams = [];
  List<TeamModel> _selectedTeams = [];
  bool _isLoading = false;
  bool _isCreatingTeam = false;
  bool _isFetchingTeams = true;
  final CompetitionApi _api = CompetitionApi.getInstance();

  @override
  void initState() {
    super.initState();
    if (widget.competition != null) {
      _nameController.text = widget.competition!.name ?? "";
      _startDate = widget.competition!.startDate;
      _endDate = widget.competition!.endDate;
      if (_startDate != null) _startDateController.text = DateFormat('dd/MM/yyyy').format(_startDate!);
      if (_endDate != null) _endDateController.text = DateFormat('dd/MM/yyyy').format(_endDate!);
    }
    _fetchData();
  }

  void _fetchData() async {
    await _api.initialize();
    _api.getAllTeams().then((allTeams) {
      setState(() {
        if (widget.competition?.teams != null) {
          _selectedTeams = widget.competition!.teams!;
          final selectedIds = _selectedTeams.map((t) => t.id).toSet();
          _availableTeams = allTeams.where((t) => !selectedIds.contains(t.id)).toList();
        } else {
          _availableTeams = allTeams;
        }
        _isFetchingTeams = false;
      });
    }).catchError((error) {
      setState(() => _isFetchingTeams = false);
    });
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: (isStart ? _startDate : _endDate) ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          _startDateController.text = DateFormat('dd/MM/yyyy').format(picked);
        } else {
          _endDate = picked;
          _endDateController.text = DateFormat('dd/MM/yyyy').format(picked);
        }
      });
    }
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final competition = CompetitionModel(
        id: widget.competition?.id,
        name: _nameController.text,
        startDate: _startDate,
        endDate: _endDate,
      );

      final teamIds = _selectedTeams.map((t) => t.id!).toList();

      final future = widget.competition == null
          ? _api.createCompetition(competition, teamIds)
          : _api.updateCompetition(competition, teamIds);

      future.then((_) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Competição salva com sucesso!")),
        );
        Navigator.pop(context, true);
      }).catchError((error) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erro ao salvar competição")),
        );
      });
    }
  }

  void _addNewTeam() async {
    if (_teamFormKey.currentState!.validate()) {
      setState(() => _isCreatingTeam = true);

      final newTeam = TeamModel(
        name: _teamNameController.text,
        abbreviation: _teamAbbrController.text.toUpperCase(),
      );

      _api.createTeam(newTeam).then((createdTeam) {
        setState(() {
          _selectedTeams.add(createdTeam);
          _teamNameController.clear();
          _teamAbbrController.clear();
          _isCreatingTeam = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Time criado e selecionado!")),
        );
      }).catchError((error) {
        setState(() => _isCreatingTeam = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
      });
    }
  }

  void _selectTeam(TeamModel team) {
    setState(() {
      _availableTeams.remove(team);
      _selectedTeams.add(team);
    });
  }

  void _unselectTeam(TeamModel team) {
    setState(() {
      _selectedTeams.remove(team);
      _availableTeams.add(team);
      _availableTeams.sort((a, b) => (a.name ?? "").compareTo(b.name ?? ""));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BolixoColors.backgroundPrimary,
      appBar: AppBar(
        title: Text(widget.competition == null ? "Criar Competição" : "Editar Competição",
            style: const TextStyle(color: Colors.white)),
        backgroundColor: BolixoColors.deepPlum,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isFetchingTeams
          ? const Center(child: CircularProgressIndicator(color: BolixoColors.accentGreen))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Nome da Competição", style: BolixoTypography.bodyLarge),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _nameController,
                          style: BolixoTypography.bodyLarge,
                          decoration: BolixoDecorations.inputDecoration(
                              hint: "Ex: Copa 2026", prefixIcon: Icons.emoji_events),
                          validator: (v) => v!.isEmpty ? "Campo obrigatório" : null,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(child: _buildDatePickerField("Data Início", _startDateController, true)),
                            const SizedBox(width: 16),
                            Expanded(child: _buildDatePickerField("Data Fim", _endDateController, false)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildDualTeamLists(),
                  const SizedBox(height: 32),
                  _buildQuickCreateTeam(),
                  const SizedBox(height: 48),
                  _isLoading
                      ? const Center(child: CircularProgressIndicator(color: BolixoColors.accentGreen))
                      : SizedBox(
                          width: double.infinity,
                          child: AppElevatedButton(onPressedCallback: _save, text: "Salvar Competição"),
                        ),
                ],
              ),
            ),
    );
  }

  Widget _buildDatePickerField(String label, TextEditingController controller, bool isStart) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: BolixoTypography.bodyLarge),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          onTap: () => _selectDate(context, isStart),
          style: BolixoTypography.bodyMedium,
          decoration: BolixoDecorations.inputDecoration(hint: "dd/MM/yyyy", prefixIcon: Icons.calendar_today),
        ),
      ],
    );
  }

  Widget _buildDualTeamLists() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Gerenciar Times", style: BolixoTypography.titleLarge.copyWith(color: BolixoColors.accentGreen)),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildTeamListColumn("Todos os Times", _availableTeams, _selectTeam, Icons.add_circle_outline)),
            const SizedBox(width: 16),
            Expanded(child: _buildTeamListColumn("Selecionados (${_selectedTeams.length})", _selectedTeams, _unselectTeam, Icons.remove_circle_outline, isSelected: true)),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickCreateTeam() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BolixoColors.surfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BolixoColors.accentGreen.withOpacity(0.3)),
      ),
      child: Form(
        key: _teamFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Cadastrar Novo Time", style: BolixoTypography.bodyLarge.copyWith(color: BolixoColors.accentGreen)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _teamNameController,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: BolixoDecorations.inputDecoration(hint: "Nome do Time").copyWith(contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                    validator: (v) => v!.isEmpty ? "Obrigatório" : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _teamAbbrController,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    maxLength: 3,
                    decoration: BolixoDecorations.inputDecoration(hint: "Sigla").copyWith(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      counterText: "",
                    ),
                    validator: (v) => v!.length != 3 ? "3 letras" : null,
                  ),
                ),
                const SizedBox(width: 12),
                _isCreatingTeam
                  ? const SizedBox(width: 40, height: 40, child: CircularProgressIndicator(strokeWidth: 2))
                  : IconButton(
                      icon: const Icon(Icons.check_circle, color: BolixoColors.accentGreen, size: 32),
                      onPressed: _addNewTeam,
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamListColumn(String title, List<TeamModel> list, Function(TeamModel) onTap, IconData icon, {bool isSelected = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: BolixoTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          height: 300,
          decoration: BoxDecoration(
            color: BolixoColors.surfaceElevated,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isSelected ? BolixoColors.accentGreen.withOpacity(0.5) : BolixoColors.white6),
          ),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final team = list[index];
              return ListTile(
                dense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                leading: _buildTeamFlag(team),
                title: Text(team.abbreviation ?? "", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white)),
                subtitle: Text(team.name ?? "", style: const TextStyle(fontSize: 10, color: Colors.grey), overflow: TextOverflow.ellipsis),
                trailing: Icon(icon, size: 18, color: isSelected ? Colors.redAccent : BolixoColors.accentGreen),
                onTap: () => onTap(team),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTeamFlag(TeamModel team) {
    String assetPath = "assets/images/teams/${team.abbreviation}.png";
    return CircleAvatar(
      radius: 14,
      backgroundColor: BolixoColors.backgroundPrimary,
      child: ClipOval(
        child: Image.asset(
          assetPath,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.sports_soccer, size: 16, color: Colors.grey),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _teamNameController.dispose();
    _teamAbbrController.dispose();
    super.dispose();
  }
}
