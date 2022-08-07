import 'package:flutter/material.dart';

import '../flow/auth/auth_service.dart';

class Menu extends StatelessWidget {
  static const int bets = 1;
  static const ranking = 2;
  static const logoff = 3;
  static const sweeps = 4;
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
            accountEmail: const Text(''),
            accountName: Row(
              children: <Widget>[
                Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: const CircleAvatar(
                    backgroundColor: Colors.greenAccent,
                    child: Icon(Icons.check),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const <Widget>[
                    Text(""),
                    Text(""),
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
    listTile.add(
      ListTile(
        leading: const Icon(Icons.select_all),
        title: const Text('Bolões'),
        onTap: () {
          onTapCallback(sweeps);
          Navigator.pop(context);
        },
      ),
    );
    listTile.add(
      ListTile(
        leading: const Icon(Icons.logout),
        title: const Text('Logoff'),
        onTap: () {
          AuthService().logOff();
          onTapCallback(logoff);
          Navigator.pop(context);
        },
      ),
    );

    return listTile;
  }
}
