import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:single_business_vendor_flutter_app/features/cart/presentation/cart_provider.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final int cartBadgeCount;

  const ScaffoldWithNavBar({
    super.key,
    required this.navigationShell,
    this.cartBadgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: ListenableBuilder(
        listenable: CartProvider.instance,
        builder: (context, _) {
          final cartCount = CartProvider.instance.itemCount;

          return NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: (index) {
              navigationShell.goBranch(
                index,
                initialLocation: index == navigationShell.currentIndex,
              );
            },
            destinations: [
              const NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Home',
              ),
              const NavigationDestination(
                icon: Icon(Icons.category_outlined),
                selectedIcon: Icon(Icons.category),
                label: 'Categories',
              ),
              const NavigationDestination(
                icon: Icon(Icons.favorite_outline),
                selectedIcon: Icon(Icons.favorite),
                label: 'Favorites',
              ),
              NavigationDestination(
                icon: Badge(
                  label: Text('$cartCount'),
                  isLabelVisible: cartCount > 0,
                  child: const Icon(Icons.shopping_cart_outlined),
                ),
                selectedIcon: Badge(
                  label: Text('$cartCount'),
                  isLabelVisible: cartCount > 0,
                  child: const Icon(Icons.shopping_cart),
                ),
                label: 'Cart',
              ),
              const NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: 'Account',
              ),
            ],
          );
        },
      ),
    );
  }
}
