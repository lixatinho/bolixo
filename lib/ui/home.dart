import 'package:bolixo/flow/bets/bets_view.dart';
import 'package:bolixo/flow/ranking/ranking_view.dart';
import 'package:bolixo/flow/sweepstakes/sweeps_view.dart';
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
  int _selectedIndex = Menu.bets;
  final pages = {
    Menu.bets: const BetsWidget(),
    Menu.ranking: const RankingWidget(),
    Menu.sweeps: const SweepsWidget(),
    Menu.logoff: AuthView(authFormType: AuthFormType.signIn),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        elevation: 0,
        title: const Text('Bolixo'),
      ),
      body: pages[_selectedIndex],
      drawer: Menu(onTapCallback: (int index) {
        setState(() {
          _selectedIndex = index;
        });
      }),
    );
  }
}
