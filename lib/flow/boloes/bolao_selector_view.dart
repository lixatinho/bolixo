import 'package:bolixo/flow/bets/bets_view.dart';
import 'package:bolixo/flow/boloes/bolao_selector_viewcontroller.dart';
import 'package:bolixo/ui/shared/loading_widget.dart';
import 'package:bolixo/ui/theme/bolixo_colors.dart';
import 'package:bolixo/ui/theme/bolixo_typography.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../boloes/boloes_view_content.dart';

class BolaoSelectorView extends StatefulWidget {
  const BolaoSelectorView({Key? key}) : super(key: key);

  @override
  State<BolaoSelectorView> createState() => BolaoSelectorViewState();
}

class BolaoSelectorViewState extends State<BolaoSelectorView> {
  BoloesViewContent viewContent = BoloesViewContent();
  BolaoSelectorViewController viewController = BolaoSelectorViewController();
  int? selectedBolaoId;

  @override
  void initState() {
    super.initState();
    viewController.onInit(this);
  }

  @override
  void dispose() {
    viewController.onDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (viewContent.isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: BolixoColors.deepPlum,
          elevation: 0,
          title: const Text('Escolha o Bolão'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const LoadingWidget(),
      );
    }

    // Se não há bolões, retorna uma mensagem
    if (viewContent.boloes.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: BolixoColors.deepPlum,
          elevation: 0,
          title: const Text('Escolha o Bolão'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Text(
            'Nenhum bolão disponível',
            style: BolixoTypography.bodyLarge,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: BolixoColors.deepPlum,
        elevation: 0,
        title: const Text('Escolha o Bolão'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: BolixoColors.backgroundPrimary,
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: viewContent.boloes.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final bolao = viewContent.boloes[index];
            final isSelected = selectedBolaoId == bolao.id;

            return Container(
              decoration: BoxDecoration(
                color: BolixoColors.surfaceCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? BolixoColors.accentGreen
                      : BolixoColors.white8,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => _selectBolao(bolao.id, bolao.name),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        // Accent bar
                        Container(
                          width: 4,
                          height: 32,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                BolixoColors.accentGreen,
                                BolixoColors.accentGreenLight,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                bolao.name,
                                style: BolixoTypography.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Toque para selecionar',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: BolixoColors.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_circle,
                            color: BolixoColors.accentGreen,
                            size: 24,
                          )
                        else
                          Icon(
                            Icons.radio_button_unchecked,
                            color: BolixoColors.textTertiary,
                            size: 24,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void update(BoloesViewContent newViewContent) {
    setState(() {
      viewContent = newViewContent;
    });
  }

  void _selectBolao(int bolaoId, String bolaoName) {
    viewController.onBolaoSelected(bolaoId, bolaoName);
    
    // Navega para tela de palpites
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            backgroundColor: BolixoColors.deepPlum,
            elevation: 0,
            title: Text(bolaoName),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                onPressed: () => _showBolaoSelector(context),
                icon: const Icon(
                  Icons.change_circle_outlined,
                  color: BolixoColors.textPrimary,
                ),
              ),
            ],
          ),
          body: const BetsWidget(),
        ),
      ),
    );
  }

  void _showBolaoSelector(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const BolaoSelectorView(),
      ),
    );
  }
}
