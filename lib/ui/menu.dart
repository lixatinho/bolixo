import 'package:bolixo/ui/shared/loading_widget.dart';
import 'package:flutter/material.dart';

import '../flow/auth/auth_repository.dart';
import '../flow/auth/auth_service.dart';

class Menu extends StatefulWidget {
  static const int bets = 1;
  static const ranking = 2;
  static const logoff = 3;
  static const boloes = 4;
  final Function onTapCallback;

  const Menu({super.key, required this.onTapCallback});

  @override
  State<StatefulWidget> createState() {
    return MenuState(onTapCallback: onTapCallback);
  }
}

class MenuState extends State<Menu> {
  bool isLoading = true;
  late AuthRepository repository;
  Function onTapCallback;

  MenuState({Key? key, required this.onTapCallback});

  @override
  Future initialize() async {
    repository = AuthRepository();
    await repository.initialize();
    setState((){
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(isLoading) {
      initialize();
      return const LoadingWidget();
    } else {
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
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: repository.getEasterEggCompleted() ? Colors.amber.shade700 : Colors.transparent,
                        width: 2.0,
                      ),
                    ),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(repository.getAvatarUrl()),
                      backgroundColor: Colors.greenAccent
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(repository.getUsername(),
                        style: const TextStyle(
                          fontSize: 18
                        ),
                      ),
                    )
                  )
                ],
              ),
            ),
            Column(children: bodyMenu(context)),
          ],
        ),
      );
    }
  }

  List<Widget> bodyMenu(context) {
    List<Widget> listTile = [];
    listTile.add(menuListItem(Menu.bets, 'Palpites', Icons.edit, context));
    listTile.add(menuListItem(Menu.ranking, 'Ranking', Icons.leaderboard, context));
    listTile.add(menuListItem(Menu.logoff, 'Logoff', Icons.logout, context, callback: () {AuthService().logOff();}));

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
