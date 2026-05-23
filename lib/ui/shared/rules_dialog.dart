import 'package:bolixo/ui/theme/bolixo_colors.dart';
import 'package:bolixo/ui/theme/bolixo_typography.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void showRulesDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: BolixoColors.surfaceElevated,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        actionsPadding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
        title: Text('Regras da Pontuação', style: BolixoTypography.headlineMedium.copyWith(color: BolixoColors.gold)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ruleItem('🎯', 'Mitada', 'Acertou o placar na mosca', '10 pts'),
              _ruleItem('✅', 'Resultado', 'Acertou quem venceu ou empate', '5 pts'),
              _ruleItem('⚽', 'Gols', 'Acertou gols de um time', '1 pt'),
              const SizedBox(height: 16),
              const Divider(color: BolixoColors.white10, height: 1),
              const SizedBox(height: 16),
              Text('Multiplicador por fase', style: BolixoTypography.titleMedium),
              const SizedBox(height: 8),
              Text(
                'Cada fase multiplica a pontuação:\n'
                'Grupos ×1 · Pré-Oitavas ×2 · Oitavas ×3\n'
                'Quartas ×4 · Semi ×5 · 3° Lugar ×6 · Final ×7',
                style: BolixoTypography.bodySmall.copyWith(color: BolixoColors.textSecondary, height: 1.6),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Fechar', style: GoogleFonts.inter(color: BolixoColors.textPrimary, fontWeight: FontWeight.w600)),
          ),
        ],
      );
    },
  );
}

Widget _ruleItem(String emoji, String title, String desc, String pts) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: BolixoTypography.titleMedium),
                  Text(pts, style: BolixoTypography.bodySmall.copyWith(color: BolixoColors.gold, fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 2),
              Text(desc, style: BolixoTypography.bodySmall.copyWith(color: BolixoColors.textTertiary)),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _exampleItem(String scenario, String pts, String reason) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: BolixoColors.white6,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(scenario, style: BolixoTypography.bodySmall.copyWith(color: BolixoColors.textPrimary, fontWeight: FontWeight.w600)),
            Text(pts, style: BolixoTypography.bodySmall.copyWith(color: BolixoColors.gold, fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 4),
        Text(reason, style: BolixoTypography.labelSmall.copyWith(color: BolixoColors.textTertiary)),
      ],
    ),
  );
}
