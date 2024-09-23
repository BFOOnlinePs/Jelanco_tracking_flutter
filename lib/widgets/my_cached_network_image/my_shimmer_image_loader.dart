import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MyShimmerImageLoader extends StatelessWidget {
  // final double width;
  // final double height;
  final bool isCircle;

  const MyShimmerImageLoader({
    super.key,
    // this.width = 100.0,
    // this.height = 100.0,
    this.isCircle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        // width: width,
        // height: height,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: isCircle ? null : BorderRadius.circular(8.0), // Optional for rectangle
        ),
      ),
    );
  }
}

// class MyShimmerImageLoader extends StatelessWidget {
//   const MyShimmerImageLoader({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       child: Container(
//         color: Colors.grey[300],
//         // No height or width specified, it will adapt to the parent
//       ),
//     );
//   }
// }
