import 'package:flutter/foundation.dart';
import 'package:single_business_vendor_flutter_app/core/data/mock_data.dart';
import 'package:single_business_vendor_flutter_app/features/catalog/domain/models/product_model.dart';

class FavoritesProvider extends ChangeNotifier {
  static final FavoritesProvider instance = FavoritesProvider._();
  FavoritesProvider._();

  final Set<String> _favoriteIds = {};

  Set<String> get favoriteIds => _favoriteIds;

  List<Product> get favoriteProducts {
    return MockData.products
        .where((product) => _favoriteIds.contains(product.id))
        .toList();
  }

  bool isFavorite(String productId) {
    return _favoriteIds.contains(productId);
  }

  void toggle(String productId) {
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
    } else {
      _favoriteIds.add(productId);
    }
    notifyListeners();
  }

  void add(String productId) {
    if (!_favoriteIds.contains(productId)) {
      _favoriteIds.add(productId);
      notifyListeners();
    }
  }

  void remove(String productId) {
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
      notifyListeners();
    }
  }

  void clear() {
    _favoriteIds.clear();
    notifyListeners();
  }
}
