import 'package:audioplayers/audioplayers.dart';
import 'package:bolixo/flow/ranking/ranking_view_content.dart';
import 'package:bolixo/flow/ranking/ranking_viewcontroller.dart';
import 'package:bolixo/ui/shared/loading_widget.dart';
import 'package:bolixo/ui/theme/bolixo_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shake/shake.dart';

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
  late ShakeDetector shakeDetector;
  late bool isShitted = false;

  @override
  initState() {
    super.initState();
    viewController.onInit(this);
    shakeDetector = ShakeDetector.autoStart(
      onPhoneShake: (_) {
        viewController.onShake();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isShitted) {
      return Container(
        alignment: Alignment.center,
        color: Colors.black,
        child: Image.asset('assets/images/spiderman.gif'),
      );
    } else if (viewContent.isLoading) {
      return const LoadingWidget();
    } else {
      return Container(
        color: BolixoColors.backgroundPrimary,
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Table headers
            Padding(
              padding: EdgeInsets.symmetric(horizontal: viewContent.padding),
              child: Row(
                children: viewContent.infoHeaders.values.map((header) {
                  return tableHeader(header.id, header.widthWeight, header.name, header.textColor);
                }).toList(),
              ),
            ),
            const SizedBox(height: 8),
            // Ranking list
            Expanded(
              child: ListView.builder(
                itemCount: viewContent.rankingItems.length,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  final item = viewContent.rankingItems[index];
                  return Container(
                    color: item.backgroundColor,
                    height: 60,
                    padding: EdgeInsets.symmetric(horizontal: viewContent.padding),
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationX(item.rotationAngle),
                      child: GestureDetector(
                        onDoubleTap: () {
                          viewController.onRankingItemTap(item.position);
                        },
                        child: Row(
                          children: <Widget>[
                            // Position
                            Expanded(
                              flex: 1,
                              child: Text(
                                item.position,
                                style: GoogleFonts.poppins(
                                  color: BolixoColors.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            // Avatar
                            imageCell(2, item.avatarUrl, item.borderColor),
                            // Name
                            textCell(6, item.name),
                            // Flies
                            textCell(3, item.flies),
                            // Points
                            textCell(3, item.points),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
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
          style: GoogleFonts.inter(
            color: BolixoColors.textPrimary,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget imageCell(int widthWeight, String url, Color borderColor) {
    return Expanded(
      flex: widthWeight,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          height: 36,
          width: 36,
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
            backgroundColor: BolixoColors.surfaceCard,
          ),
        ),
      ),
    );
  }

  Widget tableHeader(int id, int widthWeight, String text, Color textColor) {
    final isSelected = viewContent.selectedSort == id;
    return Expanded(
      flex: widthWeight,
      child: InkWell(
        onTap: () {
          viewController.onSortSelected(id);
        },
        child: Container(
          height: 40,
          alignment: Alignment.centerLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: GoogleFonts.inter(
                  color: textColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (isSelected)
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  height: 2,
                  width: 20,
                  decoration: BoxDecoration(
                    color: BolixoColors.textLink,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    shakeDetector.stopListening();
    viewController.onDispose();
  }

  void update(RankingViewContent newViewContent) {
    setState(() {
      viewContent = newViewContent;
    });
  }

  Future<void> playLoserSong() async {
    winnerPlayer.stop();
    if (loserPlayer.state == PlayerState.playing) {
      await loserPlayer.stop();
    } else {
      await loserPlayer.play(
        AssetSource('audio/darkness.mp3'),
        volume: 1.0,
      );
    }
  }

  Future<void> playChampionSong() async {
    await loserPlayer.stop();
    if (winnerPlayer.state == PlayerState.playing) {
      await winnerPlayer.stop();
    } else {
      await winnerPlayer.play(
        AssetSource('audio/champ.mp3'),
        volume: 1.0,
      );
    }
  }

  void makeShit() {
    setState(() {
      isShitted = true;
    });
  }
}
