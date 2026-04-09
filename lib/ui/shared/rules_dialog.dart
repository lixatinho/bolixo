import 'package:bolixo/ui/theme/bolixo_colors.dart';
import 'package:bolixo/ui/theme/bolixo_typography.dart';
import 'package:flutter/material.dart';

void showRulesDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: BolixoColors.surfaceElevated,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: Text('Regras da pontuação', style: BolixoTypography.headlineMedium),
        content: SingleChildScrollView(
          child: Text(
            "Mitou: acertou na mosca, 10 pontos.\n\n"
            "Acertar resultado: 5 pontos.\n\n"
            "Acertar quantidade de gols de um time: 1 ponto.\n\n"
            "Cada fase possui um peso, que pode multiplicar os valores anteriores.\n"
            "Fase de grupos, peso 1. Próxima fase, peso 2, e assim por diante.\n\n"
            "Exemplo 1: resultado do jogo 1x0. Palpite 2x0. Pontuação = 6, acertou resultado e o número de gols de um time.\n\n"
            "Exemplo 2: resultado do jogo 0x0. Palpite 1x1. Pontuação = 5, acertou resultado.\n\n"
            "Exemplo 3: resultado do jogo 3 x 3, oitavas-de-final. Palpite 3x3. Pontuação = 20, 10 x 2 (peso das oitavas, considerando que ela seria a próxima fase)",
            style: BolixoTypography.bodyMedium,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar', style: TextStyle(color: BolixoColors.accentGreen)),
          ),
        ],
      );
    },
  );
}
