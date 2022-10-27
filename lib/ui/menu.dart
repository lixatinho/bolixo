import 'package:flutter/material.dart';

import '../flow/auth/auth_repository.dart';
import '../flow/auth/auth_service.dart';

class Menu extends StatelessWidget {
  static const int bets = 1;
  static const ranking = 2;
  static const logoff = 3;
  static const boloes = 4;
  late AuthRepository repository;
  Function onTapCallback;

  Menu({Key? key, required this.onTapCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    // backgroundImage: NetworkImage(repository.getAvatarUrl()),
                    backgroundImage: NetworkImage("https://lixolao-flags.s3.amazonaws.com/BRA.webp"),
                    backgroundColor: Colors.greenAccent,
                    child: Icon(Icons.check),
                  ),
                ),
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
    listTile.add(menuListItem(bets, 'Palpites', Icons.edit, context));
    listTile.add(menuListItem(ranking, 'Ranking', Icons.leaderboard, context));
    listTile.add(menuListItem(logoff, 'Logoff', Icons.logout, context, callback: () {AuthService().logOff();}));

    return listTile;
  }

  ListTile menuListItem(
    int index,
    String title,
    IconData icon,
    BuildContext context,
    {Function? callback}
  ) {
    return ListTile(
        leading: Icon(icon),
        title: Text(title),
        onTap: () {
          callback?.call();
          onTapCallback(index);
          Navigator.pop(context);
        },
      );
  }
}
