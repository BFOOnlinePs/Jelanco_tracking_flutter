import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/widgets/loaders/my_loader.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class LoaderWithDisable extends StatelessWidget {
  final bool isShowMessage;

  const LoaderWithDisable({super.key, this.isShowMessage = false});

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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MyLoader(
                color: isShowMessage ? Colors.white : null,
              ),
              // if (isShowMessage) Text('الرجاء الانتظار لحين اكتمال العملية'),

              SizedBox(height: 16), // Spacing between the loader and message
              if (isShowMessage)
                Text(
                  'يُرجى الانتظار' '\n' 'قد تستغرق العملية بعض الوقت',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
