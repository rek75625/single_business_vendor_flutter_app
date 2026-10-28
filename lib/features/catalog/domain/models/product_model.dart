import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final String imageUrl;
  final List<String> images;
  final String categoryId;
  final String categoryName;
  final double rating;
  final int reviewCount;
  final int stockQuantity;
  final bool isFeatured;
  final bool isNew;
  final Map<String, String> specifications;
  final DateTime createdAt;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.imageUrl,
    this.images = const [],
    required this.categoryId,
    required this.categoryName,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.stockQuantity = 0,
    this.isFeatured = false,
    this.isNew = false,
    this.specifications = const {},
    required this.createdAt,
  });

  bool get isInStock => stockQuantity > 0;
  bool get hasDiscount => originalPrice != null && originalPrice! > price;

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        originalPrice,
        imageUrl,
        images,
        categoryId,
        categoryName,
        rating,
        reviewCount,
        stockQuantity,
        isFeatured,
        isNew,
        specifications,
        createdAt,
      ];
}
