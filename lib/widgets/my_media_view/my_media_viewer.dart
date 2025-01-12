import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jelanco_tracking_system/core/utils/clip_board_utils.dart';
import 'package:jelanco_tracking_system/core/utils/gallery_utils.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/videos_modules/video_player_screen.dart';
import 'package:jelanco_tracking_system/widgets/snack_bar/my_snack_bar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:saver_gallery/saver_gallery.dart';

// photos and videos viewer
class MyMediaViewer extends StatefulWidget {
  final String storagePath;
  final List<MediaItem> mediaList;
  final int startIndex;

  const MyMediaViewer({
    required this.storagePath,
    required this.mediaList,
    required this.startIndex,
    super.key,
  });

  @override
  MyMediaViewerState createState() => MyMediaViewerState();
}

class MyMediaViewerState extends State<MyMediaViewer> {
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

  Future<bool> saveMediaToGallery() async {
    try {
      final currentMedia = widget.mediaList[_pageController.page!.toInt()];
      final url = widget.storagePath + currentMedia.url;

      final tempDir = await getTemporaryDirectory();
      final localFilePath = "${tempDir.path}/${currentMedia.url.split('/').last}";

      final response = await Dio().download(url, localFilePath);

      if (response.statusCode == 200) {
        final result = await SaverGallery.saveFile(
          filePath: localFilePath,
          fileName: currentMedia.url.split('/').last,
          skipIfExists: false,
        );

        if (result.isSuccess) {
          print("تم الحفظ بنجاح");
          return true;
        } else {
          print("Failed to save the file: $result");
          return false;
        }
      } else {
        print("Failed to download file. Status code: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error saving file: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () async {
              final mediaItem = widget.mediaList[_pageController.page!.toInt()];
              final link = widget.storagePath + mediaItem.url;

              if (await ClipBoardUtils.copyToClipboard(link) == true) {
                print("تم نسخ الرابط إلى الحافظة، يمكنك مشاركته الان.");
                SnackbarHelper.showSnackbar(
                    context: context, snackBarStates: SnackBarStates.none, message: 'تم نسخ الرابط إلى الحافظة، يمكنك مشاركته الان.');
              } else {
                print("فشل نسخ الرابط");
                SnackbarHelper.showSnackbar(context: context, snackBarStates: SnackBarStates.none, message: 'فشل نسخ الرابط.');
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () async {
              final currentMedia = widget.mediaList[_pageController.page!.toInt()];
              final url = widget.storagePath + currentMedia.url;

              if (await GalleryUtils.saveMediaToGallery(url: url)) {
                SnackbarHelper.showSnackbar(context: context, snackBarStates: SnackBarStates.none, message: 'تم الحفظ بنجاح.');
              } else {
                SnackbarHelper.showSnackbar(context: context, snackBarStates: SnackBarStates.none, message: 'فشل الحفظ.');
              }
            },
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.mediaList.length,
        itemBuilder: (context, index) {
          final mediaItem = widget.mediaList[index];
          if (mediaItem.type == MediaType.image) {
            return PhotoView(
              imageProvider: CachedNetworkImageProvider(widget.storagePath + mediaItem.url),
              backgroundDecoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
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
