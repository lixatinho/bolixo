import 'package:bolixo/cache/bolao_cache.dart';
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
  int _selectedIndex = Menu.bets;
  AlertDialog boloesDialog = _createBoloesDialog();
  AlertDialog rulesDialog = _createRulesDialog();

  final pages = {
    Menu.bets: const BetsWidget(),
    Menu.ranking: const RankingWidget(),
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
                _showRulesDialog();
              },
              icon: const Icon(
                Icons.change_circle_outlined,
                color: Colors.white,
              )
          ),
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
      barrierDismissible: BolaoCache().bolaoId != 0,
      builder: (BuildContext context) {
        return boloesDialog;
      },
    );
  }



  static AlertDialog _createBoloesDialog() {
    return AlertDialog(
        title: const Text('Escolha o Bolão'),
        content: Builder(
          builder: (context) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              width: 200,
              child: const BoloesWidget(),
            );
          },
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))
        ),
    );
  }

  Future<void> _showRulesDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return rulesDialog;
      },
    );
  }

  static AlertDialog _createRulesDialog() {
    return AlertDialog(
      title: const Text('Regras da pontuação'),
      content: Builder(
        builder: (context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            width: 300,
            child: const Text("Mitou: acertou na mosca, 10 pontos.\n\n"
                "Acertar resultado: 5 pontos.\n\n"
                "Acertar quantidade de gols de um time: 1 ponto.\n\n"
                "Cada fase possui um peso, que pode multiplicar os valores anteriores.\n"
                "Fase de grupos, peso 1. Oitavas, peso 2, e assim por diante.\n\n"
                "Exemplo 1: resultado do jogo 1x0. Palpite 2x0. Pontuação = 6, acertou resultado e o número de gols de um time.\n\n"
                "Exemplo 2: resultado do jogo 0x0. Palpite 1x1. Pontuação = 5, acertou resultado.\n\n"
                "Exemplo 3: resultado do jogo 3 x 3, semi-final. Palpite 3x3. Pontuação = 40, 10 x 4 (peso da semi-final)"),
          );
        },
      ),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))
      ),
    );
  }
}
