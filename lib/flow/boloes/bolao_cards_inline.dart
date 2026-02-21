import 'package:bolixo/flow/bets/bets_view.dart';
import 'package:bolixo/flow/boloes/boloes_view_content.dart';
import 'package:bolixo/flow/boloes/boloes_viewcontroller.dart';
import 'package:bolixo/ui/shared/loading_widget.dart';
import 'package:bolixo/ui/theme/bolixo_colors.dart';
import 'package:bolixo/ui/theme/bolixo_typography.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BolaoCardsInline extends StatefulWidget {
  const BolaoCardsInline({Key? key}) : super(key: key);

  @override
  State<BolaoCardsInline> createState() => _BolaoCardsInlineState();
}

class _BolaoCardsInlineState extends State<BolaoCardsInline> {
  BoloesViewContent viewContent = BoloesViewContent();
  BoloesViewController viewController = BoloesViewController();

  @override
  void initState() {
    super.initState();
    viewController.onInit(this);
  }

  @override
  Widget build(BuildContext context) {
    if (viewContent.isLoading) {
      return const LoadingWidget();
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: viewContent.boloes.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final bolao = viewContent.boloes[index];

        return Container(
          decoration: BoxDecoration(
            color: BolixoColors.surfaceCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: BolixoColors.white8, width: 1),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                viewController.onBolaoSelected(bolao.id, bolao.name);

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      appBar: AppBar(
                        backgroundColor: BolixoColors.deepPlum,
                        elevation: 0,
                        title: Text(bolao.name),
                        leading: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      body: const BetsWidget(),
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [BolixoColors.accentGreen, BolixoColors.accentGreenLight],
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(bolao.name, style: BolixoTypography.titleMedium),
                          const SizedBox(height: 6),
                          Text(
                            'Competição: não disponível',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: BolixoColors.textTertiary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Revisar o meu palpite',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: BolixoColors.accentGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: BolixoColors.textTertiary),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void update(BoloesViewContent newViewContent) {
    setState(() {
      viewContent = newViewContent;
    });
  }
}
