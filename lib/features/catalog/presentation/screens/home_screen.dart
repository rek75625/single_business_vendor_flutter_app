import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:single_business_vendor_flutter_app/core/data/mock_data.dart';
import 'package:single_business_vendor_flutter_app/features/catalog/presentation/widgets/section_header.dart';
import 'package:single_business_vendor_flutter_app/features/catalog/presentation/widgets/product_card.dart';
import 'package:single_business_vendor_flutter_app/core/components/rating_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _bannerController = PageController();
  int _currentBannerPage = 0;
  Timer? _bannerTimer;

  final List<Map<String, dynamic>> _banners = [
    {
      'title': 'Summer Sale',
      'subtitle': 'Up to 50% Off',
      'gradient': [Color(0xFFFF6B6B), Color(0xFFFFE66D)],
    },
    {
      'title': 'New Arrivals',
      'subtitle': 'Check out the latest products',
      'gradient': [Color(0xFF4ECDC4), Color(0xFF44A08D)],
    },
    {
      'title': 'Free Delivery',
      'subtitle': 'On orders above 500 EGP',
      'gradient': [Color(0xFF667EEA), Color(0xFF764BA2)],
    },
  ];

  @override
  void initState() {
    super.initState();
    _startBannerAutoScroll();
  }

  void _startBannerAutoScroll() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_bannerController.hasClients) {
        final nextPage = (_currentBannerPage + 1) % _banners.length;
        _bannerController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // AppBar
          SliverAppBar(
            floating: true,
            title: const Text('ShopVendor'),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => context.push('/search'),
              ),
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () => context.push('/notifications'),
              ),
            ],
          ),

          // Promotional Banner Carousel
          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(
                  height: 180,
                  child: PageView.builder(
                    controller: _bannerController,
                    onPageChanged: (index) {
                      setState(() => _currentBannerPage = index);
                    },
                    itemCount: _banners.length,
                    itemBuilder: (context, index) {
                      final banner = _banners[index];
                      return Container(
                        margin: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: banner['gradient'],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                banner['title'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                banner['subtitle'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _banners.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentBannerPage == index
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outlineVariant,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),

          // Categories Row
          SliverToBoxAdapter(
            child: Column(
              children: [
                SectionHeader(
                  title: 'Categories',
                  onSeeAll: () => context.push('/categories'),
                ),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: MockData.categories.length,
                    itemBuilder: (context, index) {
                      final category = MockData.categories[index];
                      return GestureDetector(
                        onTap: () => context.push('/category/${category.id}'),
                        child: Container(
                          width: 80,
                          margin: const EdgeInsets.only(right: 12),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 32,
                                backgroundColor:
                                    theme.colorScheme.primaryContainer,
                                child: Icon(
                                  category.icon,
                                  color: theme.colorScheme.onPrimaryContainer,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                category.name,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),

          // Featured Products
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SectionHeader(title: 'Featured Products'),
                SizedBox(
                  height: 240,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: MockData.featuredProducts.length,
                    itemBuilder: (context, index) {
                      final product = MockData.featuredProducts[index];
                      return Container(
                        width: 160,
                        margin: const EdgeInsets.only(right: 12),
                        child: ProductCard(
                          product: product,
                          onTap: () => context.push('/product/${product.id}'),
                          isFavorite: false,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),

          // New Arrivals
          SliverToBoxAdapter(
            child: const SectionHeader(title: 'New Arrivals'),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = MockData.newProducts[index];
                  return ProductCard(
                    product: product,
                    onTap: () => context.push('/product/${product.id}'),
                    onFavoriteToggle: () {},
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
                childCount: MockData.newProducts.length > 4
                    ? 4
                    : MockData.newProducts.length,
              ),
            ),
          ),

          // Popular Products
          const SliverToBoxAdapter(
            child: SectionHeader(title: 'Popular Products'),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = MockData.products[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: () => context.push('/product/${product.id}'),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                product.imageUrl,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  width: 80,
                                  height: 80,
                                  color: theme.colorScheme.surfaceContainerHighest,
                                  child: Icon(
                                    Icons.image_not_supported,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.titleSmall,
                                  ),
                                  const SizedBox(height: 4),
                                  RatingBar(
                                    rating: product.rating,
                                    size: 14,
                                    showLabel: true,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${product.price.toStringAsFixed(0)} EGP',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: MockData.products.length > 5
                    ? 5
                    : MockData.products.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }
}
