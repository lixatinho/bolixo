import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bolixo/ui/shared/app_elevated_button.dart';
import 'package:bolixo/ui/shared/app_text_button.dart';
import 'package:bolixo/ui/shared/loading_widget.dart';
import 'package:bolixo/ui/theme/bolixo_colors.dart';
import 'package:bolixo/ui/theme/bolixo_decorations.dart';
import 'package:bolixo/ui/theme/bolixo_gradients.dart';
import 'package:bolixo/ui/theme/bolixo_typography.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'auth_view_content.dart';
import 'auth_viewcontroller.dart';

class AuthView extends StatefulWidget {
  final AuthFormType authFormType;
  AuthView({Key? key, required this.authFormType}) : super(key: key);

  @override
  AuthViewState createState() => AuthViewState(authFormType: authFormType);
}

class AuthViewState extends State<AuthView> with SingleTickerProviderStateMixin {
  AuthViewContent viewContent = AuthViewContent();
  AuthViewController authViewController = AuthViewController();
  AuthFormType authFormType;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  AuthViewState({required this.authFormType});

  @override
  initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _floatAnimation = Tween<double>(begin: 0, end: -10).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
    authViewController.onInit(this, authFormType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Full screen gradient - no gaps
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: BolixoGradients.primary,
        ),
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 32),
                      // Floating trophy
                      AnimatedBuilder(
                        animation: _floatAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _floatAnimation.value),
                            child: child,
                          );
                        },
                        child: Image.asset(
                          'assets/images/world_cup_trophy.png',
                          height: 160,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // App name
                      Text(
                        'Bolão dos Lixos',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: BolixoColors.textSecondary,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Header (Entrar / Criar conta)
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, 0.1),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                        child: AutoSizeText(
                          viewContent.headerText,
                          key: ValueKey(viewContent.headerText),
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: BolixoTypography.displayLarge,
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Glassmorphism form container
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BolixoDecorations.glass(radius: 24),
                            child: Form(
                              key: formKey,
                              child: Column(
                                children: buildInputs() + buildButtons(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
              if (viewContent.isLoading)
                const LoadingWidget(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    authViewController.onDispose();
    super.dispose();
  }

  void showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  void updateIsLoading(bool newIsLoadingValue) {
    setState(() {
      viewContent.isLoading = newIsLoadingValue;
    });
  }

  void updateViewContent(AuthViewContent viewContent) {
    setState(() {
      this.viewContent = viewContent;
    });
  }

  InputDecoration buildSignUpDecoration(String hint, {IconData? icon}) {
    return BolixoDecorations.inputDecoration(hint: hint, prefixIcon: icon);
  }

  List<Widget> buildButtons() {
    List<Widget> buttons = [
      SizedBox(
        width: double.infinity,
        child: AppElevatedButton(
          onPressedCallback: () {
            authViewController.onSubmitClicked(
                _nameController.text, _emailController.text, _passwordController.text);
          },
          text: viewContent.buttonText,
        ),
      ),
      const SizedBox(height: 12),
      AppTextButton(
        onPressedCallback: () {
          if (viewContent.type == AuthFormType.recoverPassword) {
            authViewController.goToLogin();
          } else {
            authViewController.switchAuthType();
          }
        },
        text: viewContent.switchText,
      ),
    ];

    if (viewContent.type == AuthFormType.signIn) {
      buttons.add(
        AppTextButton(
          onPressedCallback: () {
            authViewController.goToRecoverPassword();
          },
          text: "Esqueci minha senha",
        ),
      );
    }

    return buttons;
  }

  List<Widget> buildInputs() {
    List<Widget> textFields = [];
    // Name
    if (viewContent.isNameVisible) {
      textFields.add(TextFormField(
        controller: _nameController,
        keyboardType: TextInputType.name,
        style: BolixoTypography.bodyLarge,
        decoration: buildSignUpDecoration("Username", icon: Icons.person_outline),
      ));
      textFields.add(const SizedBox(height: 16));
    }

    if (viewContent.isEmailVisible) {
      textFields.add(TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        style: BolixoTypography.bodyLarge,
        decoration: buildSignUpDecoration("Email", icon: Icons.email_outlined),
      ));
      textFields.add(const SizedBox(height: 16));
    }

    // Password
    if (viewContent.isPasswordVisible) {
      textFields.add(TextFormField(
        controller: _passwordController,
        keyboardType: TextInputType.visiblePassword,
        style: BolixoTypography.bodyLarge,
        decoration: buildSignUpDecoration("Senha", icon: Icons.lock_outline),
        obscureText: true,
      ));
      textFields.add(const SizedBox(height: 24));
    }

    return textFields;
  }
}
