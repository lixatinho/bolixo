import 'package:bolixo/ui/palpite.dart';
import 'package:flutter/widgets.dart';

class Palpites extends StatefulWidget {

  const Palpites({super.key});

  @override
  State<StatefulWidget> createState() {
    return PalpiteState();
  }
}

class PalpiteState extends State<Palpites> {

  final palpites = [
    PalpiteModel(),
    PalpiteModel(),
    PalpiteModel(),
    PalpiteModel(),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: palpites.length,
      itemBuilder: (context, index) {
        return Palpite(palpites[index]);
      },
      separatorBuilder: (context, index) => const SizedBox(
        height: 30
      ),
    );
  }
}

class PalpiteModel {

}