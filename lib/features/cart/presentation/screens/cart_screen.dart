import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:single_business_vendor_flutter_app/features/cart/presentation/cart_provider.dart';
import 'package:single_business_vendor_flutter_app/core/components/empty_state_widget.dart';
import 'package:single_business_vendor_flutter_app/core/components/app_cached_image.dart';
import 'package:single_business_vendor_flutter_app/core/extensions/number_extensions.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        actions: [
          ListenableBuilder(
            listenable: CartProvider.instance,
            builder: (context, _) {
              final cart = CartProvider.instance;
              if (cart.isEmpty) return const SizedBox.shrink();
              return TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Clear Cart'),
                      content: const Text('Are you sure you want to remove all items from your cart?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        FilledButton(
                          onPressed: () {
                            cart.clearCart();
                            Navigator.pop(context);
                          },
                          child: const Text('Clear'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('Clear All'),
              );
            },
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: CartProvider.instance,
        builder: (context, _) {
          final cart = CartProvider.instance;

          if (cart.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.shopping_cart_outlined,
              title: 'Your cart is empty',
              subtitle: 'Add products to your cart to see them here',
              actionLabel: 'Start Shopping',
              onAction: () => context.go('/home'),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: cart.items.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    final product = item.product;

                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Image
                            InkWell(
                              onTap: () => context.push('/product/${product.id}'),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: AppCachedImage(
                                  imageUrl: product.imageUrl,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Product Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () => context.push('/product/${product.id}'),
                                    child: Text(
                                      product.name,
                                      style: Theme.of(context).textTheme.titleSmall,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    product.price.toCurrency(),
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 8),

                                  // Quantity Controls
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Theme.of(context).colorScheme.outline,
                                          ),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.remove, size: 18),
                                              onPressed: () => cart.decrementQuantity(product.id),
                                              visualDensity: VisualDensity.compact,
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 12),
                                              child: Text(
                                                '${item.quantity}',
                                                style: Theme.of(context).textTheme.titleMedium,
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.add, size: 18),
                                              onPressed: () => cart.incrementQuantity(product.id),
                                              visualDensity: VisualDensity.compact,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete_outline,
                                          color: Theme.of(context).colorScheme.error,
                                        ),
                                        onPressed: () => cart.removeFromCart(product.id),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Cart Summary
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: SafeArea(
                  top: false,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Subtotal',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            cart.subtotal.toCurrency(),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Delivery Fee',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            cart.deliveryFee == 0 ? 'FREE' : cart.deliveryFee.toCurrency(),
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: cart.deliveryFee == 0
                                  ? Theme.of(context).colorScheme.primary
                                  : null,
                              fontWeight: cart.deliveryFee == 0
                                  ? FontWeight.bold
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            cart.total.toCurrency(),
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () => context.push('/checkout'),
                          child: const Text('Proceed to Checkout'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
