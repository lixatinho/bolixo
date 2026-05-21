import 'package:bolixo/flow/bets/competitions_bets_view.dart';
import 'package:bolixo/flow/boloes/boloes_view.dart';
import 'package:bolixo/ui/theme/bolixo_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Main shell that wraps Palpites and Bolões tabs with lazy IndexedStack.
/// Only builds a tab when first visited; keeps it alive after that.
class MainShell extends StatefulWidget {
  final int initialIndex;

  const MainShell({super.key, this.initialIndex = 0});

  @override
  State<MainShell> createState() => MainShellState();

  static void navigate(BuildContext context, {int tab = 0}) {
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => MainShell(initialIndex: tab),
        transitionDuration: Duration.zero,
        settings: const RouteSettings(name: '/main'),
      ),
      (route) => false,
    );
  }
}

class MainShellState extends State<MainShell> {
  late int _currentIndex;
  final Set<int> _loaded = {};

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _loaded.add(_currentIndex);
  }

  void switchTab(int index) {
    if (index != _currentIndex) {
      _loaded.add(index);
      setState(() => _currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          if (_loaded.contains(0))
            const CompetitionsBetsView()
          else
            const SizedBox.shrink(),
          if (_loaded.contains(1))
            const BoloesView()
          else
            const SizedBox.shrink(),
        ],
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
              _buildNavItem(0, Icons.sports_soccer, 'Palpites'),
              _buildNavItem(1, Icons.groups, 'Bolões'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => switchTab(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 100,
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
}
