import 'package:bolixo/api/bolao/bolao_api_interface.dart';
import 'package:bolixo/api/model/bolao_model.dart';
import 'package:bolixo/api/model/user_model.dart';
import 'package:bolixo/flow/auth/auth_repository.dart';
import 'package:bolixo/flow/boloes/admin_boloes_view.dart';
import 'package:bolixo/flow/boloes/create_bolao_view.dart';
import 'package:bolixo/ui/theme/bolixo_colors.dart';
import 'package:bolixo/ui/theme/bolixo_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BoloesView extends StatefulWidget {
  const BoloesView({Key? key}) : super(key: key);

  @override
  _BoloesViewState createState() => _BoloesViewState();
}

class _BoloesViewState extends State<BoloesView> {
  final BolaoApi _api = BolaoApi.getInstance();
  final AuthRepository _auth = AuthRepository();

  List<BolaoModel> _myBoloes = [];
  List<BolaoModel> _createdBoloes = [];
  bool _isLoading = true;
  late UserRole _userRole;

  @override
  void initState() {
    super.initState();
    _userRole = _auth.getRole();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    await _api.initialize();
    try {
      final all = await _api.getBoloes();
      setState(() {
        _myBoloes = all;
        if (_userRole != UserRole.USER) {
          _createdBoloes = all.where((b) => b.bolaoId != null && b.bolaoId! % 2 == 0).toList();
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao carregar bolões")),
      );
    }
  }

  void _showJoinBolaoDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: BolixoColors.surfaceElevated,
        title: Text("Entrar em Bolão", style: BolixoTypography.titleMedium),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Código do Bolão",
            hintStyle: TextStyle(color: Colors.white54),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: BolixoColors.accentGreen)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Tentando entrar no bolão ${controller.text}...")),
              );
            },
            child: const Text("Entrar", style: TextStyle(color: BolixoColors.accentGreen))
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BolixoColors.backgroundPrimary,
      appBar: AppBar(
        title: const Text("Meus Bolões", style: TextStyle(color: Colors.white)),
        backgroundColor: BolixoColors.deepPlum,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (_userRole == UserRole.ADMIN)
            IconButton(
              icon: const Icon(Icons.admin_panel_settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminBoloesView()),
                );
              },
            )
        ],
      ),
      body: _isLoading
        ? const Center(child: CircularProgressIndicator(color: BolixoColors.accentGreen))
        : RefreshIndicator(
            onRefresh: _fetchData,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSectionTitle("Participando"),
                if (_myBoloes.isEmpty)
                  _buildEmptyState("Você não participa de nenhum bolão.")
                else
                  ..._myBoloes.map((b) => _buildBolaoCard(b, false)),

                if (_userRole != UserRole.USER) ...[
                  const SizedBox(height: 24),
                  _buildSectionTitle("Meus Bolões Criados"),
                  if (_createdBoloes.isEmpty)
                    _buildEmptyState("Você ainda não criou nenhum bolão.")
                  else
                    ..._createdBoloes.map((b) => _buildBolaoCard(b, true)),
                ],
                const SizedBox(height: 80),
              ],
            ),
          ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (_userRole != UserRole.USER)
            FloatingActionButton.extended(
              heroTag: "create",
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateBolaoView()),
                );
                if (result == true) _fetchData();
              },
              label: const Text("Criar Bolão"),
              icon: const Icon(Icons.add),
              backgroundColor: BolixoColors.accentGreen,
            ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: "join",
            onPressed: _showJoinBolaoDialog,
            label: const Text("Entrar em Bolão"),
            icon: const Icon(Icons.group_add),
            backgroundColor: BolixoColors.electricViolet,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(title, style: BolixoTypography.titleMedium.copyWith(color: BolixoColors.accentCyan)),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: BolixoColors.surfaceElevated,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(message, style: const TextStyle(color: Colors.white70, fontStyle: FontStyle.italic)),
    );
  }

  Widget _buildBolaoCard(BolaoModel bolao, bool isCreator) {
    return Card(
      color: BolixoColors.surfaceElevated,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(bolao.name ?? "Sem nome", style: BolixoTypography.bodyLarge),
        subtitle: isCreator && bolao.inviteCode != null
          ? Row(
              children: [
                Text("Código: ${bolao.inviteCode}", style: const TextStyle(color: Colors.white70)),
                IconButton(
                  icon: const Icon(Icons.copy, size: 16, color: BolixoColors.accentGreen),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: bolao.inviteCode!));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Código copiado!")),
                    );
                  },
                )
              ],
            )
          : null,
        trailing: const Icon(Icons.chevron_right, color: Colors.white24),
        onTap: () {
          // Lógica para abrir o bolão
        },
      ),
    );
  }
}
