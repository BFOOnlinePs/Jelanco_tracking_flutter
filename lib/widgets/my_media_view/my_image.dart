import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/constants/card_size.dart';

class MyImage extends StatelessWidget {
  final double height;
  final double width;
  final EdgeInsetsGeometry? margin;
  final Widget child;
  final bool showDeleteIcon;
  final Function()? onDeletePressed;

  const MyImage({
    super.key,
    required this.height,
    this.width = 136,
    this.margin = const EdgeInsetsDirectional.only(end: 8),
    required this.child,
    this.showDeleteIcon = false,
    this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: height,
      // width: width,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(CardSizeConstants.mediaRadius)),
        border: Border.all(color: Colors.grey),
      ),
      child: Stack(
        children: [
          ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(CardSizeConstants.mediaRadius)),
              child: child),
          showDeleteIcon
              ? IconButton(
                  onPressed: onDeletePressed,
                  icon: Icon(
                    Icons.close,
                    color: Colors.red,
                    size: 30,
                  ),
                  splashRadius: 20,
                )
              : Container(),
        ],
      ),
    );
  }
}
