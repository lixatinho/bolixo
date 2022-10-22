import 'package:flutter/material.dart';

import 'boloes_view_content.dart';
import 'boloes_viewcontroller.dart';

class BoloesWidget extends StatefulWidget {
  const BoloesWidget({Key? key}) : super(key: key);

  @override
  State<BoloesWidget> createState() => BoloesWidgetState();
}

class BoloesWidgetState extends State<BoloesWidget> {
  BoloesViewContent viewContent = BoloesViewContent();
  BoloesViewController viewController = BoloesViewController();

  @override
  initState() {
    super.initState();
    viewController.onInit(this);
  }

  @override
  Widget build(BuildContext context) {
    if (viewContent.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
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
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('${index + 1}'),
                    Text(viewContent.boloes[index].name!),
                  ],
                ),
                trailing: Text('1'),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 16),
          ),
        ),
      );
    }
  }

  void update(BoloesViewContent newViewContent) {
    setState(() {
      viewContent = newViewContent;
    });
  }
}
