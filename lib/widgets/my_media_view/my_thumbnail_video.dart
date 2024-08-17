import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MyThumbnailVideo extends StatelessWidget {
  final int? index;
  final bool showDeleteIcon; //
  final Widget thumbnail;
  final Function()? onDeletePressed; //
  final double? height;
  final double? videoHeight;
  final EdgeInsetsGeometry? margin;
  final bool showVideoIcon;

  const MyThumbnailVideo({
    super.key,
    this.index,
    this.showDeleteIcon = false,
    this.onDeletePressed,
    this.videoHeight = 220,
    this.height,
    this.margin,
    this.showVideoIcon = false,
    required this.thumbnail,
  });

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
            child: Container(
              height: videoHeight,
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: thumbnail,
              ),
            ),
          ),
          showDeleteIcon
              ? IconButton(
                  onPressed: onDeletePressed,
                  icon: const Icon(
                    Icons.delete_forever,
                    color: Colors.red,
                    size: 30,
                  ),
                  splashRadius: 20,
                )
              : Container(),
          if (showVideoIcon)
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black
                        .withOpacity(0.5),
                  ),
                  child: const Icon(
                    Icons.videocam,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
