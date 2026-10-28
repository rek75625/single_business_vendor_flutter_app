import 'package:flutter/material.dart';
import 'package:single_business_vendor_flutter_app/features/catalog/domain/models/product_model.dart';
import 'package:single_business_vendor_flutter_app/core/components/rating_bar.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onAddToCart;
  final bool isFavorite;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.onFavoriteToggle,
    this.onAddToCart,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasDiscount = product.originalPrice != null &&
                        product.originalPrice! > product.price;

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with favorite button
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: Icon(
                        Icons.image_not_supported,
                        size: 48,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
                // Favorite button
                if (onFavoriteToggle != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey[700],
                          size: 20,
                        ),
                        onPressed: onFavoriteToggle,
                        padding: const EdgeInsets.all(8),
                        constraints: const BoxConstraints(),
                      ),
                    ),
                  ),
                // Discount badge
                if (hasDiscount)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '-${(((product.originalPrice! - product.price) / product.originalPrice!) * 100).round()}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            // Product details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    RatingBar(
                      rating: product.rating,
                      size: 14,
                      showLabel: false,
                    ),
                    const Spacer(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${product.price.toStringAsFixed(0)} EGP',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              if (hasDiscount)
                                Text(
                                  '${product.originalPrice!.toStringAsFixed(0)} EGP',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (onAddToCart != null)
                          SizedBox(
                            width: 32,
                            height: 32,
                            child: IconButton.filled(
                              icon: const Icon(Icons.add, size: 18),
                              onPressed: product.stockQuantity > 0
                                  ? onAddToCart
                                  : null,
                              padding: EdgeInsets.zero,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
