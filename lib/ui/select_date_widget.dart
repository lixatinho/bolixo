import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'shared/ferret_animation.dart';
import 'theme/bolixo_colors.dart';
import 'theme/bolixo_typography.dart';

class SelectDateWidget extends StatefulWidget {
  final DateSelectionViewContent viewContent;
  final Function onTapCallback;

  const SelectDateWidget({
    super.key,
    required this.viewContent,
    required this.onTapCallback,
  });

  @override
  State<SelectDateWidget> createState() => _SelectDateWidgetState();
}

class _SelectDateWidgetState extends State<SelectDateWidget> {
  final GlobalKey<FerretAnimationState> _ferretKey = GlobalKey();

  void _onPointerMove(PointerMoveEvent event) {
    final direction = (event.delta.dx / 6.0).clamp(-1.0, 1.0);
    _ferretKey.currentState?.setDirection(direction);
  }

  void _onPointerUp(PointerUpEvent event) {
    _ferretKey.currentState?.resetDirection();
  }

  void _onPointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent) {
      // Trackpad/mouse wheel: use horizontal or vertical scroll delta
      final dx = event.scrollDelta.dx != 0
          ? event.scrollDelta.dx
          : event.scrollDelta.dy;
      final direction = (dx / 30.0).clamp(-1.0, 1.0);
      _ferretKey.currentState?.setDirection(direction);
      Future.delayed(const Duration(milliseconds: 200), () {
        _ferretKey.currentState?.resetDirection();
      });
    }
  }

  void _onDateTap(int index) {
    _ferretKey.currentState?.bounce();
    widget.onTapCallback(index);
  }

  @override
  Widget build(BuildContext context) {
    Intl.defaultLocale = 'pt_BR';
    return Container(
      width: double.infinity,
      color: BolixoColors.deepPlum,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          children: [
            // Full date - centered
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 16),
              child: Text(
                widget.viewContent.selectedDate().fullDate,
                style: BolixoTypography.headlineMedium,
              ),
            ),
            // Date chips with ferret BEHIND
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // Ferret behind - Rive animated (or fallback with idle breathing)
                  Positioned(
                    bottom: -4,
                    child: FerretAnimation(
                      key: _ferretKey,
                      width: 80,
                      height: 110,
                    ),
                  ),
                  // Date chips on top
                  Center(
                    child: Listener(
                      onPointerMove: _onPointerMove,
                      onPointerUp: _onPointerUp,
                      onPointerSignal: _onPointerSignal,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (int index = 0;
                                index < widget.viewContent.dates.length;
                                index++) ...[
                              if (index > 0) const SizedBox(width: 8),
                              _buildDateChip(index),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateChip(int index) {
    final date = widget.viewContent.dates[index];
    final isSelected = index == widget.viewContent.selectedIndex;
    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? BolixoColors.accentGreen
            : BolixoColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: isSelected
            ? null
            : Border.all(color: BolixoColors.white10, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _onDateTap(index),
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 18, vertical: 8),
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
                    color: isSelected
                        ? BolixoColors.textPrimary
                        : BolixoColors.textSecondary,
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

  static DateSelectionViewContent from(
      List<DateTime> dates, int selectedIndex) {
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
