import 'package:bolixo/flow/bets/competitions_bets_view.dart';
import 'package:flutter/material.dart';

import '../home.dart';

void navigateToHome(BuildContext context, {bool redirectBoloes = false}) {
  if (redirectBoloes) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const CompetitionsBetsView(),
        settings: const RouteSettings(name: '/competitions_bets'),
      )
    );
  } else {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const CompetitionsBetsView(),
        settings: const RouteSettings(name: '/competitions_bets'),
      )
    );
  }
}
