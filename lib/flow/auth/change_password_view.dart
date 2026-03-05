import 'package:bolixo/ui/shared/app_elevated_button.dart';
import 'package:bolixo/ui/theme/bolixo_colors.dart';
import 'package:bolixo/ui/theme/bolixo_decorations.dart';
import 'package:bolixo/ui/theme/bolixo_typography.dart';
import 'package:flutter/material.dart';
import 'auth_service.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({Key? key}) : super(key: key);

  @override
  _ChangePasswordViewState createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  final AuthService _authService = AuthService();

  void _changePassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      await _authService.initialize();
      final token = _authService.repository.getToken();

      if (token == null) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Sessão expirada. Faça login novamente.")),
        );
        return;
      }

      _authService.api.changePassword(
        token,
        _oldPasswordController.text,
        _newPasswordController.text,
      ).then((_) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Senha alterada com sucesso!")),
        );
        Navigator.of(context).pop();
      }).catchError((error) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erro ao alterar senha. Verifique a senha antiga.")),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BolixoColors.backgroundPrimary,
      appBar: AppBar(
        title: const Text("Trocar Senha", style: TextStyle(color: Colors.white)),
        backgroundColor: BolixoColors.deepPlum,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              TextFormField(
                controller: _oldPasswordController,
                obscureText: true,
                style: BolixoTypography.bodyLarge,
                decoration: BolixoDecorations.inputDecoration(
                  hint: "Senha Atual",
                  prefixIcon: Icons.lock_outline,
                ),
                validator: (value) => value!.isEmpty ? "Informe a senha atual" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                style: BolixoTypography.bodyLarge,
                decoration: BolixoDecorations.inputDecoration(
                  hint: "Nova Senha",
                  prefixIcon: Icons.vpn_key_outlined,
                ),
                validator: (value) => value!.length < 6 ? "Mínimo 6 caracteres" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                style: BolixoTypography.bodyLarge,
                decoration: BolixoDecorations.inputDecoration(
                  hint: "Confirmar Nova Senha",
                  prefixIcon: Icons.check_circle_outline,
                ),
                validator: (value) {
                  if (value != _newPasswordController.text) return "Senhas não conferem";
                  return null;
                },
              ),
              const SizedBox(height: 40),
              _isLoading
                ? const CircularProgressIndicator(color: BolixoColors.accentGreen)
                : SizedBox(
                    width: double.infinity,
                    child: AppElevatedButton(
                      onPressedCallback: _changePassword,
                      text: "Alterar Senha",
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
