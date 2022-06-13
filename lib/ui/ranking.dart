import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:bolixo/api/api_service.dart';

import '../api/model/rankingModel.dart';

class Ranking extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'Score list';

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
            builder: (context, AsyncSnapshot snapshot) {
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
            }),
      ),
    );
  }
}
