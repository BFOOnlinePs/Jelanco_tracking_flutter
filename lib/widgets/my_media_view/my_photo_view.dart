import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

// used when opining profile picture

class MyPhotoView extends StatelessWidget {
  final String storagePath;
  final List<String> imagesUrls;
  final int startedIndex;
  final ValueChanged<int>? onPageChanged;

  const MyPhotoView({
    super.key,
    required this.imagesUrls,
    required this.storagePath,
    required this.startedIndex,
    this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController(initialPage: startedIndex);

    return PhotoViewGallery.builder(
      scrollPhysics: const BouncingScrollPhysics(),
      builder: (BuildContext context, int index) {
        return PhotoViewGalleryPageOptions(
          imageProvider: NetworkImage(storagePath + imagesUrls[index]),
          initialScale: PhotoViewComputedScale.contained,
          heroAttributes: PhotoViewHeroAttributes(tag: imagesUrls[index]),
        );
      },
      itemCount: imagesUrls.length,
      onPageChanged: onPageChanged,
      pageController: pageController,
      backgroundDecoration: const BoxDecoration(color: Colors.black),
    );
  }
}
