import 'package:bolixo/api/service/api_service.dart';
import 'package:flutter/material.dart';

class Ranking extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const title = 'Score list';

    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
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
                  title: Text('${rankeds[index].user.name}'),
                  trailing: Text('${rankeds[index].score}'),
                );
              });
          }
        }),
    );
  }
}
