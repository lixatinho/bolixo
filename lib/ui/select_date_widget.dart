import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SelectDateWidget extends StatelessWidget {

  final DateSelectionViewContent viewContent;
  final Function onTapCallback;
  static const ferretOffset = 50.0;

  const SelectDateWidget({
    super.key,
    required this.viewContent,
    required this.onTapCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.indigo,
      padding: const EdgeInsets.only(bottom: 0),
      child: Stack(
        children: [
          ferret(),
          dateSelectionWidget(),
          ferretLeftHand(),
          ferretRightHand(),
        ]
      )
    );
  }

  Widget ferret() {
    return const Positioned(
      top: 10,
      right: ferretOffset,
      child: Image(
        image: AssetImage('assets/images/ferret.png'),
        width: 100,
        height: 210,
      )
    );
  }

  Widget ferretLeftHand() {
    return const Positioned(
        top: 64,
        right: ferretOffset + 100,
        child: Image(
          image: AssetImage('assets/images/ferretLeft.png'),
          width: 32,
          height: 32,
        )
    );
  }

  Widget ferretRightHand() {
    return const Positioned(
        top: 56,
        right: ferretOffset - 30,
        child: Image(
          image: AssetImage('assets/images/ferretRight.png'),
          width: 32,
          height: 32,
        )
    );
  }

  Widget dateSelectionWidget() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, top: 24, bottom: 24),
              child: Text(viewContent.selectedDate().fullDate,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder:  (context, index) {
                final date = viewContent.dates[index];
                return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    color: date.backgroundColor,
                    child:
                    InkWell(
                      onTap: () {
                        onTapCallback(index);
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 18, right: 18, top: 12, bottom: 12),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(date.monthDay,
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: date.fontColor
                                  ),
                                )
                            ),
                            Padding(
                                padding: const EdgeInsets.only(bottom: 0),
                                child: Text(date.weekDay,
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: date.fontColor
                                  ),
                                )
                            )
                          ],
                        ),
                      ),
                    )
                );
              },
              separatorBuilder:(context, index) => const SizedBox(
                  width: 6
              ),
              itemCount: viewContent.dates.length
            ),
          ),
        ]
      )
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
    final weekDayFormat = DateFormat('E');
    final monthDayFormat = DateFormat('d');
    final fullDateFormat = DateFormat('d MMMM, y');

    return DateSelectionViewContent(
        dates: dates.asMap().map((i, date) => MapEntry(i, DateViewContent(
          date: date,
          backgroundColor: i == selectedIndex ? Colors.white : const Color(0xFF5670C7),
          fontColor: i == selectedIndex ? Colors.black87 : Colors.white,
          weekDay: weekDayFormat.format(date),
          monthDay: monthDayFormat.format(date),
          fullDate: fullDateFormat.format(date)
        ))).values.toList().cast<DateViewContent>(),
        selectedIndex: selectedIndex
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