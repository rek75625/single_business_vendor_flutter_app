import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:single_business_vendor_flutter_app/core/data/mock_data.dart';
import 'package:single_business_vendor_flutter_app/features/catalog/domain/models/product_model.dart';
import 'package:single_business_vendor_flutter_app/features/catalog/presentation/widgets/product_card.dart';
import 'package:single_business_vendor_flutter_app/core/components/empty_state_widget.dart';

enum SortOption { priceAsc, priceDesc, rating, newest }

class CategoryProductsScreen extends StatefulWidget {
  final String categoryId;

  const CategoryProductsScreen({
    super.key,
    required this.categoryId,
  });

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  SortOption _selectedSort = SortOption.newest;

  List<Product> _getSortedProducts() {
    final products = MockData.products
        .where((p) => p.categoryId == widget.categoryId)
        .toList();

    switch (_selectedSort) {
      case SortOption.priceAsc:
        products.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortOption.priceDesc:
        products.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortOption.rating:
        products.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SortOption.newest:
        products.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
    }

    return products;
  }

  String _getSortLabel(SortOption option) {
    switch (option) {
      case SortOption.priceAsc:
        return 'Price: Low to High';
      case SortOption.priceDesc:
        return 'Price: High to Low';
      case SortOption.rating:
        return 'Rating';
      case SortOption.newest:
        return 'Newest';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final category = MockData.categories
        .firstWhere((c) => c.id == widget.categoryId);
    final products = _getSortedProducts();

    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
      ),
      body: Column(
        children: [
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: SortOption.values.map((option) {
                final isSelected = _selectedSort == option;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(_getSortLabel(option)),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedSort = option);
                    },
                    selectedColor: theme.colorScheme.primaryContainer,
                  ),
                );
              }).toList(),
            ),
          ),

          // Products grid
          Expanded(
            child: products.isEmpty
                ? EmptyStateWidget(
                    icon: Icons.inventory_2_outlined,
                    title: 'No products found',
                    subtitle:
                        'There are no products in this category yet.',
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ProductCard(
                        product: product,
                        onTap: () => context.push('/product/${product.id}'),
                        onFavoriteToggle: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Added to favorites'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                        onAddToCart: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.name} added to cart'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        isFavorite: false,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
