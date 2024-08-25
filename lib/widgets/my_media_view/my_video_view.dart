import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/videos_modules/video_player_screen.dart';

class HorizontalVideoViewer extends StatefulWidget {
  final String storagePath;
  final List<String> videoUrls;
  final int startIndex;

  // final List<VideoPlayerScreen> videoPlayerScreens;

  const HorizontalVideoViewer({
    super.key,
    required this.storagePath,
    required this.videoUrls,
    required this.startIndex,
    // required this.videoPlayerScreens,
  });

  @override
  _HorizontalVideoViewerState createState() => _HorizontalVideoViewerState();
}

class _HorizontalVideoViewerState extends State<HorizontalVideoViewer> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    // Initialize the PageController with the startIndex
    _pageController = PageController(initialPage: widget.startIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.horizontal,
        itemCount: widget.videoUrls.length,
        itemBuilder: (context, index) {
          return VideoPlayerScreen(
            videoUrl: '${widget.storagePath}${widget.videoUrls[index]}',
          );
        },
      ),
    );
  }
}
