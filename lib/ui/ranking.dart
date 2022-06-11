import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:bolixo/api/api_service.dart';

import '../api/model/rankingModel.dart';

class Ranking extends StatelessWidget {
  @override
  // Widget build(BuildContext context) {
  //   return const Center(child: Text("Ranking"));
  // }
  Widget build(BuildContext context) {
    final title = 'Score list';


    // Future<List<RankingModel>> rankeds = ApiService().getRanking();
    // List<LixoRank> rankeds = [
    //   LixoRank('Pato', 33.21),
    //   LixoRank('Peru', 20),
    //   LixoRank('Pavão', 19)
    // ];
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        // body: ListView.builder(
          body: FutureBuilder(
            future: ApiService().getRanking(),
            builder:(context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              } else {
                var rankeds = snapshot.data;
                return ListView.builder(
                    itemCount: rankeds.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Text('${index + 1}'),
                        title: Text('${rankeds[index].name}'),
                        trailing: Text('${rankeds[index].score}'),
                      );
                    });
              }
            }
          ),
      ),
    );
  }
}

class LixoRank {
  String name = '';
  double score;
  LixoRank(this.name, this.score);
}

