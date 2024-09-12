import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/widgets/loaders/my_loader.dart';

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
        const Center(
          child: MyLoader(),
        ),
      ],
    );
  }
}
