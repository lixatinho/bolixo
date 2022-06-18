import 'package:bolixo/flow/bets/bet_item_view.dart';
import 'package:bolixo/flow/bets/bet_view_content.dart';
import 'package:bolixo/flow/bets/bets_viewcontroller.dart';
import 'package:flutter/material.dart';

import 'SelectDateWidget.dart';

class BetsWidget extends StatefulWidget {

  const BetsWidget({super.key});

  @override
  State<StatefulWidget> createState() => BetsWidgetState();
}

class BetsWidgetState extends State<BetsWidget> {

  List<BetViewContent> bets = [];
  BetsViewController viewController = BetsViewController();

  @override
  initState() {
    super.initState();
    viewController.onInit(this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 170,
          child: SelectDateWidget(),
        ),
        Expanded(
          child: Scaffold(
            body: Container(
              padding: const EdgeInsets.all(24),
              color: Colors.white,
              child: ListView.separated(
                itemCount: bets.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return BetItemView(
                    bet: bets[index],
                    goals1Changed: (goals) => viewController.onGoalsTeam1Changed(index, goals),
                    goals2Changed: (goals) => viewController.onGoalsTeam2Changed(index, goals),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(
                    height: 16
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                  viewController.saveBets();
                },
                backgroundColor: Colors.blue,
                child: const Icon(Icons.save)
            ),
          ),
        )
      ]
    );
  }

  void update(List<BetViewContent> newBets) {
    setState(()
    {
      bets = newBets;
    });
  }
}