import 'package:equatable/equatable.dart';
import 'package:single_business_vendor_flutter_app/core/constants/app_constants.dart';
import 'package:single_business_vendor_flutter_app/features/catalog/domain/models/product_model.dart';

class CartItem extends Equatable {
  final Product product;
  final int quantity;

  const CartItem({
    required this.product,
    required this.quantity,
  });

  double get totalPrice => product.price * quantity;

  CartItem copyWith({
    Product? product,
    int? quantity,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [product, quantity];
}

class Cart extends Equatable {
  final List<CartItem> items;

  const Cart({this.items = const []});

  double get subtotal {
    return items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  double get deliveryFee {
    if (isEmpty) return 0.0;
    return subtotal >= AppConstants.freeDeliveryThreshold
        ? 0.0
        : AppConstants.deliveryFee;
  }

  double get total => subtotal + deliveryFee;

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  bool get isEmpty => items.isEmpty;

  Cart copyWith({List<CartItem>? items}) {
    return Cart(items: items ?? this.items);
  }

  @override
  List<Object?> get props => [items];
}
