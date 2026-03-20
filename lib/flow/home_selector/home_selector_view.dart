import 'package:bolixo/api/model/bolao_model.dart';
import 'package:bolixo/flow/auth/auth_service.dart';
import 'package:bolixo/flow/home_selector/home_selector_viewcontroller.dart';
import 'package:bolixo/ui/home.dart';
import 'package:bolixo/ui/shared/bolixo_drawer.dart';
import 'package:bolixo/ui/shared/loading_widget.dart';
import 'package:bolixo/ui/theme/bolixo_colors.dart';
import 'package:bolixo/ui/theme/bolixo_typography.dart';
import 'package:flutter/material.dart';

class HomeSelectorView extends StatefulWidget {
  const HomeSelectorView({super.key});

  @override
  State<HomeSelectorView> createState() => HomeSelectorViewState();
}

class HomeSelectorViewState extends State<HomeSelectorView> {
  final HomeSelectorViewController _controller = HomeSelectorViewController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  HomeSelectorStatus _status = HomeSelectorStatus.loading;
  List<BolaoModel> _boloes = [];
  bool _isAuthInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller.onInit(this);
    AuthService().initialize().then((_) {
      if (mounted) {
        setState(() {
          _isAuthInitialized = true;
        });
      }
    });
  }

  void updateState(HomeSelectorStatus status, List<BolaoModel> boloes) {
    if (mounted) {
      setState(() {
        _status = status;
        _boloes = boloes;
      });
    }
  }

  void navigateToBolaoHome({int initialIndex = 0}) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => Home(title: 'Bolixo', initialIndex: initialIndex),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAuthInitialized) {
      return const Scaffold(
        backgroundColor: BolixoColors.backgroundPrimary,
        body: Center(child: LoadingWidget()),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: BolixoColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: BolixoColors.deepPlum,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Text(
          "Bolixo",
          style: BolixoTypography.titleLarge,
        ),
      ),
      drawer: const BolixoDrawer(),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    switch (_status) {
      case HomeSelectorStatus.loading:
        return const Center(child: LoadingWidget());
      case HomeSelectorStatus.empty:
        return _buildEmptyState();
      case HomeSelectorStatus.single:
        WidgetsBinding.instance.addPostFrameCallback((_) {
            navigateToBolaoHome(initialIndex: 1);
        });
        return const Center(child: LoadingWidget());
      case HomeSelectorStatus.multiple:
        return _buildMultipleBoloesList();
      case HomeSelectorStatus.error:
        return _buildErrorState();
    }
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.info_outline, size: 64, color: BolixoColors.accentCyan),
          const SizedBox(height: 24),
          Text(
            "Você ainda não está cadastrado em nenhum bolão.",
            textAlign: TextAlign.center,
            style: BolixoTypography.headlineMedium,
          ),
          const SizedBox(height: 16),
          Text(
            "Entre em contato com o administrador para participar de um bolão!",
            textAlign: TextAlign.center,
            style: BolixoTypography.bodyMedium.copyWith(color: BolixoColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildMultipleBoloesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _boloes.length,
      itemBuilder: (context, index) {
        final bolao = _boloes[index];
        return _buildBolaoCard(bolao);
      },
    );
  }

  Widget _buildBolaoCard(BolaoModel bolao) {
    return Card(
      color: BolixoColors.surfaceCard,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: InkWell(
        onTap: () => _controller.onBolaoSelected(bolao),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: BolixoColors.royalPurple,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.emoji_events, color: BolixoColors.accentGreen, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bolao.name ?? "Sem nome",
                      style: BolixoTypography.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      bolao.competition?.name ?? "Competição não informada",
                      style: BolixoTypography.bodySmall.copyWith(color: BolixoColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: BolixoColors.white15, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: BolixoColors.error),
          const SizedBox(height: 16),
          Text("Ocorreu um erro ao carregar seus bolões.", style: BolixoTypography.bodyLarge),
          TextButton(
            onPressed: () => _controller.onInit(this),
            child: const Text("Tentar novamente", style: TextStyle(color: BolixoColors.accentCyan)),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.onDispose();
    super.dispose();
  }
}
