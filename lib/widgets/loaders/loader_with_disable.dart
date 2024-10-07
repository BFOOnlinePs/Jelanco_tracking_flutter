import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/widgets/loaders/my_loader.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class LoaderWithDisable extends StatelessWidget {
  const LoaderWithDisable({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Modal barrier to disable user interactions
        ModalBarrier(
          color: Colors.black.withOpacity(0.5),
          dismissible: false,
        ),
        Center(
          // child: CircularPercentIndicator(
          //   radius: 60.0,
          //   lineWidth: 5.0,
          //   percent: 1.0,
          //   center: new Text("100%"),
          //   progressColor: Colors.green,
          // ),
          child: MyLoader(),
        ),
      ],
    );
  }
}
