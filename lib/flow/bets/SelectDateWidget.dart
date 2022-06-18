import 'package:flutter/material.dart';

class SelectDateWidget extends StatefulWidget {

  const SelectDateWidget({super.key});

  @override
  State<StatefulWidget> createState() => SelectDateState();
}

class SelectDateState extends State<SelectDateWidget> {

  @override
  initState() {
    super.initState();
  }

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
                  child: Container(
                    padding: const EdgeInsets.only(left: 18, right: 18, top: 12, bottom: 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(bottom: 4),
                          child: Text('6',
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.white
                            ),
                          )
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 0),
                          child: Text('Tu',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white
                            ),
                          )
                        )
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder:(context, index) => const SizedBox(
                  width: 6
              ),
              itemCount: 15
            ),
          )
        ]
      ),
    );
  }
}
