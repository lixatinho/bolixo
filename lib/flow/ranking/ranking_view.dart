import 'package:bolixo/flow/ranking/ranking_view_content.dart';
import 'package:bolixo/flow/ranking/ranking_viewcontroller.dart';
import 'package:flutter/material.dart';

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
      return Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          children: [
            Row(
              children: <Widget>[
                tableHeader(2, 'Posição'),
                tableHeader(4, 'Nome'),
                tableHeader(2, 'Moscas'),
                tableHeader(2, 'Pontos'),
              ],
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 20),
                color: Colors.white,
                child: ListView.separated(
                  itemCount: viewContent.rankingItems.length,
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Row(
                        children: <Widget>[
                          textCell(2, '${index + 1}'),
                          textCell(4, viewContent.rankingItems[index].name),
                          textCell(2, viewContent.rankingItems[index].flies),
                          textCell(2, viewContent.rankingItems[index].points),
                        ],
                      )
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                ),
            )
          )
        ]
      ));
    }
  }

  Widget textCell(int widthWeight, String text) {
    return Expanded(
      flex: widthWeight,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black54,
          fontSize: 16
        ),
      )
    );
  }

  Widget tableHeader(int widthWeight, String text) {
    return Expanded(
      flex: widthWeight,
      child: Text(
          text,
          style: const TextStyle(
            color: Colors.indigo,
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),
      )
    );
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
