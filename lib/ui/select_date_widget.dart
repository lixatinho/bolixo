import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shimmer/shimmer.dart';
import 'theme/bolixo_colors.dart';
import 'theme/bolixo_typography.dart';

class SelectDateWidget extends StatefulWidget {
  final DateSelectionViewContent viewContent;
  final Function onTapCallback;
  final bool isLoading;

  const SelectDateWidget({
    super.key,
    required this.viewContent,
    required this.onTapCallback,
    this.isLoading = false,
  });

  @override
  State<SelectDateWidget> createState() => _SelectDateWidgetState();
}

class _SelectDateWidgetState extends State<SelectDateWidget> {
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _itemKeys = {};

  @override
  void initState() {
    super.initState();
    if (!widget.isLoading) {
      _scrollToSelected();
    }
  }

  @override
  void didUpdateWidget(covariant SelectDateWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.isLoading &&
        (oldWidget.viewContent.selectedIndex != widget.viewContent.selectedIndex ||
            oldWidget.isLoading)) {
      _scrollToSelected();
    }
  }

  void _scrollToSelected() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final key = _itemKeys[widget.viewContent.selectedIndex];
      if (key?.currentContext != null) {
        Scrollable.ensureVisible(
          key!.currentContext!,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: 0.5,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Intl.defaultLocale = 'pt_BR';
    return Container(
      width: double.infinity,
      color: BolixoColors.deepPlum,
      padding: const EdgeInsets.only(top: 20, bottom: 16),
      child: widget.isLoading
          ? IgnorePointer(child: _buildShimmerContent())
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.viewContent.selectedDate().fullDate,
          style: BolixoTypography.headlineMedium,
        ),
        const SizedBox(height: 14),
        SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int index = 0;
                  index < widget.viewContent.dates.length;
                  index++) ...[
                if (index > 0) const SizedBox(width: 10),
                _buildDateChip(index),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Same title but shimmer
        Shimmer.fromColors(
          baseColor: BolixoColors.surfaceCard,
          highlightColor: BolixoColors.surfaceElevated,
          child: Text(
            widget.viewContent.selectedDate().fullDate,
            style: BolixoTypography.headlineMedium,
          ),
        ),
        const SizedBox(height: 14),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int index = 0; index < widget.viewContent.dates.length; index++) ...[
                if (index > 0) const SizedBox(width: 10),
                Shimmer.fromColors(
                  baseColor: BolixoColors.surfaceCard,
                  highlightColor: BolixoColors.surfaceElevated,
                  child: _buildDateChip(index, isShimmer: true),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateChip(int index, {bool isShimmer = false}) {
    final date = widget.viewContent.dates[index];
    final isSelected = index == widget.viewContent.selectedIndex;
    final key = isShimmer ? null : (_itemKeys[index] ??= GlobalKey());

    return Container(
      key: key,
      decoration: BoxDecoration(
        color: isSelected ? BolixoColors.accentBlue : BolixoColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: isSelected ? null : Border.all(color: BolixoColors.white10, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: isShimmer ? null : () => widget.onTapCallback(index),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  date.monthDay,
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: BolixoColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  date.weekDay,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? BolixoColors.textPrimary : BolixoColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DateSelectionViewContent {
  List<DateViewContent> dates;
  int selectedIndex;

  DateSelectionViewContent({
    required this.dates,
    required this.selectedIndex,
  });

  static DateSelectionViewContent from(List<DateTime> dates, int selectedIndex) {
    initializeDateFormatting('pt_BR', null);
    final weekDayFormat = DateFormat('E', 'pt_BR');
    final monthDayFormat = DateFormat('d', 'pt_BR');
    final fullDateFormat = DateFormat('d MMMM, y', 'pt_BR');

    return DateSelectionViewContent(
      dates: dates
          .asMap()
          .map((i, date) => MapEntry(
                i,
                DateViewContent(
                  date: date,
                  backgroundColor: Colors.transparent,
                  fontColor: Colors.white,
                  weekDay: weekDayFormat.format(date),
                  monthDay: monthDayFormat.format(date),
                  fullDate: fullDateFormat.format(date),
                ),
              ))
          .values
          .toList()
          .cast<DateViewContent>(),
      selectedIndex: selectedIndex,
    );
  }

  DateViewContent selectedDate() {
    return dates[selectedIndex];
  }
}

class DateViewContent {
  DateTime date;
  Color backgroundColor;
  Color fontColor;
  String weekDay;
  String monthDay;
  String fullDate;

  DateViewContent({
    required this.date,
    required this.backgroundColor,
    required this.fontColor,
    required this.weekDay,
    required this.monthDay,
    required this.fullDate,
  });
}
