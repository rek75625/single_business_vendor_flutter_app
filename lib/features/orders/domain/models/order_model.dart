import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:single_business_vendor_flutter_app/features/auth/domain/models/user_model.dart';
import 'package:single_business_vendor_flutter_app/features/cart/domain/models/cart_item_model.dart';

enum OrderStatus {
  pending,
  confirmed,
  preparing,
  shipping,
  delivered,
  cancelled;

  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.shipping:
        return 'Shipping';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get color {
    switch (this) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.confirmed:
        return Colors.blue;
      case OrderStatus.preparing:
        return Colors.purple;
      case OrderStatus.shipping:
        return Colors.teal;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }
}

class Order extends Equatable {
  final String id;
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final OrderStatus status;
  final Address shippingAddress;
  final String paymentMethod;
  final DateTime placedAt;
  final DateTime? deliveredAt;

  const Order({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.status,
    required this.shippingAddress,
    required this.paymentMethod,
    required this.placedAt,
    this.deliveredAt,
  });

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  Order copyWith({
    String? id,
    List<CartItem>? items,
    double? subtotal,
    double? deliveryFee,
    double? total,
    OrderStatus? status,
    Address? shippingAddress,
    String? paymentMethod,
    DateTime? placedAt,
    DateTime? deliveredAt,
  }) {
    return Order(
      id: id ?? this.id,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      total: total ?? this.total,
      status: status ?? this.status,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      placedAt: placedAt ?? this.placedAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        items,
        subtotal,
        deliveryFee,
        total,
        status,
        shippingAddress,
        paymentMethod,
        placedAt,
        deliveredAt,
      ];
}
