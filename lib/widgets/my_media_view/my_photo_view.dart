import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class MyPhotoView extends StatelessWidget {
  final String imagesHostPath;
  final List<String> galleryItems;
  final int startedIndex;

  const MyPhotoView({
    required this.galleryItems,
    required this.imagesHostPath,
    required this.startedIndex,
  });

  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController(initialPage: startedIndex);

    return StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          return Container(
            // color: Colors.black.withOpacity(0.5),
            child: PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: (BuildContext context, int index) {
                return PhotoViewGalleryPageOptions(
                  // imageProvider: AssetImage(widget.galleryItems[index].image),
                  imageProvider:
                  NetworkImage(imagesHostPath + galleryItems[index]),
                  initialScale: PhotoViewComputedScale.contained * 0.8,
                  heroAttributes: PhotoViewHeroAttributes(tag: galleryItems[index]),
                );
              },
              itemCount: galleryItems.length,
              loadingBuilder: (context, event) => Center(
                child: Container(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(
                    // value: event == null
                    //     ? 0
                    //     : event.cumulativeBytesLoaded / event.expectedTotalBytes,
                  ),
                ),
              ),
              backgroundDecoration: BoxDecoration(
                // color: Colors.transparent,
                color: Colors.black,
              ),
              pageController: pageController,
              // onPageChanged: onPageChanged,
            ),
          );
        }
    );
  }
}