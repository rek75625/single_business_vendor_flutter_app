import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:single_business_vendor_flutter_app/features/cart/presentation/cart_provider.dart';
import 'package:single_business_vendor_flutter_app/core/data/mock_data.dart';
import 'package:single_business_vendor_flutter_app/core/extensions/number_extensions.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _paymentMethod = 'cod';
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Processing your order...'),
              ],
            ),
          ),
        ),
      ),
    );

    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;
    Navigator.pop(context);

    final orderId = 'ORD-${DateTime.now().millisecondsSinceEpoch}';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 500),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: child,
                );
              },
              child: Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
                size: 80,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Order Placed Successfully!',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Order Number: $orderId',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                CartProvider.instance.clear();
                Navigator.pop(context);
                context.go('/home');
              },
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('Continue Shopping'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartProvider.instance;
    final address = MockData.user.addresses.first;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Delivery Address Section
          Text(
            'Delivery Address',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          address.label,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (address.isDefault)
                        Chip(
                          label: const Text('Default'),
                          labelStyle: Theme.of(context).textTheme.labelSmall,
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    address.fullAddress,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Change Address'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Payment Method Section
          Text(
            'Payment Method',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                RadioListTile<String>(
                  value: 'cod',
                  groupValue: _paymentMethod,
                  onChanged: (value) => setState(() => _paymentMethod = value!),
                  title: const Text('Cash on Delivery'),
                  secondary: const Icon(Icons.money),
                  toggleable: false,
                ),
                RadioListTile<String>(
                  value: 'card',
                  groupValue: _paymentMethod,
                  onChanged: null,
                  title: Row(
                    children: [
                      const Text('Credit/Debit Card'),
                      const SizedBox(width: 8),
                      Chip(
                        label: const Text('Coming Soon'),
                        labelStyle: Theme.of(context).textTheme.labelSmall,
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                  secondary: const Icon(Icons.credit_card),
                  toggleable: false,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Order Notes Section
          Text(
            'Order Notes (Optional)',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notesController,
            decoration: const InputDecoration(
              hintText: 'Any special instructions for delivery?',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 24),

          // Order Summary Section
          Text(
            'Order Summary',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ListenableBuilder(
                listenable: cart,
                builder: (context, _) {
                  return Column(
                    children: [
                      ...cart.items.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${item.product.name} x${item.quantity}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            Text(
                              item.totalPrice.toCurrency(),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      )),
                      const Divider(height: 24),
                      _SummaryRow(
                        label: 'Subtotal',
                        value: cart.subtotal.toCurrency(),
                      ),
                      const SizedBox(height: 8),
                      _SummaryRow(
                        label: 'Delivery Fee',
                        value: cart.deliveryFee == 0
                            ? 'FREE'
                            : cart.deliveryFee.toCurrency(),
                        valueColor: cart.deliveryFee == 0 ? Colors.green : null,
                      ),
                      const Divider(height: 24),
                      _SummaryRow(
                        label: 'Total',
                        value: cart.total.toCurrency(),
                        isBold: true,
                        isLarge: true,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 24),

          FilledButton(
            onPressed: _placeOrder,
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
            ),
            child: const Text('Place Order'),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isBold;
  final bool isLarge;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isBold = false,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = isLarge
        ? Theme.of(context).textTheme.titleMedium
        : Theme.of(context).textTheme.bodyMedium;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: textStyle?.copyWith(
            fontWeight: isBold ? FontWeight.bold : null,
          ),
        ),
        Text(
          value,
          style: textStyle?.copyWith(
            fontWeight: isBold ? FontWeight.bold : null,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
