import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class MyPhotoView extends StatelessWidget {
  final String storagePath;
  final List<String> imagesUrls;
  final int startedIndex;

  const MyPhotoView({
    super.key,
    required this.imagesUrls,
    required this.storagePath,
    required this.startedIndex,
  });

  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController(initialPage: startedIndex);

    return StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          return PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                // imageProvider: AssetImage(widget.galleryItems[index].image),
                imageProvider:
                    NetworkImage(storagePath + imagesUrls[index]),
                initialScale: PhotoViewComputedScale.contained * 0.8,
                heroAttributes:
                    PhotoViewHeroAttributes(tag: imagesUrls[index]),
              );
            },
            itemCount: imagesUrls.length,
            loadingBuilder: (context, event) => Center(
              child:  Container(
                width: 20.0,
                height: 20.0,
                child: const CircularProgressIndicator(
                    // value: event == null
                    //     ? 0
                    //     : event.cumulativeBytesLoaded / event.expectedTotalBytes,
                    ),
              ),
            ),
            backgroundDecoration: const BoxDecoration(
              // color: Colors.transparent,
              color: Colors.black,
            ),
            pageController: pageController,
            // onPageChanged: onPageChanged,
          );
        });
  }
}
