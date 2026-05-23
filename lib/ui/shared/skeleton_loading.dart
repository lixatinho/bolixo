import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/bolixo_colors.dart';

/// Skeleton shimmer loading placeholder.
/// Shows a shimmering layout that mimics the real content structure.
class SkeletonLoading extends StatelessWidget {
  final SkeletonType type;

  const SkeletonLoading({super.key, this.type = SkeletonType.list});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: BolixoColors.surfaceCard,
      highlightColor: BolixoColors.surfaceElevated,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: _buildLayout(),
      ),
    );
  }

  Widget _buildLayout() {
    switch (type) {
      case SkeletonType.list:
        return Column(
          children: List.generate(4, (_) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _SkeletonCard(),
          )),
        );
      case SkeletonType.detail:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SkeletonBox(width: double.infinity, height: 40),
            const SizedBox(height: 16),
            _SkeletonBox(width: 200, height: 16),
            const SizedBox(height: 24),
            _SkeletonBox(width: double.infinity, height: 120),
            const SizedBox(height: 16),
            _SkeletonBox(width: double.infinity, height: 120),
          ],
        );
      case SkeletonType.buttonInline:
        return _SkeletonBox(width: double.infinity, height: 48);
    }
  }
}

class _SkeletonCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BolixoColors.surfaceCard,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          _SkeletonBox(width: 40, height: 40, radius: 10),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SkeletonBox(width: 140, height: 14),
                const SizedBox(height: 8),
                _SkeletonBox(width: 90, height: 10),
              ],
            ),
          ),
          _SkeletonBox(width: 24, height: 24, radius: 6),
        ],
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const _SkeletonBox({
    required this.width,
    required this.height,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: BolixoColors.surfaceCard,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

enum SkeletonType { list, detail, buttonInline }
