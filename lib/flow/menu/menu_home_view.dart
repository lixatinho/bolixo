import 'package:bolixo/flow/auth/auth_view.dart';
import 'package:bolixo/flow/auth/auth_view_content.dart';
import 'package:bolixo/flow/auth/auth_service.dart';
import 'package:bolixo/flow/boloes/bolao_cards_inline.dart';
import 'package:bolixo/flow/ranking/ranking_view.dart';
import 'package:bolixo/ui/shared/app_elevated_button.dart';
import 'package:bolixo/ui/theme/bolixo_colors.dart';
import 'package:bolixo/ui/theme/bolixo_gradients.dart';
import 'package:bolixo/ui/theme/bolixo_typography.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuHomeView extends StatelessWidget {
  const MenuHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: BolixoGradients.primary,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Trophy Icon with animation
                  SizedBox(
                    height: 140,
                    child: Image.asset(
                      'assets/images/world_cup_trophy.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Title
                  Text(
                    'Bolão dos Lixos',
                    style: BolixoTypography.displayLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),

                  // Subtitle
                  Text(
                    'Bem-vindo ao jogo!',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: BolixoColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 60),

                  // Palpites as cards
                  const BolaoCardsInline(),
                  const SizedBox(height: 16),

                  _buildMenuButton(
                    context,
                    label: 'Ranking',
                    icon: Icons.leaderboard,
                    onPressed: () => _navigateToRanking(context),
                  ),
                  const SizedBox(height: 16),

                  _buildMenuButton(
                    context,
                    label: 'Sair',
                    icon: Icons.logout,
                    onPressed: () => _handleLogout(context),
                    isPrimaryAction: false,
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    bool isPrimaryAction = true,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: Container(
        decoration: BoxDecoration(
          color: isPrimaryAction
              ? BolixoColors.accentGreen
              : BolixoColors.surfaceCard,
          borderRadius: BorderRadius.circular(16),
          border: isPrimaryAction
              ? null
              : Border.all(
                  color: BolixoColors.accentCyan,
                  width: 2,
                ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: isPrimaryAction
                      ? BolixoColors.textOnAccent
                      : BolixoColors.accentCyan,
                  size: 28,
                ),
                const SizedBox(width: 16),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: isPrimaryAction
                        ? BolixoColors.textOnAccent
                        : BolixoColors.accentCyan,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  

  void _navigateToRanking(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            backgroundColor: BolixoColors.deepPlum,
            elevation: 0,
            title: const Text('Ranking'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: const RankingWidget(),
        ),
      ),
    );
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: BolixoColors.surfaceCard,
        title: Text(
          'Sair',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: BolixoColors.textPrimary,
          ),
        ),
        content: Text(
          'Deseja realmente sair?',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: BolixoColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: GoogleFonts.inter(
                color: BolixoColors.accentCyan,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              AuthService().logOff();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) =>
                      AuthView(authFormType: AuthFormType.signIn),
                ),
              );
            },
            child: Text(
              'Sair',
              style: GoogleFonts.inter(
                color: BolixoColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

