import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final double rating;
  final int starCount;
  final double starSize;
  final Color activeColor;
  final Color inactiveColor;
  final ValueChanged<double>? onRatingChanged;

  const StarRating({
    super.key,
    required this.rating,
    this.starCount = 5,
    this.starSize = 24.0,
    this.activeColor = Colors.amber,
    this.inactiveColor = Colors.grey,
    this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(starCount, (index) {
        return GestureDetector(
          onTap: onRatingChanged != null ? () => onRatingChanged!((index + 1).toDouble()) : null,
          child: Icon(
            index < rating.floor()
                ? Icons.star // Full star
                : (index < rating ? Icons.star_half : Icons.star_border), // Half or empty star
            color: index < rating ? activeColor : inactiveColor,
            size: starSize,
          ),
        );
      }),
    );
  }
}
