import 'package:bolixo/flow/bets/bet_item_view.dart';
import 'package:bolixo/flow/bets/bet_view_content.dart';
import 'package:bolixo/flow/bets/bets_viewcontroller.dart';
import 'package:flutter/material.dart';

import '../../ui/select_date_widget.dart';

class BetsWidget extends StatefulWidget {

  const BetsWidget({super.key});

  @override
  State<StatefulWidget> createState() => BetsWidgetState();
}

class BetsWidgetState extends State<BetsWidget> {

  List<BetsInDayViewContent> betsByDay = [];
  int dateIndex = 0;
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
        SizedBox(
          height: 170,
          child: SelectDateWidget(
            viewContent: DateSelectionViewContent.from(betsByDay.map((e) => e.date).toList(), dateIndex),
            onTapCallback: (int index) => viewController.onDateChanged(index),
          ),
        ),
        Expanded(
          child: Scaffold(
            body: Container(
              padding: const EdgeInsets.all(24),
              color: Colors.white,
              child: ListView.separated(
                itemCount: betsByDay[dateIndex].betList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return BetItemView(
                    bet: betsByDay[dateIndex].betList[index],
                    homeGoalsChanged: (goals) => viewController.onGoalsTeam1Changed(index, goals),
                    awayGoalsChanged: (goals) => viewController.onGoalsTeam2Changed(index, goals),
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

  void update(List<BetsInDayViewContent> newBets) {
    setState(()
    {
      betsByDay = newBets;
    });
  }

  void updateDate(int newDateIndex) {
    setState(()
    {
      dateIndex = newDateIndex;
    });
  }
}