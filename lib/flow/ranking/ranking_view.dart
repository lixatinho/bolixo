import 'package:audioplayers/audioplayers.dart';
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
  final winnerPlayer = AudioPlayer();
  final loserPlayer = AudioPlayer();

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
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: viewContent.padding, right: viewContent.padding),
              child: Row(
                children: viewContent.infoHeaders.values.map((header) {
                  return tableHeader(header.id, header.widthWeight, header.name, header.textColor);
                }).toList(),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.zero,
                color: Colors.white,
                child: ListView.separated(
                  itemCount: viewContent.rankingItems.length,
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      color: viewContent.rankingItems[index].backgroundColor,
                      height: 60,
                      padding: EdgeInsets.only(left: viewContent.padding, right: viewContent.padding),
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationX(viewContent.rankingItems[index].rotationAngle),
                        child: GestureDetector(
                          onDoubleTap: () {
                            viewController.onRankingItemTap(viewContent.rankingItems[index].position);
                          },
                          child: Row(
                            children: <Widget>[
                              textCell(1, viewContent.rankingItems[index].position),
                              imageCell(2, viewContent.rankingItems[index].avatarUrl, viewContent.rankingItems[index].borderColor),
                              textCell(6, viewContent.rankingItems[index].name),
                              textCell(3, viewContent.rankingItems[index].flies),
                              textCell(3, viewContent.rankingItems[index].points),
                            ],
                          )
                        ),
                      )
                    );
                  }, separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 0, height: 0,),
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
      child: Container(
        height: 50,
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14
          ),
        )
      )
    );
  }

  Widget imageCell(int widthWeight, String url, Color borderColor) {
    return Expanded(
        flex: widthWeight,
        child: Align (
          alignment: Alignment.centerLeft,
          child: Container(
            height: 30,
            width: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: borderColor,
                width: 2.0,
              ),
            ),
            child: CircleAvatar(
              foregroundImage: NetworkImage(url),
            ),
          )
        )
    );
  }

  Widget tableHeader(int id, int widthWeight, String text, Color textColor) {
    return Expanded(
      flex: widthWeight,
      child: InkWell(
        onTap: () { viewController.onSortSelected(id); },
        child: Container(
          height: 50,
          alignment: Alignment.centerLeft,
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold
            ),
          )
        )
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

  Future<void> playLoserSong() async {
    winnerPlayer.stop();
    if(loserPlayer.state == PlayerState.playing) {
      await loserPlayer.stop();
    } else {
      await loserPlayer.play(
          AssetSource('audio/darkness.mp3'),
          volume: 1.0
      );
    }
  }

  Future<void> playChampionSong() async {
    await loserPlayer.stop();
    if(winnerPlayer.state == PlayerState.playing) {
      await winnerPlayer.stop();
    } else {
      await winnerPlayer.play(
          AssetSource('audio/champ.mp3'),
          volume: 1.0
      );
    }
  }
}
