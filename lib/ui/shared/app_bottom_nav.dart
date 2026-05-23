import 'package:bolixo/flow/bets/competitions_bets_view.dart';
import 'package:bolixo/flow/boloes/boloes_view.dart';
import 'package:bolixo/ui/theme/bolixo_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBottomNav extends StatelessWidget {
  final int selectedIndex;

  const AppBottomNav({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              _buildNavItem(context, 0, Icons.sports_soccer, 'Palpites', '/competitions_bets'),
              _buildNavItem(context, 1, Icons.groups, 'Bolões', '/boloes'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon, String label, String routeName) {
    final isActive = selectedIndex == index;
    return GestureDetector(
      onTap: () {
        if (!isActive) {
          if (routeName == '/competitions_bets') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const CompetitionsBetsView(),
                settings: const RouteSettings(name: '/competitions_bets'),
              ),
            );
          } else if (routeName == '/boloes') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const BoloesView(),
                settings: const RouteSettings(name: '/boloes'),
              ),
            );
          }
        }
      },
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? BolixoColors.goldLight : BolixoColors.textTertiary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? BolixoColors.goldLight : BolixoColors.textTertiary,
              ),
            ),
            const SizedBox(height: 4),
            // Active indicator dot
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 3,
              width: isActive ? 20 : 0,
              decoration: BoxDecoration(
                color: BolixoColors.gold,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
