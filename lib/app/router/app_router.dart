import 'package:go_router/go_router.dart';
import 'package:single_business_vendor_flutter_app/app/router/navigation_shell.dart';
import 'package:single_business_vendor_flutter_app/app/router/placeholder_screen.dart';
import 'package:single_business_vendor_flutter_app/features/catalog/presentation/screens/home_screen.dart';
import 'package:single_business_vendor_flutter_app/features/catalog/presentation/screens/categories_screen.dart';
import 'package:single_business_vendor_flutter_app/features/catalog/presentation/screens/favorites_screen.dart';
import 'package:single_business_vendor_flutter_app/features/cart/presentation/screens/cart_screen.dart';
import 'package:single_business_vendor_flutter_app/features/account/presentation/screens/account_screen.dart';
import 'package:single_business_vendor_flutter_app/features/cart/presentation/cart_provider.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) =>
            const PlaceholderScreen(title: 'Splash Screen'),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) =>
            const PlaceholderScreen(title: 'Onboarding'),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) =>
            const PlaceholderScreen(title: 'Login'),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) =>
            const PlaceholderScreen(title: 'Register'),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(
            navigationShell: navigationShell,
            cartBadgeCount: CartProvider.instance.itemCount,
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/categories',
                builder: (context, state) => const CategoriesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/favorites',
                builder: (context, state) => const FavoritesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/cart',
                builder: (context, state) => const CartScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/account',
                builder: (context, state) => const AccountScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/product/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return PlaceholderScreen(title: 'Product Detail $id');
        },
      ),
      GoRoute(
        path: '/category/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return PlaceholderScreen(title: 'Category Products $id');
        },
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) =>
            const PlaceholderScreen(title: 'Search'),
      ),
      GoRoute(
        path: '/checkout',
        builder: (context, state) =>
            const PlaceholderScreen(title: 'Checkout'),
      ),
      GoRoute(
        path: '/orders',
        builder: (context, state) =>
            const PlaceholderScreen(title: 'Orders'),
      ),
      GoRoute(
        path: '/order/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return PlaceholderScreen(title: 'Order Detail $id');
        },
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) =>
            const PlaceholderScreen(title: 'Notifications'),
      ),
      GoRoute(
        path: '/support',
        builder: (context, state) =>
            const PlaceholderScreen(title: 'Support'),
      ),
      GoRoute(
        path: '/support/ticket/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return PlaceholderScreen(title: 'Ticket Detail $id');
        },
      ),
      GoRoute(
        path: '/edit-profile',
        builder: (context, state) =>
            const PlaceholderScreen(title: 'Edit Profile'),
      ),
      GoRoute(
        path: '/addresses',
        builder: (context, state) =>
            const PlaceholderScreen(title: 'Addresses'),
      ),
    ],
  );
}
