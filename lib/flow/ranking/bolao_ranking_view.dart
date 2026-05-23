import 'package:audioplayers/audioplayers.dart';
import 'package:bolixo/flow/ranking/ranking_view_content.dart';
import 'package:bolixo/flow/ranking/ranking_view_interface.dart';
import 'package:bolixo/flow/ranking/ranking_viewcontroller.dart';
import 'package:bolixo/ui/shared/gold_title.dart';
import 'package:bolixo/ui/shared/loading_widget.dart';
import 'package:bolixo/ui/theme/bolixo_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shake/shake.dart';

import '../../cache/bolao_cache.dart';

class BolaoRankingView extends StatefulWidget {
  final int bolaoId;
  final String bolaoName;

  const BolaoRankingView({
    super.key,
    required this.bolaoId,
    required this.bolaoName,
  });

  @override
  State<StatefulWidget> createState() => BolaoRankingViewState();
}

class BolaoRankingViewState extends State<BolaoRankingView> implements RankingViewContract {
  RankingViewContent viewContent = RankingViewContent();
  RankingViewController viewController = RankingViewController();
  final winnerPlayer = AudioPlayer();
  final loserPlayer = AudioPlayer();
  late ShakeDetector shakeDetector;
  bool isShitted = false;

  @override
  void initState() {
    super.initState();
    BolaoCache().updateBolao(widget.bolaoId, widget.bolaoName);
    viewController.onInit(this);
    shakeDetector = ShakeDetector.autoStart(
      onPhoneShake: (_) {
        viewController.onShake();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BolixoColors.backgroundPrimary,
      appBar: AppBar(
        title: GoldTitle(widget.bolaoName),
        backgroundColor: BolixoColors.deepPlum,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: BolixoColors.textPrimary),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isShitted) {
      return Container(
        alignment: Alignment.center,
        color: BolixoColors.backgroundPrimary,
        child: Image.asset('assets/images/spiderman.gif'),
      );
    } else if (viewContent.isLoading) {
      return const LoadingWidget();
    } else {
      return Column(
        children: [
          const SizedBox(height: 16),
          // Table headers
          Padding(
            padding: EdgeInsets.symmetric(horizontal: viewContent.padding),
            child: Row(
              children: [
                _headerCell('Pos', RankingViewContent.positionHeaderId, width: 40),
                const SizedBox(width: 12),
                _headerCell('', -1, width: 40), // avatar spacer
                const SizedBox(width: 12),
                Expanded(child: _headerCell('Nome', RankingViewContent.nameHeaderId)),
                _headerCell('Mitada', RankingViewContent.fliesHeaderId, width: 60),
                _headerCell('Pts', RankingViewContent.pointsHeaderId, width: 50),
                const SizedBox(width: 48), // detail icon spacer
              ],
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
                final pos = int.tryParse(item.position) ?? 0;
                return Container(
                  color: item.backgroundColor,
                  height: 60,
                  padding: EdgeInsets.symmetric(horizontal: viewContent.padding),
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationX(item.rotationAngle),
                    child: GestureDetector(
                      onDoubleTap: () => viewController.onRankingItemTap(item.position),
                      child: Row(
                        children: [
                          // Position
                          SizedBox(
                            width: 40,
                            child: Text(
                              item.position,
                              style: GoogleFonts.poppins(
                                color: pos <= 3 ? BolixoColors.gold : BolixoColors.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Avatar
                          _avatarCell(item.avatarUrl, item.borderColor),
                          const SizedBox(width: 12),
                          // Name
                          Expanded(
                            child: Text(
                              item.name,
                              style: GoogleFonts.inter(
                                color: BolixoColors.textPrimary,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Flies
                          SizedBox(
                            width: 60,
                            child: Text(
                              item.flies,
                              style: GoogleFonts.inter(color: BolixoColors.textPrimary, fontSize: 14),
                            ),
                          ),
                          // Points
                          SizedBox(
                            width: 50,
                            child: Text(
                              item.points,
                              style: GoogleFonts.inter(
                                color: BolixoColors.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          // Detail icon
                          SizedBox(
                            width: 48,
                            height: 48,
                            child: IconButton(
                              icon: const Icon(Icons.chevron_right, color: BolixoColors.textTertiary, size: 22),
                              onPressed: () => viewController.onUserTap(item.userId, item.name),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    }
  }

  Widget _headerCell(String text, int headerId, {double? width}) {
    final isSelected = viewContent.selectedSort == headerId;
    final child = InkWell(
      onTap: headerId >= 0 ? () => viewController.onSortSelected(headerId) : null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: GoogleFonts.inter(
              color: isSelected ? BolixoColors.textLink : BolixoColors.textTertiary,
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
    );
    if (width != null) return SizedBox(width: width, height: 40, child: child);
    return SizedBox(height: 40, child: child);
  }

  Widget _avatarCell(String url, Color borderColor) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.asset(
        url,
        width: 36,
        height: 36,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: BolixoColors.surfaceCard,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.person, color: BolixoColors.textTertiary, size: 18),
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

  @override
  void update(RankingViewContent newViewContent) {
    setState(() {
      viewContent = newViewContent;
    });
  }

  @override
  Future<void> playLoserSong() async {
    winnerPlayer.stop();
    if (loserPlayer.state == PlayerState.playing) {
      await loserPlayer.stop();
    } else {
      await loserPlayer.play(AssetSource('audio/darkness.mp3'), volume: 1.0);
    }
  }

  @override
  Future<void> playChampionSong() async {
    await loserPlayer.stop();
    if (winnerPlayer.state == PlayerState.playing) {
      await winnerPlayer.stop();
    } else {
      await winnerPlayer.play(AssetSource('audio/champ.mp3'), volume: 1.0);
    }
  }

  @override
  void makeShit() {
    setState(() {
      isShitted = true;
    });
  }
}
