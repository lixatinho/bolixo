import 'package:bolixo/flow/bets/bets_view.dart';
import 'package:bolixo/flow/ranking/ranking_view.dart';
import 'package:bolixo/flow/boloes/boloes_view.dart';
import 'package:bolixo/ui/menu.dart';
import 'package:flutter/material.dart';

import '../flow/auth/auth_view.dart';
import '../flow/auth/auth_view_content.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  int _selectedIndex = Menu.ranking;
  AlertDialog boloesDialog = _createBoloesDialog();

  final pages = {
    Menu.bets: const BetsWidget(),
    Menu.ranking: const RankingWidget(),
    Menu.boloes: const BoloesWidget(),
    Menu.logoff: AuthView(authFormType: AuthFormType.signIn),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        elevation: 0,
        title: const Text('Bolixo'),
        actions: [
          IconButton(
              onPressed: () {
                _showBolaoDialog();
              },
              icon: const Icon(
                Icons.change_circle_outlined,
                color: Colors.white,
              )
          )
        ],
      ),
      body: pages[_selectedIndex],
      drawer: Menu(onTapCallback: (int index) {
        setState(() {
          _selectedIndex = index;
        });
      }),
    );
  }

  Future<void> _showBolaoDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return boloesDialog;
      },
    );
  }

  static AlertDialog _createBoloesDialog() {
    return const AlertDialog(
        title: Text('Escolha o Bolão'),
        content: BoloesWidget()
    );
  }
}
