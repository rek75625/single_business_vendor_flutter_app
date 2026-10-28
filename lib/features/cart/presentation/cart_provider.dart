import 'package:flutter/foundation.dart';
import 'package:single_business_vendor_flutter_app/features/cart/domain/models/cart_item_model.dart';
import 'package:single_business_vendor_flutter_app/features/catalog/domain/models/product_model.dart';

class CartProvider extends ChangeNotifier {
  static final CartProvider instance = CartProvider._();
  CartProvider._();

  Cart _cart = const Cart();

  Cart get cart => _cart;
  List<CartItem> get items => _cart.items;
  int get itemCount => _cart.itemCount;
  double get subtotal => _cart.subtotal;
  double get deliveryFee => _cart.deliveryFee;
  double get total => _cart.total;
  bool get isEmpty => _cart.isEmpty;

  void addToCart(Product product, {int quantity = 1}) {
    final existingIndex = _cart.items.indexWhere(
      (item) => item.product.id == product.id,
    );

    List<CartItem> updatedItems;
    if (existingIndex != -1) {
      // Update existing item
      updatedItems = List.from(_cart.items);
      updatedItems[existingIndex] = updatedItems[existingIndex].copyWith(
        quantity: updatedItems[existingIndex].quantity + quantity,
      );
    } else {
      // Add new item
      updatedItems = [
        ..._cart.items,
        CartItem(product: product, quantity: quantity),
      ];
    }

    _cart = Cart(items: updatedItems);
    notifyListeners();
  }

  void removeFromCart(String productId) {
    final updatedItems = _cart.items.where(
      (item) => item.product.id != productId,
    ).toList();
    _cart = Cart(items: updatedItems);
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(productId);
      return;
    }

    final updatedItems = _cart.items.map((item) {
      if (item.product.id == productId) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();

    _cart = Cart(items: updatedItems);
    notifyListeners();
  }

  void incrementQuantity(String productId) {
    final item = _cart.items.firstWhere(
      (item) => item.product.id == productId,
    );
    updateQuantity(productId, item.quantity + 1);
  }

  void decrementQuantity(String productId) {
    final item = _cart.items.firstWhere(
      (item) => item.product.id == productId,
    );
    updateQuantity(productId, item.quantity - 1);
  }

  void clearCart() {
    _cart = const Cart();
    notifyListeners();
  }

  void clear() {
    clearCart();
  }

  bool containsProduct(String productId) {
    return _cart.items.any((item) => item.product.id == productId);
  }

  int getProductQuantity(String productId) {
    try {
      final item = _cart.items.firstWhere(
        (item) => item.product.id == productId,
      );
      return item.quantity;
    } catch (e) {
      return 0;
    }
  }
}
