import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:single_business_vendor_flutter_app/core/data/mock_data.dart';
import 'package:single_business_vendor_flutter_app/features/orders/domain/models/order_model.dart';
import 'package:single_business_vendor_flutter_app/core/extensions/number_extensions.dart';
import 'package:single_business_vendor_flutter_app/core/components/empty_state_widget.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Orders'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Active'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _OrdersList(
              orders: MockData.orders.where((order) =>
                order.status == OrderStatus.pending ||
                order.status == OrderStatus.confirmed ||
                order.status == OrderStatus.preparing ||
                order.status == OrderStatus.shipping
              ).toList(),
              emptyMessage: 'No active orders',
            ),
            _OrdersList(
              orders: MockData.orders.where((order) =>
                order.status == OrderStatus.delivered ||
                order.status == OrderStatus.cancelled
              ).toList(),
              emptyMessage: 'No completed orders',
            ),
          ],
        ),
      ),
    );
  }
}

class _OrdersList extends StatelessWidget {
  final List<Order> orders;
  final String emptyMessage;

  const _OrdersList({
    required this.orders,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.receipt_long_outlined,
        title: emptyMessage,
        subtitle: 'Your orders will appear here',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _OrderCard(order: order);
      },
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy • hh:mm a');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => context.push('/order/${order.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order #${order.id}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Chip(
                    label: Text(order.status.displayName),
                    labelStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                    ),
                    backgroundColor: order.status.color,
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    dateFormat.format(order.placedAt),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${order.items.length} items',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    order.total.toCurrency(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => context.push('/order/${order.id}'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 40),
                ),
                child: const Text('View Details'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
