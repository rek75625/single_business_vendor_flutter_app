import 'package:flutter/material.dart';
import 'package:single_business_vendor_flutter_app/core/data/mock_data.dart';
import 'package:single_business_vendor_flutter_app/features/orders/domain/models/order_model.dart';
import 'package:single_business_vendor_flutter_app/core/extensions/number_extensions.dart';
import 'package:single_business_vendor_flutter_app/core/components/app_cached_image.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late Order order;

  @override
  void initState() {
    super.initState();
    order = MockData.orders.firstWhere(
      (o) => o.id == widget.orderId,
      orElse: () => MockData.orders.first,
    );
  }

  void _cancelOrder() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Order'),
        content: const Text('Are you sure you want to cancel this order?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                // In real app, this would update backend
                order = Order(
                  id: order.id,
                  items: order.items,
                  subtotal: order.subtotal,
                  deliveryFee: order.deliveryFee,
                  total: order.total,
                  status: OrderStatus.cancelled,
                  shippingAddress: order.shippingAddress,
                  paymentMethod: order.paymentMethod,
                  placedAt: order.placedAt,
                  deliveredAt: order.deliveredAt,
                );
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Order cancelled successfully')),
              );
            },
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${order.id}'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Order Status Timeline
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Status',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _OrderStatusTimeline(status: order.status),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Order Items
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Items (${order.items.length})',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...order.items.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        AppCachedImage(
                          imageUrl: item.product.imageUrl,
                          width: 60,
                          height: 60,
                          borderRadius: 8,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.product.name,
                                style: Theme.of(context).textTheme.titleSmall,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Qty: ${item.quantity}',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          item.totalPrice.toCurrency(),
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Price Breakdown
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Price Details',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _PriceRow(label: 'Subtotal', value: order.subtotal.toCurrency()),
                  const SizedBox(height: 8),
                  _PriceRow(
                    label: 'Delivery Fee',
                    value: order.deliveryFee == 0
                        ? 'FREE'
                        : order.deliveryFee.toCurrency(),
                    valueColor: order.deliveryFee == 0 ? Colors.green : null,
                  ),
                  const Divider(height: 24),
                  _PriceRow(
                    label: 'Total',
                    value: order.total.toCurrency(),
                    isBold: true,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Delivery Address
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Delivery Address',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.shippingAddress.label,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              order.shippingAddress.fullAddress,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Payment Method
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payment Method',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.payments,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        order.paymentMethod,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Cancel Order Button
          if (order.status == OrderStatus.pending ||
              order.status == OrderStatus.confirmed)
            OutlinedButton(
              onPressed: _cancelOrder,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Cancel Order'),
            ),
        ],
      ),
    );
  }
}

class _OrderStatusTimeline extends StatelessWidget {
  final OrderStatus status;

  const _OrderStatusTimeline({required this.status});

  @override
  Widget build(BuildContext context) {
    final steps = [
      _StatusStep(OrderStatus.pending, 'Order Placed'),
      _StatusStep(OrderStatus.confirmed, 'Confirmed'),
      _StatusStep(OrderStatus.preparing, 'Preparing'),
      _StatusStep(OrderStatus.shipping, 'Shipping'),
      _StatusStep(OrderStatus.delivered, 'Delivered'),
    ];

    final currentIndex = steps.indexWhere((step) => step.status == status);

    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final isCompleted = index <= currentIndex;
        final isLast = index == steps.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isCompleted ? Icons.check : Icons.circle,
                    size: 16,
                    color: isCompleted
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 40,
                    color: isCompleted
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                step.label,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
                  color: isCompleted
                      ? Theme.of(context).colorScheme.onSurface
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _StatusStep {
  final OrderStatus status;
  final String label;

  _StatusStep(this.status, this.label);
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isBold;

  const _PriceRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: isBold ? FontWeight.bold : null,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: isBold ? FontWeight.bold : null,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
