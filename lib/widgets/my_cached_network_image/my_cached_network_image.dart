import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/widgets/my_cached_network_image/my_shimmer_image_loader.dart';

class MyCachedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit? fit;
  final double? height;
  final double? width;
  final bool isCircle;
  final Widget Function(BuildContext, ImageProvider<Object>)? imageBuilder;

  const MyCachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.fit,
    this.height,
    this.width,
    this.imageBuilder,
    this.isCircle = false,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      placeholder: (context, url) => MyShimmerImageLoader(
        isCircle: isCircle,
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
      imageBuilder: imageBuilder,
      height: height,
      width: width,
    );
  }
}
