import 'package:bolixo/flow/bets/bet_view_content.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SelectDateWidget extends StatelessWidget {

  List<DateViewContent> dates;
  Function onTapCallback;

  SelectDateWidget({
    super.key,
    required this.dates,
    required this.onTapCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.indigo,
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 16, top: 24, bottom: 24),
              child: Text('6 July, 2022',
                style: TextStyle(
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
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                  color: const Color(0xFF5670C7),
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
                                child: Text(dates[index].monthDay(),
                                  style: const TextStyle(
                                      fontSize: 22,
                                      color: Colors.white
                                  ),
                                )
                            ),
                            Padding(
                                padding: const EdgeInsets.only(bottom: 0),
                                child: Text(dates[index].weekDay(),
                                  style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.white
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
              itemCount: dates.length
            ),
          )
        ]
      ),
    );
  }
}

class DateViewContent {
  DateTime date;

  DateViewContent({
    required this.date
  });

  String weekDay() {
    return  DateFormat('E').format(date);
  }

  String monthDay() {
    return date.day.toString();
  }
}