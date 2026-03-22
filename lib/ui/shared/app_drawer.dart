import 'package:bolixo/flow/bets/competitions_bets_view.dart';
import 'package:flutter/material.dart';
import 'package:bolixo/flow/auth/auth_service.dart';
import 'package:bolixo/flow/auth/auth_view.dart';
import 'package:bolixo/flow/auth/auth_view_content.dart';
import 'package:bolixo/flow/auth/change_password_view.dart';
import 'package:bolixo/flow/boloes/boloes_view.dart';
import 'package:bolixo/flow/competition/manage_competitions_view.dart';
import 'package:bolixo/ui/theme/bolixo_colors.dart';
import 'package:bolixo/ui/theme/bolixo_typography.dart';
import 'package:bolixo/api/model/user_model.dart';

class AppDrawer extends StatelessWidget {
  final int? selectedIndex;
  final Function(int)? onItemSelected;

  const AppDrawer({Key? key, this.selectedIndex, this.onItemSelected}) : super(key: key);

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
            _buildDrawerItem(context, Icons.edit, 'Palpites', 0),
            _buildDrawerItem(context, Icons.leaderboard, 'Ranking', 1),

            _buildDrawerAction(context, Icons.sports_soccer, 'Palpites (Comp)', () {
              Navigator.pop(context);
              if (ModalRoute.of(context)?.settings.name != '/competitions_bets') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const CompetitionsBetsView(), settings: const RouteSettings(name: '/competitions_bets')),
                );
              }
            }),

            _buildDrawerAction(context, Icons.groups, 'Bolões', () {
              Navigator.pop(context);
              if (ModalRoute.of(context)?.settings.name != '/boloes') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const BoloesView(), settings: const RouteSettings(name: '/boloes')),
                );
              }
            }),

            if (role == UserRole.ADMIN)
              _buildDrawerAction(context, Icons.settings, 'Competições', () {
                Navigator.pop(context);
                if (ModalRoute.of(context)?.settings.name != '/competitions') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const ManageCompetitionsView(), settings: const RouteSettings(name: '/competitions')),
                  );
                }
              }),

            const Divider(color: BolixoColors.white6),
            _buildDrawerAction(context, Icons.vpn_key, 'Trocar Senha', () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChangePasswordView()),
              );
            }),
            _build_logout_action(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, IconData icon, String label, int index) {
    return ListTile(
      leading: Icon(icon, color: BolixoColors.textPrimary),
      title: Text(label, style: BolixoTypography.bodyLarge),
      onTap: () {
        Navigator.pop(context);
        if (onItemSelected != null) {
          onItemSelected!(index);
        } else {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
    );
  }

  Widget _buildDrawerAction(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: BolixoColors.textPrimary),
      title: Text(label, style: BolixoTypography.bodyLarge),
      onTap: onTap,
    );
  }

  Widget _build_logout_action(BuildContext context) {
    return _buildDrawerAction(context, Icons.logout, 'Sair', () {
      AuthService().logOff();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => AuthView(authFormType: AuthFormType.signIn),
        ),
        (route) => false,
      );
    });
  }
}
