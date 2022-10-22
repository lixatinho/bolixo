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
      return Scaffold(
        body: Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: ListView.separated(
            itemCount: 1,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
                height: 50,
                color: viewContent.boloes[index].backgroundColor,
                child: InkWell(
                  onTap: () {
                    viewController.onBolaoSelected(viewContent.boloes[index].id);
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
