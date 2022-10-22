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
  bool isLoading = true;
  BetsViewController viewController = BetsViewController();

  @override
  initState() {
    super.initState();
    viewController.onInit(this);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Column(children: [
        SizedBox(
          height: 170,
          child: SelectDateWidget(
            viewContent: DateSelectionViewContent.from(
                betsByDay.map((e) => e.date).toList(), dateIndex),
            onTapCallback: (int index) => viewController.onDateChanged(index),
          ),
        ),
        scoreOverview(),
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
                    homeGoalsChanged: (goals) =>
                        viewController.onGoalsTeam1Changed(index, goals),
                    awayGoalsChanged: (goals) =>
                        viewController.onGoalsTeam2Changed(index, goals),
                  );
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
              ),
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                  viewController.saveBets();
                },
                backgroundColor: Colors.blue,
                child: const Icon(Icons.save)),
          ),
        )
      ]);
    }
  }

  @override
  void dispose() {
    super.dispose();
    viewController.onDispose();
  }

  void update(List<BetsInDayViewContent> newBets) {
    setState(() {
      betsByDay = newBets;
      isLoading = false;
    });
  }

  Widget scoreOverview() {
    return Container(
      alignment: Alignment.topRight,
      padding: EdgeInsets.only(top: 15),
      width: 200,
      child: Column(
        children: [
          Text("Fase: ${betsByDay[dateIndex].betList[0].type} "),
          Text(
              "Pontuação do dia: ${betsByDay[dateIndex].totalScore}/${betsByDay[dateIndex].maxScore}"),
          const SizedBox(height: 7),
          LinearProgressIndicator(
            value: betsByDay[dateIndex].accuracy,
            color: Colors.indigoAccent,
          ),
        ],
      ),
    );
  }

  void updateDate(int newDateIndex) {
    setState(() {
      dateIndex = newDateIndex;
    });
  }

  void updateIsLoading(bool newIsLoadingValue) {
    setState(() {
      isLoading = newIsLoadingValue;
    });
  }
}
