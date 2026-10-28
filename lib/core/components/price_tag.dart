import 'package:flutter/material.dart';
import 'package:single_business_vendor_flutter_app/core/extensions/number_extensions.dart';

class PriceTag extends StatelessWidget {
  final double price;
  final double? originalPrice;
  final double fontSize;
  final FontWeight? fontWeight;

  const PriceTag({
    super.key,
    required this.price,
    this.originalPrice,
    this.fontSize = 16,
    this.fontWeight,
  });

  bool get hasDiscount => originalPrice != null && originalPrice! > price;

  double get discountPercentage {
    if (!hasDiscount) return 0;
    return ((originalPrice! - price) / originalPrice!) * 100;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          price.toCurrency(),
          style: theme.textTheme.titleMedium?.copyWith(
            fontSize: fontSize,
            fontWeight: fontWeight ?? FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        if (hasDiscount) ...[
          const SizedBox(width: 8),
          Text(
            originalPrice!.toCurrency(),
            style: theme.textTheme.bodySmall?.copyWith(
              decoration: TextDecoration.lineThrough,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '-${discountPercentage.toStringAsFixed(0)}%',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onErrorContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
