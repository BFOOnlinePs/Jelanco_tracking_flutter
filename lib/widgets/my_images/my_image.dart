import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyImage extends StatelessWidget {
  final double height;
  final EdgeInsetsGeometry? margin;
  final Widget child;
  final bool showDeleteIcon;
  final Function()? onDeletePressed;

  const MyImage(
      {required this.height,
      this.margin,
      required this.child,
      this.showDeleteIcon = false,
      this.onDeletePressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: Border.all(color: Colors.grey),
      ),
      child: Stack(
        children: [
          ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              child: child),
          showDeleteIcon
              ? IconButton(
                  onPressed: onDeletePressed,
                  icon: Icon(
                    Icons.delete_forever,
                    color: Colors.red,
                    size: 30,
                  ),
                  splashRadius: 20,
                )
              : Text(''),
        ],
      ),
    );
  }
}
