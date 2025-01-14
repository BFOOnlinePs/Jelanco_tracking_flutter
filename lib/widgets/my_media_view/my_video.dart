import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/constants/card_size.dart';
import 'package:video_player/video_player.dart';

class MyVideo extends StatelessWidget {
  final int? index;
  final VideoPlayerController? videoPlayerController;
  final void Function(int index)? onTogglePlayPauseWithIndex;
  final void Function(VideoPlayerController controller)?
      onTogglePlayPauseWithController;
  final bool showDeleteIcon;
  final Function()? onDeletePressed;

  final double? height;
  final double? videoHeight;
  final EdgeInsetsGeometry? margin;
  final bool showTogglePlayPause;
  final bool showVideoIcon;

  const MyVideo({
    super.key,
    this.index,
    this.videoPlayerController,
    this.onTogglePlayPauseWithIndex,
    this.onTogglePlayPauseWithController,
    this.showDeleteIcon = false,
    this.onDeletePressed,
    this.videoHeight = 220,
    this.height = 200,
    this.margin,
    this.showTogglePlayPause = true,
    this.showVideoIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (videoPlayerController?.value.isInitialized == true)
          Container(
            height: height,
            margin: margin,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(CardSizeConstants.mediaRadius)),
              border: Border.all(color: Colors.grey),
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(CardSizeConstants.mediaRadius)),
                  child: SizedBox(
                    height: videoHeight,
                    child: AspectRatio(
                      aspectRatio: videoPlayerController!.value.aspectRatio,
                      child: VideoPlayer(videoPlayerController!),
                    ),
                  ),
                ),
                showDeleteIcon
                    ? IconButton(
                        onPressed: onDeletePressed,
                        icon: const Icon(
                          Icons.close,
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
                        padding: const EdgeInsets.all(CardSizeConstants.mediaRadius),
                        // Adjust the padding as needed
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black
                              .withOpacity(0.5), // Semi-transparent background
                        ),
                        child: const Icon(
                          Icons.videocam,
                          color: Colors.white,
                          // Change icon color to contrast with the background
                          size: 30,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        if (showTogglePlayPause)
          Column(
            children: [
              if (videoPlayerController?.value.isInitialized == true)
                SizedBox(
                  width: 112,
                  child: VideoProgressIndicator(
                    videoPlayerController!,
                    allowScrubbing: true,
                  ),
                ),
              videoPlayerController != null
                  ? IconButton(
                      icon: Icon(videoPlayerController!.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow),
                      onPressed: onTogglePlayPauseWithIndex != null
                          ? () {
                              onTogglePlayPauseWithIndex!(index!);
                            }
                          : onTogglePlayPauseWithController != null
                              ? () {
                                  onTogglePlayPauseWithController!(
                                      videoPlayerController!);
                                }
                              : null,
                    )
                  : const Text('no contoller '),
            ],
          ),
      ],
    );
  }
}
