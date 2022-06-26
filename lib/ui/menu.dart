import 'dart:html';
import 'dart:js';

import 'package:bolixo/flow/sign_up/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:bolixo/api/services/validateLogin.dart';

import '../flow/bets/bets_view.dart';

class Menu extends StatelessWidget {
  static const int bets = 1;
  static const ranking = 2;
  Function onTapCallback;

  Menu({Key? key, required this.onTapCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var user = CreateUserUp().getUser(uidC!);
    // print('teste de usuário logado ${userC?.name}');
    // print(uidC!);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountEmail: Text(''),
            accountName: Row(
              children: <Widget>[
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: CircleAvatar(
                    backgroundColor: Colors.greenAccent,
                    child: Icon(Icons.check),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('${userC?.name}'),
                    Text('${userC?.email}'),
                  ],
                )
              ],
            ),
          ),
          Column(children: bodyMenu(context)),
        ],
      ),
    );
  }

  List<Widget> bodyMenu(context) {
    List<Widget> listTile = [];
    listTile.add(
      ListTile(
        leading: const Icon(Icons.edit),
        title: const Text('Palpites'),
        onTap: () {
          onTapCallback(bets);
          Navigator.pop(context);
        },
      ),
    );
    listTile.add(
      ListTile(
        leading: const Icon(Icons.leaderboard),
        title: const Text('Ranking'),
        onTap: () {
          onTapCallback(ranking);
          Navigator.pop(context);
        },
      ),
    );
    return listTile;
  }
}
