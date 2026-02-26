import 'package:bolixo/ui/shared/loading_widget.dart';
import 'package:bolixo/ui/shared/navigation.dart';
import 'package:bolixo/ui/theme/bolixo_colors.dart';
import 'package:bolixo/ui/theme/bolixo_typography.dart';
import 'package:flutter/material.dart';
import 'boloes_view_content.dart';
import 'boloes_viewcontroller.dart';

class BoloesWidget extends StatefulWidget {
  final ScrollController? scrollController;
  final EdgeInsetsGeometry? padding;

  const BoloesWidget({
    Key? key,
    this.scrollController,
    this.padding,
  }) : super(key: key);

  @override
  State<BoloesWidget> createState() => BoloesWidgetState();
}

class BoloesWidgetState extends State<BoloesWidget> {
  BoloesViewContent viewContent = BoloesViewContent();
  BoloesViewController viewController = BoloesViewController();

  @override
  initState() {
    super.initState();
    viewController.onInit(this);
  }

  @override
  Widget build(BuildContext context) {
    if (viewContent.isLoading) {
      return const LoadingWidget();
    } else {
      return ListView.separated(
        controller: widget.scrollController,
        padding: widget.padding,
        itemCount: viewContent.boloes.length,
        // Ao usar com DraggableScrollableSheet, o shrinkWrap deve ser false (padrão)
        // e o physics deve ser o padrão ou o provido pelo controller.
        separatorBuilder: (context, index) => const SizedBox(height: 8),
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

                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  } else {
                    navigateToHome(context);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 32,
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
                        child: Text(
                          bolao.name,
                          style: BolixoTypography.titleMedium,
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: BolixoColors.textTertiary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
  }

  void update(BoloesViewContent newViewContent) {
    setState(() {
      viewContent = newViewContent;
    });
  }
}
