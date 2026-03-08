import 'package:bolixo/api/bolao/bolao_api_interface.dart';
import 'package:bolixo/api/model/competition_model.dart';
import 'package:bolixo/api/model/user_model.dart';
import 'package:bolixo/flow/auth/auth_repository.dart';
import 'package:bolixo/ui/shared/app_elevated_button.dart';
import 'package:bolixo/ui/theme/bolixo_colors.dart';
import 'package:bolixo/ui/theme/bolixo_decorations.dart';
import 'package:bolixo/ui/theme/bolixo_typography.dart';
import 'package:flutter/material.dart';

class CreateBolaoView extends StatefulWidget {
  const CreateBolaoView({Key? key}) : super(key: key);

  @override
  _CreateBolaoViewState createState() => _CreateBolaoViewState();
}

class _CreateBolaoViewState extends State<CreateBolaoView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  CompetitionModel? _selectedCompetition;
  List<CompetitionModel> _competitions = [];
  bool _isLoading = false;
  bool _isGlobal = false;
  bool _isFetchingCompetitions = true;
  final BolaoApi _bolaoApi = BolaoApi.getInstance();
  final AuthRepository _auth = AuthRepository();
  late UserRole _userRole;

  @override
  void initState() {
    super.initState();
    _userRole = _auth.getRole();
    _fetchCompetitions();
  }

  void _fetchCompetitions() async {
    await _bolaoApi.initialize();
    _bolaoApi.getActiveCompetitions().then((list) {
      setState(() {
        _competitions = list;
        _isFetchingCompetitions = false;
      });
    }).catchError((error) {
      setState(() => _isFetchingCompetitions = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao carregar competições")),
      );
    });
  }

  void _createBolao() async {
    if (_formKey.currentState!.validate() && _selectedCompetition != null) {
      setState(() => _isLoading = true);

      _bolaoApi.createBolao(
        _nameController.text,
        _selectedCompetition!.id!,
        _isGlobal,
      ).then((_) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Bolão criado com sucesso!")),
        );
        Navigator.of(context).pop(true);
      }).catchError((error) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erro ao criar bolão")),
        );
      });
    } else if (_selectedCompetition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selecione uma competição")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BolixoColors.backgroundPrimary,
      appBar: AppBar(
        title: const Text("Criar Novo Bolão", style: TextStyle(color: Colors.white)),
        backgroundColor: BolixoColors.deepPlum,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isFetchingCompetitions
        ? const Center(child: CircularProgressIndicator(color: BolixoColors.accentGreen))
        : SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text("Nome do Bolão", style: BolixoTypography.bodyLarge),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    style: BolixoTypography.bodyLarge,
                    decoration: BolixoDecorations.inputDecoration(
                      hint: "Ex: Bolão da Galera",
                      prefixIcon: Icons.emoji_events_outlined,
                    ),
                    validator: (value) => value!.isEmpty ? "Informe o nome" : null,
                  ),
                  const SizedBox(height: 24),
                  Text("Competição", style: BolixoTypography.bodyLarge),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: BolixoColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: BolixoColors.white6),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<CompetitionModel>(
                        value: _selectedCompetition,
                        isExpanded: true,
                        hint: Text("Selecione a competição", style: BolixoTypography.bodyMedium),
                        dropdownColor: BolixoColors.surfaceElevated,
                        items: _competitions.map((comp) {
                          return DropdownMenuItem(
                            value: comp,
                            child: Text(comp.name ?? "", style: BolixoTypography.bodyLarge),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => _selectedCompetition = value);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (_userRole == UserRole.ADMIN)
                    Theme(
                      data: Theme.of(context).copyWith(
                        unselectedWidgetColor: Colors.white70,
                      ),
                      child: CheckboxListTile(
                        title: Text("Bolão Global", style: BolixoTypography.bodyLarge),
                        subtitle: const Text(
                          "Se marcado, qualquer usuário poderá visualizar e participar deste bolão.",
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        value: _isGlobal,
                        activeColor: BolixoColors.accentGreen,
                        checkColor: Colors.white,
                        contentPadding: EdgeInsets.zero,
                        onChanged: (bool? value) {
                          setState(() {
                            _isGlobal = value ?? false;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                  const SizedBox(height: 48),
                  _isLoading
                    ? const Center(child: CircularProgressIndicator(color: BolixoColors.accentGreen))
                    : SizedBox(
                        width: double.infinity,
                        child: AppElevatedButton(
                          onPressedCallback: _createBolao,
                          text: "Criar Bolão",
                        ),
                      ),
                ],
              ),
            ),
          ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
