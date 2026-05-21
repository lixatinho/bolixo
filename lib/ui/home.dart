import 'package:bolixo/api/model/user_model.dart';
import 'package:bolixo/cache/bolao_cache.dart';
import 'package:bolixo/flow/bets/bets_view.dart';
import 'package:bolixo/flow/boloes/boloes_view.dart';
import 'package:bolixo/flow/boloes/boloes_widget.dart';
import 'package:bolixo/ui/shared/loading_widget.dart';
import 'package:bolixo/ui/shared/rules_dialog.dart';
import 'package:bolixo/ui/theme/bolixo_colors.dart';
import 'package:bolixo/ui/theme/bolixo_typography.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../flow/auth/auth_view.dart';
import '../flow/auth/auth_view_content.dart';
import '../flow/auth/auth_service.dart';
import '../flow/auth/change_password_view.dart';
import '../flow/competition/manage_competitions_view.dart';
import '../flow/ranking/ranking_view.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title, this.redirectBoloes = false});

  final String title;
  final bool redirectBoloes;

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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isAuthInitialized = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
    bolaoName = BolaoCache().bolaoName;
    bolaoId = BolaoCache().bolaoId;
    BolaoCache().onBolaoChanged(_handleBolaoChanged);

    AuthService().initialize().then((_) {
      if (mounted) {
        setState(() {
          _isAuthInitialized = true;
        });

        if (widget.redirectBoloes) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BoloesView()),
            );
          });
        }
      }
    });
  }

  void _handleBolaoChanged(int newId, String newName) {
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            bolaoId = newId;
            bolaoName = newName;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    BolaoCache().onBolaoChanged(null);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAuthInitialized) {
      return const LoadingWidget();
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: BolixoColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: BolixoColors.deepPlum,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Text(
          bolaoName,
          style: BolixoTypography.titleLarge,
        ),
        actions: [
          IconButton(
            onPressed: () => showRulesDialog(context),
            icon: const Icon(Icons.rule_outlined, color: BolixoColors.textPrimary),
          ),
          IconButton(
            onPressed: () => _showBolaoBottomSheet(),
            icon: const Icon(Icons.change_circle_outlined, color: BolixoColors.textPrimary),
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _selectedIndex = index);
        },
        children: [
          BetsWidget(key: ValueKey("bets_$bolaoId")),
          RankingWidget(key: ValueKey("ranking_$bolaoId")),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildDrawer() {
    final role = AuthService().repository.getRole();

    return Drawer(
      child: Container(
        color: BolixoColors.backgroundPrimary,
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [BolixoColors.deepPlum, BolixoColors.backgroundPrimary],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/world_cup_trophy.png', height: 60),
                    const SizedBox(height: 10),
                    Text(
                      AuthService().repository.getUsername(),
                      style: BolixoTypography.titleLarge,
                    ),
                    Text(
                      role.toString().split('.').last,
                      style: BolixoTypography.bodySmall.copyWith(color: BolixoColors.accentGreenLight),
                    ),
                  ],
                ),
              ),
            ),
            _buildDrawerItem(Icons.edit, 'Palpites', 0),
            _buildDrawerItem(Icons.leaderboard, 'Ranking', 1),

            _buildDrawerAction(Icons.groups, 'Bolões', () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BoloesView()),
              );
            }),

            if (role == UserRole.ADMIN)
              _buildDrawerAction(Icons.settings, 'Competições', () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ManageCompetitionsView()),
                );
              }),

            const Divider(color: BolixoColors.white6),
            _buildDrawerAction(Icons.vpn_key, 'Trocar Senha', () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChangePasswordView()),
              );
            }),
            _build_logout_action(),
          ],
        ),
      ),
    );
  }

  Widget _build_logout_action() {
    return _buildDrawerAction(Icons.logout, 'Sair', () {
      AuthService().logOff();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => AuthView(authFormType: AuthFormType.signIn),
        ),
      );
    });
  }

  Widget _buildDrawerItem(IconData icon, String label, int index) {
    return ListTile(
      leading: Icon(icon, color: BolixoColors.textPrimary),
      title: Text(label, style: BolixoTypography.bodyLarge),
      onTap: () {
        Navigator.pop(context);
        setState(() => _selectedIndex = index);
        _pageController.jumpToPage(index);
      },
    );
  }

  Widget _buildDrawerAction(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: BolixoColors.textPrimary),
      title: Text(label, style: BolixoTypography.bodyLarge),
      onTap: onTap,
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
                  child: BoloesWidget(
                    scrollController: controller,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
