import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/videos_modules/video_player_screen.dart';
import 'package:photo_view/photo_view.dart';

class MediaViewer extends StatefulWidget {
  final String storagePath;
  final List<MediaItem> mediaList;
  final int startIndex;

  const MediaViewer({
    required this.storagePath,
    required this.mediaList,
    required this.startIndex,
    super.key,
  });

  @override
  _MediaViewerState createState() => _MediaViewerState();
}

class _MediaViewerState extends State<MediaViewer> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
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
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.mediaList.length,
        itemBuilder: (context, index) {
          final mediaItem = widget.mediaList[index];
          if (mediaItem.type == MediaType.image) {
            return PhotoView(
              imageProvider: NetworkImage(widget.storagePath + mediaItem.url),
              backgroundDecoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            );
          } else {
            return VideoPlayerScreen(
              videoUrl: widget.storagePath + mediaItem.url,
            );
          }
        },
      ),
    );
  }
}

class MediaItem {
  final MediaType type;
  final String url;

  MediaItem({required this.type, required this.url});
}

enum MediaType { image, video }