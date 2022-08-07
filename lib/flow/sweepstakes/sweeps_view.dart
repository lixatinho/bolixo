import 'package:flutter/material.dart';

class SweepsWidget extends StatefulWidget {
  const SweepsWidget({Key? key}) : super(key: key);

  @override
  State<SweepsWidget> createState() => _SweepsWidgetState();
}

class _SweepsWidgetState extends State<SweepsWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(24),
        color: Colors.white,
        child: ListView.separated(
          itemCount: 1,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Text('${index + 1}'),
              title: Text('teste'),
              trailing: Text('1'),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 16),
        ),
      ),
    );
  }
}
