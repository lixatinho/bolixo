import 'package:bolixo/ui/menu.dart';
import 'package:bolixo/ui/palpites.dart';
import 'package:bolixo/ui/ranking.dart';
import 'package:flutter/material.dart';

import '../shared/cagar.dart';

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
    Menu.palpites: Palpites(),
    Menu.ranking: Ranking(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Title')),
      body: pages[_selectedIndex],
      drawer: Cagar(child: Menu(onTapCallback: (int index) {
        setState(() {
          _selectedIndex = index;
        });
      })),
    );
  }
}
