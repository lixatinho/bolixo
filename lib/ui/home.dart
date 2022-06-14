import 'package:bolixo/flow/bets/bets_view.dart';
import 'package:bolixo/flow/ranking/ranking.dart';
import 'package:bolixo/ui/menu.dart';
import 'package:bolixo/ui/shared/Shit.dart';
import 'package:bolixo/ui/shared/cagar.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  int _selectedIndex = 0;
  final pages = {
    Menu.palpites: BetsWidget(),
    Menu.ranking: Ranking(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Title'),
        ),
        body: pages[_selectedIndex],
        drawer: Shit(
          child: Menu(onTapCallback: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          })
        ),
      ),
    );
  }
}
