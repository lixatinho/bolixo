import 'package:flutter/material.dart';

class Ranking extends StatelessWidget {
  @override
  // Widget build(BuildContext context) {
  //   return const Center(child: Text("Ranking"));
  // }
  Widget build(BuildContext context) {
    final title = 'Score list';
    List<LixoRank> rankeds = [
      LixoRank('Pato', 33.21),
      LixoRank('Peru', 20),
      LixoRank('Pavão', 19)
    ];
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),

        body: ListView.builder(
            itemCount: rankeds.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Text('${index + 1}'),
                title: Text('${rankeds[index].name}'),
                trailing: Text('${rankeds[index].score}'),
              );
            }),
        // body: ListView(
        //   children: <Widget>[
        //     ListTile(
        //       leading: Icon(Icons.one_k),
        //       title: Text('Pato'),
        //     ),
        //     ListTile(
        //       leading: Icon(Icons.two_k),
        //       title: Text('Peru'),
        //     ),
        //     ListTile(
        //       leading: Icon(Icons.three_k),
        //       title: Text('Pavão'),
        //     ),
        //   ],
        // ),
      ),
    );
  }
  // return ListView.builder(
  //   itemCount: rankeds.length,
  //   itemBuilder: (context, index){
  //     return ListTile(
  //       leading: Icon(Icons.arrow_right),
  //       title: Text('${rankeds[index]}'),
  //     );
  //   },
  // );

  // buildListView(){
  //   final itens = List<String>
  //   return ListView.builder(

  //   )
  // }

}

class LixoRank {
  String name = '';
  double score;
  LixoRank(this.name, this.score);
}
