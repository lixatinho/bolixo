import 'package:bolixo/api/bolao/bolao_api_interface.dart';
import 'package:bolixo/api/model/bolao_model.dart';
import 'package:bolixo/ui/theme/bolixo_colors.dart';
import 'package:bolixo/ui/theme/bolixo_typography.dart';
import 'package:flutter/material.dart';

class AdminBoloesView extends StatefulWidget {
  const AdminBoloesView({Key? key}) : super(key: key);

  @override
  _AdminBoloesViewState createState() => _AdminBoloesViewState();
}

class _AdminBoloesViewState extends State<AdminBoloesView> {
  final BolaoApi _api = BolaoApi.getInstance();
  List<BolaoModel> _allBoloes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBoloes();
  }

  Future<void> _fetchBoloes() async {
    setState(() => _isLoading = true);
    await _api.initialize();
    try {
      final list = await _api.getBoloes(); // Aqui chamaremos o endpoint de ADMIN depois
      setState(() {
        _allBoloes = list;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao carregar todos os bolões")),
      );
    }
  }

  void _confirmDelete(BolaoModel bolao) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Excluir Bolão"),
        content: Text("Tem certeza que deseja excluir o bolão '${bolao.name}'?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancelar")),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Excluir", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // Chamada de API para deletar virá aqui
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Bolão ${bolao.name} excluído (simulação)")),
      );
      _fetchBoloes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BolixoColors.backgroundPrimary,
      appBar: AppBar(
        title: const Text("Gerenciar Bolões", style: TextStyle(color: Colors.white)),
        backgroundColor: BolixoColors.deepPlum,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: BolixoColors.accentGreen))
          : _allBoloes.isEmpty
              ? const Center(child: Text("Nenhum bolão encontrado no sistema.", style: TextStyle(color: Colors.white54)))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _allBoloes.length,
                  itemBuilder: (context, index) {
                    final bolao = _allBoloes[index];
                    return Card(
                      color: BolixoColors.surfaceElevated,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(bolao.name ?? "Sem nome", style: BolixoTypography.titleMedium),
                                ),
                                if (bolao.isGlobal)
                                  const Chip(
                                    label: Text("GLOBAL", style: TextStyle(fontSize: 10, color: Colors.white)),
                                    backgroundColor: BolixoColors.electricViolet,
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text("Criador: ${bolao.creatorUsername ?? 'Desconhecido'}", style: BolixoTypography.bodySmall),
                            Text("Código: ${bolao.inviteCode ?? 'N/A'}", style: BolixoTypography.bodySmall),
                            const Divider(color: Colors.white12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  onPressed: () {
                                    // Lógica para editar bolão (Admin)
                                  },
                                  icon: const Icon(Icons.edit, size: 18, color: BolixoColors.accentGreen),
                                  label: const Text("Editar", style: TextStyle(color: BolixoColors.accentGreen)),
                                ),
                                TextButton.icon(
                                  onPressed: () => _confirmDelete(bolao),
                                  icon: const Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
                                  label: const Text("Excluir", style: TextStyle(color: Colors.redAccent)),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
