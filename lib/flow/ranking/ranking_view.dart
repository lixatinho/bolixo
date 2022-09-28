import 'package:bolixo/flow/bets/bet_item_view.dart';
import 'package:bolixo/flow/bets/bet_view_content.dart';
import 'package:bolixo/flow/bets/bets_viewcontroller.dart';
import 'package:bolixo/flow/ranking/ranking_view_content.dart';
import 'package:bolixo/flow/ranking/ranking_viewcontroller.dart';
import 'package:flutter/material.dart';

import '../../ui/select_date_widget.dart';

class RankingWidget extends StatefulWidget {
  const RankingWidget({super.key});

  @override
  State<StatefulWidget> createState() => RankingWidgetState();
}

class RankingWidgetState extends State<RankingWidget> {
  RankingViewContent viewContent = RankingViewContent();
  RankingViewController viewController = RankingViewController();

  @override
  initState() {
    super.initState();
    viewController.onInit(this);
  }

  @override
  Widget build(BuildContext context) {
    if (viewContent.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      // return Scaffold(
      //   body: Container(
      //     padding: const EdgeInsets.all(24),
      //     color: Colors.white,
      //     child: ListView.separated(
      //       itemCount: viewContent.rankingItems.length,
      //       shrinkWrap: true,
      //       itemBuilder: (context, index) {
      //         return ListTile(
      //           leading: Text('${index + 1}'),
      //           title: Text(viewContent.rankingItems[index].name),
      //           trailing: Text(viewContent.rankingItems[index].points),
      //         );
      //       },
      //       separatorBuilder: (context, index) => const SizedBox(height: 16),
      //     ),
      //   ),
      // );

      return Column(
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Position'),
                Text('name'),
                Text('flies'),
                Text('points'),
              ],
            ),
          ),
          Expanded(
              child: Scaffold(
            body: Container(
              padding: const EdgeInsets.all(24),
              color: Colors.white,
              child: ListView.separated(
                itemCount: viewContent.rankingItems.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('${index + 1}'),
                        Text(viewContent.rankingItems[index].name),
                        Text(viewContent.rankingItems[index].flies),
                        Text(viewContent.rankingItems[index].points),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
              ),
            ),
          ))
        ],
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    viewController.onDispose();
  }

  void update(RankingViewContent newViewContent) {
    setState(() {
      viewContent = newViewContent;
    });
  }
}
