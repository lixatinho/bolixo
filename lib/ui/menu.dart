import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  static const int bets = 1;
  static const ranking = 2;
  Function onTapCallback;

  Menu({Key? key, required this.onTapCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            // <-- SEE HERE
            decoration: BoxDecoration(color: Colors.indigo),
            accountName: Text(
              "Filipe Cardoso",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              "thesoshsusfmasdaru@gmail.com",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            currentAccountPicture: FlutterLogo(),
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Palpites'),
            onTap: () {
              onTapCallback(bets);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.leaderboard),
            title: const Text('Ranking'),
            onTap: () {
              onTapCallback(ranking);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
