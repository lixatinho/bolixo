import 'package:bolixo/ui/shared/navigation.dart';
import 'package:flutter/material.dart';

import 'boloes_view_content.dart';
import 'boloes_viewcontroller.dart';

class BoloesWidget extends StatefulWidget {
  const BoloesWidget({
    Key? key,
  }) : super(key: key);

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
      return Container(
        padding: EdgeInsets.zero,
        color: Colors.white,
        child: ListView.builder(
          itemCount: viewContent.boloes.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Container(
              height: 50,
              color: viewContent.boloes[index].backgroundColor,
              child: InkWell(
                onTap: () {
                  viewController.onBolaoSelected(viewContent.boloes[index].id, viewContent.boloes[index].name);
                  navigateToHome(context);
                },
                child: Center(
                  child: Text(
                    viewContent.boloes[index].name,
                    style: TextStyle(
                      color: viewContent.boloes[index].textColor
                    ),
                  )
                )
              ),
            );
          },
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
