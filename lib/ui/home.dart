import 'package:bolixo/flow/bets/bets_view.dart';
import 'package:bolixo/flow/ranking/ranking.dart';
import 'package:bolixo/ui/menu.dart';
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
  int _selectedIndex = Menu.bets;
  final pages = {
    Menu.bets: const BetsWidget(),
    Menu.ranking: Ranking(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          elevation: 0,
          title: const Text('Title'),
        ),
        body: pages[_selectedIndex],
        drawer: Menu(onTapCallback: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        })
      ),
    );
  }
}
