import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'theme/bolixo_colors.dart';
import 'theme/bolixo_typography.dart';

class SelectDateWidget extends StatelessWidget {
  final DateSelectionViewContent viewContent;
  final Function onTapCallback;

  const SelectDateWidget({
    super.key,
    required this.viewContent,
    required this.onTapCallback,
  });

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
                viewContent.selectedDate().fullDate,
                style: BolixoTypography.headlineMedium,
              ),
            ),
            // Date chips with ferret BEHIND
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // Ferret behind - arms stick up above the date chips
                  Positioned(
                    bottom: -4,
                    child: Image.asset(
                      'assets/images/ferretWithArms.png',
                      width: 80,
                      height: 110,
                      fit: BoxFit.contain,
                    ),
                  ),
                  // Date chips on top
                  Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (int index = 0; index < viewContent.dates.length; index++) ...[
                            if (index > 0) const SizedBox(width: 8),
                            _buildDateChip(index),
                          ],
                        ],
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
    final date = viewContent.dates[index];
    final isSelected = index == viewContent.selectedIndex;
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
          onTap: () => onTapCallback(index),
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
