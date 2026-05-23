import 'package:flutter/material.dart';
import 'package:bolixo/flow/auth/auth_service.dart';
import 'package:bolixo/flow/auth/auth_view.dart';
import 'package:bolixo/flow/auth/auth_view_content.dart';
import 'package:bolixo/flow/auth/change_password_view.dart';
import 'package:bolixo/flow/competition/manage_competitions_view.dart';
import 'package:bolixo/ui/main_shell.dart';
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
                      style: BolixoTypography.bodySmall.copyWith(color: BolixoColors.accentBlueLight),
                    ),
                  ],
                ),
              ),
            ),

            _buildDrawerAction(context, Icons.sports_soccer, 'Palpites', () {
              Navigator.pop(context);
              _switchToTab(context, 0);
            }),

            _buildDrawerAction(context, Icons.groups, 'Bolões', () {
              Navigator.pop(context);
              _switchToTab(context, 1);
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

            _build_logout_action(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, IconData icon, String label, int index) {
    bool isSelected = selectedIndex == index;
    return ListTile(
      leading: Icon(icon, color: isSelected ? BolixoColors.accentBlue : BolixoColors.textPrimary),
      title: Text(label, style: BolixoTypography.bodyLarge.copyWith(color: isSelected ? BolixoColors.accentBlue : null)),
      onTap: () {
        Navigator.pop(context);
        if (onItemSelected != null) {
          onItemSelected!(index);
        } else {
          // No caso de estar em outra tela e clicar em um item da Home
          // Poderia redirecionar para a Home primeiro se necessário
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
    );
  }

  Widget _buildDrawerAction(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: BolixoColors.gold),
      title: Text(label, style: BolixoTypography.bodyLarge),
      onTap: onTap,
    );
  }

  void _switchToTab(BuildContext context, int tab) {
    final shell = context.findAncestorStateOfType<MainShellState>();
    if (shell != null) {
      shell.switchTab(tab);
    } else {
      MainShell.navigate(context, tab: tab);
    }
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
