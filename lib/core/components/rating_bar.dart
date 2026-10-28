import 'package:flutter/material.dart';

class RatingBar extends StatelessWidget {
  final double rating;
  final double size;
  final bool showLabel;
  final int maxRating;
  final Color? color;

  const RatingBar({
    super.key,
    required this.rating,
    this.size = 16,
    this.showLabel = false,
    this.maxRating = 5,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final starColor = color ?? const Color(0xFFFFC107); // Amber color for stars

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(maxRating, (index) {
          final difference = rating - index;
          IconData iconData;

          if (difference >= 1) {
            iconData = Icons.star;
          } else if (difference >= 0.5) {
            iconData = Icons.star_half;
          } else {
            iconData = Icons.star_outline;
          }

          return Icon(
            iconData,
            size: size,
            color: starColor,
          );
        }),
        if (showLabel) ...[
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}
