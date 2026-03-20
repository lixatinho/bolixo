import 'package:bolixo/api/model/user_model.dart';
import 'package:bolixo/flow/auth/auth_service.dart';
import 'package:bolixo/flow/auth/auth_view.dart';
import 'package:bolixo/flow/auth/auth_view_content.dart';
import 'package:bolixo/flow/auth/change_password_view.dart';
import 'package:bolixo/flow/bet_by_competition/bet_by_competition_view.dart';
import 'package:bolixo/flow/boloes/boloes_view.dart';
import 'package:bolixo/flow/competition/manage_competitions_view.dart';
import 'package:bolixo/flow/home_selector/home_selector_view.dart';
import 'package:bolixo/ui/home.dart';
import 'package:bolixo/ui/theme/bolixo_colors.dart';
import 'package:bolixo/ui/theme/bolixo_typography.dart';
import 'package:flutter/material.dart';

class BolixoDrawer extends StatelessWidget {
  final Function(int)? onTabSelected;

  const BolixoDrawer({super.key, this.onTabSelected});

  @override
  Widget build(BuildContext context) {
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
            _buildDrawerAction(context, Icons.home, 'Home', () {
              Navigator.pop(context);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const HomeSelectorView()),
              );
            }),

            _buildDrawerAction(context, Icons.edit, 'Palpites', () {
              Navigator.pop(context);
              if (onTabSelected != null) {
                onTabSelected!(0);
              } else {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const Home(title: 'Bolixo', initialIndex: 0)),
                );
              }
            }),
            _buildDrawerAction(context, Icons.leaderboard, 'Ranking', () {
              Navigator.pop(context);
              if (onTabSelected != null) {
                onTabSelected!(1);
              } else {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const Home(title: 'Bolixo', initialIndex: 1)),
                );
              }
            }),

            _buildDrawerAction(context, Icons.sports_soccer, 'Palpites por Competição', () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BetByCompetitionView()),
              );
            }),

            _buildDrawerAction(context, Icons.groups, 'Bolões', () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BoloesView()),
              );
            }),

            if (role == UserRole.ADMIN)
              _buildDrawerAction(context, Icons.settings, 'Competições', () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ManageCompetitionsView()),
                );
              }),

            const Divider(color: BolixoColors.white6),
            _buildDrawerAction(context, Icons.vpn_key, 'Trocar Senha', () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChangePasswordView()),
              );
            }),
            _buildDrawerAction(context, Icons.logout, 'Sair', () {
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
    );
  }

  Widget _buildDrawerAction(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: BolixoColors.textPrimary),
      title: Text(label, style: BolixoTypography.bodyLarge),
      onTap: onTap,
    );
  }
}
