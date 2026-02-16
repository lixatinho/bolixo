import 'package:bolixo/cache/bolao_cache.dart';
import 'package:bolixo/flow/bets/bets_view.dart';
import 'package:bolixo/flow/boloes/boloes_view.dart';
import 'package:bolixo/ui/theme/bolixo_colors.dart';
import 'package:bolixo/ui/theme/bolixo_typography.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../flow/auth/auth_view.dart';
import '../flow/auth/auth_view_content.dart';
import '../flow/auth/auth_service.dart';
import '../flow/ranking/ranking_view.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  int _selectedIndex = 0;
  String bolaoName = BolaoCache().bolaoName;
  int bolaoId = BolaoCache().bolaoId;
  late PageController _pageController;

  final pages = <Widget>[
    const BetsWidget(),
    const RankingWidget(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
    bolaoName = BolaoCache().bolaoName;
    BolaoCache().onBolaoChanged((newId, newName) {
      setState(() {
        bolaoId = newId;
        bolaoName = newName;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BolixoColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: BolixoColors.deepPlum,
        elevation: 0,
        title: Text(
          bolaoName,
          style: BolixoTypography.titleLarge,
        ),
        actions: [
          IconButton(
            onPressed: () => _showRulesDialog(),
            icon: const Icon(Icons.rule_outlined, color: BolixoColors.textPrimary),
          ),
          IconButton(
            onPressed: () => _showBolaoBottomSheet(),
            icon: const Icon(Icons.change_circle_outlined, color: BolixoColors.textPrimary),
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _selectedIndex = index);
        },
        children: pages,
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: BolixoColors.backgroundPrimary,
        border: Border(
          top: BorderSide(color: BolixoColors.white6, width: 1),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.edit, 'Palpites'),
              _buildNavItem(1, Icons.leaderboard, 'Ranking'),
              _buildNavItemAction(Icons.logout, 'Sair', () {
                AuthService().logOff();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => AuthView(authFormType: AuthFormType.signIn),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isActive = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedIndex = index);
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? BolixoColors.accentGreenLight : BolixoColors.textTertiary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? BolixoColors.accentGreenLight : BolixoColors.textTertiary,
              ),
            ),
            const SizedBox(height: 4),
            // Active indicator dot
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 3,
              width: isActive ? 20 : 0,
              decoration: BoxDecoration(
                color: BolixoColors.accentGreen,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItemAction(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: BolixoColors.textTertiary, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: BolixoColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBolaoBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: BolixoColors.backgroundSecondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.4,
          maxChildSize: 0.6,
          minChildSize: 0.3,
          builder: (context, controller) {
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 16),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: BolixoColors.textTertiary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Escolha o Bolão',
                      style: BolixoTypography.headlineMedium,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    controller: controller,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: const BoloesWidget(),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showRulesDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: BolixoColors.surfaceElevated,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Text('Regras da pontuação', style: BolixoTypography.headlineMedium),
          content: Text(
            "Mitou: acertou na mosca, 10 pontos.\n\n"
            "Acertar resultado: 5 pontos.\n\n"
            "Acertar quantidade de gols de um time: 1 ponto.\n\n"
            "Cada fase possui um peso, que pode multiplicar os valores anteriores.\n"
            "Fase de grupos, peso 1. Oitavas, peso 2, e assim por diante.\n\n"
            "Exemplo 1: resultado do jogo 1x0. Palpite 2x0. Pontuação = 6, acertou resultado e o número de gols de um time.\n\n"
            "Exemplo 2: resultado do jogo 0x0. Palpite 1x1. Pontuação = 5, acertou resultado.\n\n"
            "Exemplo 3: resultado do jogo 3 x 3, semi-final. Palpite 3x3. Pontuação = 40, 10 x 4 (peso da semi-final)",
            style: BolixoTypography.bodyMedium,
          ),
        );
      },
    );
  }
}
