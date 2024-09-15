import 'package:flutter/cupertino.dart';

class MyCachedImageBuilder extends StatelessWidget {
  final ImageProvider imageProvider;

  const MyCachedImageBuilder({super.key, required this.imageProvider});

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: radius * 2,
      // height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
