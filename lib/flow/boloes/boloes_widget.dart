import 'package:bolixo/flow/boloes/boloes_view_content.dart';
import 'package:bolixo/flow/boloes/boloes_viewcontroller.dart';
import 'package:bolixo/ui/shared/loading_widget.dart';
import 'package:bolixo/ui/theme/bolixo_colors.dart';
import 'package:bolixo/ui/theme/bolixo_typography.dart';
import 'package:flutter/material.dart';

class BoloesWidget extends StatefulWidget {
  final ScrollController? scrollController;
  final EdgeInsets? padding;

  const BoloesWidget({super.key, this.scrollController, this.padding});

  @override
  State<StatefulWidget> createState() => BoloesWidgetState();
}

class BoloesWidgetState extends State<BoloesWidget> {
  BoloesViewContent? viewContent;
  bool isLoading = true;
  BoloesViewController viewController = BoloesViewController();

  @override
  void initState() {
    super.initState();
    viewController.onInit(this);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const LoadingWidget();
    } else {
      if (viewContent == null || viewContent!.boloes.isEmpty) {
        return Container(
          padding: widget.padding,
          child: Center(
            child: Text(
              "Nenhum bolão disponível.",
              style: BolixoTypography.bodyLarge.copyWith(color: Colors.white70),
            ),
          ),
        );
      }
      return ListView.builder(
        controller: widget.scrollController,
        padding: widget.padding,
        itemCount: viewContent!.boloes.length,
        itemBuilder: (context, index) {
          final bolao = viewContent!.boloes[index];
          return Card(
            color: BolixoColors.surfaceElevated,
            margin: const EdgeInsets.only(bottom: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              title: Text(bolao.name, style: BolixoTypography.bodyLarge),
              trailing: const Icon(Icons.check_circle_outline, color: Colors.white24),
              onTap: () {
                viewController.onBolaoSelected(bolao.id, bolao.name);
                Navigator.pop(context);
              },
            ),
          );
        },
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    viewController.onDispose();
  }

  void update(BoloesViewContent newContent) {
    setState(() {
      viewContent = newContent;
      isLoading = false;
    });
  }
}
