import 'package:bolixo/flow/bets/bet_item_view.dart';
import 'package:bolixo/flow/bets/bet_view_content.dart';
import 'package:bolixo/flow/bets/bets_viewcontroller.dart';
import 'package:flutter/material.dart';

import '../../ui/select_date_widget.dart';
import 'bet_view_item_view.dart';

class BetsWidget extends StatefulWidget {
  const BetsWidget({super.key});

  @override
  State<StatefulWidget> createState() => BetsWidgetState();
}

class BetsWidgetState extends State<BetsWidget> {
  List<BetsInDayViewContent> betsByDay = [];
  List<BetsByBolaoAndMatchViewContent> betsByBolaoAndMatch = [];
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
          height: 200,
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
                  return GestureDetector(
                    onTap: () {
                      print ("tapped");
                      if (betsByDay[dateIndex].betList[index].model.match?.matchDate.isBefore(DateTime.now().toUtc()) == true) {
                        viewController.getBetsByBolaoAndMatch(betsByDay[dateIndex].betList[index].model.match?.id);
                        print ("mostrou os palpites");
                      }
                    },
                    child:  BetItemView(
                      bet: betsByDay[dateIndex].betList[index],
                      homeGoalsChanged: (goals) =>
                          viewController.onGoalsTeam1Changed(index, goals),
                      awayGoalsChanged: (goals) =>
                          viewController.onGoalsTeam2Changed(index, goals),
                    ),
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

  void updateViewBets(List<BetsByBolaoAndMatchViewContent> newBets) {
    setState(() {
      betsByBolaoAndMatch = newBets;
      isLoading = false;
    });
  }

  Widget scoreOverview() {
    return Container(
      alignment: Alignment.topRight,
      padding: const EdgeInsets.only(top: 15),
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

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  void showBetsByMatch() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true, // set this to true
        builder: (_) {
          return DraggableScrollableSheet(
            expand: false,
            builder: (_, controller) {
              return Container(
                // color: Colors.blue[500],
                child: ListView.builder(
                  controller: controller, // set this too
                  itemBuilder: (context, index) {
                    return BetViewItemView(
                      bet: betsByBolaoAndMatch[index]
                    );
                  },
                ),
              );
            },
          );
        });
  }
}
