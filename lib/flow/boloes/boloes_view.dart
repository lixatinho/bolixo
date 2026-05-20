import 'dart:convert';
import 'package:bolixo/api/bolao/bolao_api_interface.dart';
import 'package:bolixo/api/model/bolao_model.dart';
import 'package:bolixo/api/model/user_model.dart';
import 'package:bolixo/flow/auth/auth_repository.dart';
import 'package:bolixo/flow/boloes/admin_boloes_view.dart';
import 'package:bolixo/flow/boloes/create_bolao_view.dart';
import 'package:bolixo/flow/ranking/ranking_view.dart';
import 'package:bolixo/ui/shared/app_bottom_nav.dart';
import 'package:bolixo/ui/shared/app_drawer.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<BolaoModel> _myBoloes = [];
  List<BolaoModel> _finishedBoloes = [];
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
    await _auth.initialize();
    await _api.initialize();
    try {
      final currentUserId = _auth.getUserId();

      // Busca bolões que o usuário participa (via ranking)
      final List<BolaoModel> participatingRaw = await _api.getBoloes();

      // Busca todos os bolões do sistema para filtrar os criados
      List<BolaoModel> createdFiltered = [];
      if (_userRole != UserRole.USER) {
        final List<BolaoModel> allBoloes = await _api.getAllBoloes();
        createdFiltered = allBoloes.where((b) => b.idUser != null && b.idUser == currentUserId).toList();
      }

      // Remove duplicatas da lista de participação
      final participatingUnique = participatingRaw.fold<List<BolaoModel>>([], (list, element) {
        if (!list.any((b) => b.bolaoId == element.bolaoId)) {
          list.add(element);
        }
        return list;
      });

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      final activeBoloes = participatingUnique.where((b) {
        final endDate = b.competition?.endDate;
        if (endDate == null) return true;
        final compEndDate = DateTime(endDate.year, endDate.month, endDate.day);
        return !compEndDate.isBefore(today);
      }).toList();

      final finishedBoloes = participatingUnique.where((b) {
        final endDate = b.competition?.endDate;
        if (endDate == null) return false;
        final compEndDate = DateTime(endDate.year, endDate.month, endDate.day);
        return compEndDate.isBefore(today);
      }).toList();

      setState(() {
        _myBoloes = activeBoloes;
        _finishedBoloes = finishedBoloes;
        _createdBoloes = createdFiltered;
        _userRole = _auth.getRole();
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
              final code = controller.text.trim();
              if (code.isNotEmpty) {
                Navigator.pop(context);
                _joinBolao(code);
              }
            },
            child: const Text("Entrar", style: TextStyle(color: BolixoColors.accentGreen))
          ),
        ],
      ),
    );
  }

  Future<void> _joinBolao(String code) async {
    setState(() => _isLoading = true);
    try {
      await _api.joinBolao(code);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Você entrou no bolão com sucesso!")),
      );
      _fetchData();
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao entrar no bolão. Verifique o código.")),
      );
    }
  }

  void _confirmDeleteBolao(BolaoModel bolao) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: BolixoColors.surfaceElevated,
        title: const Text("Excluir Bolão", style: TextStyle(color: Colors.white)),
        content: Text("Tem certeza que deseja excluir o bolão '${bolao.name}'? Esta ação não pode ser desfeita.",
            style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (bolao.bolaoId != null) {
                _deleteBolao(bolao.bolaoId!);
              }
            },
            child: const Text("Excluir", style: TextStyle(color: Colors.redAccent))
          ),
        ],
      ),
    );
  }

  Future<void> _deleteBolao(int id) async {
    setState(() => _isLoading = true);
    try {
      await _api.deleteBolao(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Bolão excluído com sucesso")),
      );
      _fetchData();
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao excluir bolão")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: BolixoColors.backgroundPrimary,
      appBar: AppBar(
        title: const Text("Meus Bolões", style: TextStyle(color: Colors.white)),
        backgroundColor: BolixoColors.deepPlum,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
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
      drawer: const AppDrawer(),
      body: _isLoading
        ? const Center(child: CircularProgressIndicator(color: BolixoColors.accentGreen))
        : RefreshIndicator(
            onRefresh: _fetchData,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildExpandableSection(
                  title: "Meus Bolões",
                  initiallyExpanded: true,
                  items: _myBoloes,
                  emptyMessage: "Você não participa de nenhum bolão ativo.",
                  isCreator: false,
                ),
                const SizedBox(height: 8),
                _buildExpandableSection(
                  title: "Bolões Encerrados",
                  initiallyExpanded: false,
                  items: _finishedBoloes,
                  emptyMessage: "Nenhum bolão encerrado.",
                  isCreator: false,
                ),
                if (_userRole != UserRole.USER) ...[
                  const SizedBox(height: 8),
                  _buildExpandableSection(
                    title: "Meus Bolões Criados",
                    initiallyExpanded: false,
                    items: _createdBoloes,
                    emptyMessage: "Você ainda não criou nenhum bolão.",
                    isCreator: true,
                  ),
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
      bottomNavigationBar: const AppBottomNav(selectedIndex: 1),
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required bool initiallyExpanded,
    required List<BolaoModel> items,
    required String emptyMessage,
    required bool isCreator,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(title, style: BolixoTypography.titleMedium.copyWith(color: BolixoColors.accentCyan)),
        initiallyExpanded: initiallyExpanded,
        iconColor: BolixoColors.accentCyan,
        collapsedIconColor: BolixoColors.accentCyan,
        tilePadding: EdgeInsets.zero,
        children: [
          if (items.isEmpty)
            _buildEmptyState(emptyMessage)
          else
            ...items.map((b) => _buildBolaoCard(b, isCreator)),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      width: double.infinity,
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
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (bolao.competition?.name != null)
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 4),
                child: Text(
                  bolao.competition!.name!,
                  style: BolixoTypography.bodySmall.copyWith(color: BolixoColors.accentCyan),
                ),
              ),
            if (isCreator && bolao.inviteCode != null)
              Row(
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
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isCreator)
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: () => _confirmDeleteBolao(bolao),
              ),
            const Icon(Icons.chevron_right, color: Colors.white24),
          ],
        ),
        onTap: () {
          if (bolao.bolaoId != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RankingWidget(
                  bolaoId: bolao.bolaoId!,
                  bolaoName: bolao.name ?? "Ranking",
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
