import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:single_business_vendor_flutter_app/features/catalog/presentation/favorites_provider.dart';
import 'package:single_business_vendor_flutter_app/core/components/empty_state_widget.dart';
import 'package:single_business_vendor_flutter_app/core/components/app_cached_image.dart';
import 'package:single_business_vendor_flutter_app/core/components/price_tag.dart';
import 'package:single_business_vendor_flutter_app/core/components/rating_bar.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
      ),
      body: ListenableBuilder(
        listenable: FavoritesProvider.instance,
        builder: (context, _) {
          final favorites = FavoritesProvider.instance;
          final products = favorites.favoriteProducts;

          if (products.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.favorite_outline,
              title: 'No favorites yet',
              subtitle: 'Add products to your favorites to see them here',
              actionLabel: 'Browse Products',
              onAction: () => context.go('/home'),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => context.push('/product/${product.id}'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          AppCachedImage(
                            imageUrl: product.imageUrl,
                            width: double.infinity,
                            height: 140,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Material(
                              color: Colors.white,
                              shape: const CircleBorder(),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  favorites.toggle(product.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${product.name} removed from favorites'),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: Theme.of(context).textTheme.titleSmall,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              RatingBar(
                                rating: product.rating,
                                size: 14,
                                showLabel: true,
                              ),
                              const Spacer(),
                              PriceTag(
                                price: product.price,
                                originalPrice: product.originalPrice,
                                fontSize: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
