import 'package:bolixo/flow/bets/bet_item_view.dart';
import 'package:bolixo/flow/bets/bet_view_content.dart';
import 'package:bolixo/flow/bets/bet_viewcontroller.dart';
import 'package:flutter/material.dart';

class BetsWidget extends StatefulWidget {

  const BetsWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return BetsWidgetState();
  }
}

class BetsWidgetState extends State<BetsWidget> {

  List<BetViewContent> bets = [];
  BetViewController viewController = BetViewController();

  @override
  initState() {
    super.initState();
    viewController.onInit(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(24),
        child: ListView.separated(
          itemCount: bets.length,
          itemBuilder: (context, index) {
            return BetItemView(bet: bets[index]);
          },
          separatorBuilder: (context, index) => const SizedBox(
            height: 16
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue,
        child: const Icon(Icons.save)
      ),
    );
  }

  void update(List<BetViewContent> newBets) {
    setState(()
    {
      bets = newBets;
    });
  }
}