import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MyVideo extends StatelessWidget {
  final int index;
  final VideoPlayerController? videoPlayerController;
  final void Function(int index) onTogglePlayPause;
  final bool showDeleteIcon;
  final Function()? onDeletePressed;
  // final double height;
  final EdgeInsetsGeometry? margin;

  const MyVideo({
    super.key,
    required this.index,
    this.videoPlayerController,
    required this.onTogglePlayPause,
    this.showDeleteIcon = false,
    this.onDeletePressed,
    // required this.height,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (videoPlayerController?.value.isInitialized == true)
          Container(
            // height: height,
            // margin: margin,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              border: Border.all(color: Colors.grey),
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),

                  child: Container(
                    height: 220,
                    child: AspectRatio(

                      aspectRatio: videoPlayerController!.value.aspectRatio,
                      child: VideoPlayer(videoPlayerController!),
                    ),
                  ),
                ),
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
                    : Container(),
              ],
            ),
          ),
        if (videoPlayerController?.value.isInitialized == true)
          Container(
            width: 120,
            child: VideoProgressIndicator(videoPlayerController!,
                allowScrubbing: true),
          ),
        IconButton(
          icon: Icon(videoPlayerController!.value.isPlaying
              ? Icons.pause
              : Icons.play_arrow),
          onPressed: () {
            onTogglePlayPause(index);
          },
        ),
      ],
    );
  }
}
