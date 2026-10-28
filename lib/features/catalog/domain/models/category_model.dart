import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String imageUrl;
  final IconData icon;
  final int productCount;

  const Category({
    required this.id,
    required this.name,
    this.description,
    required this.imageUrl,
    required this.icon,
    this.productCount = 0,
  });

  @override
  List<Object?> get props => [id, name, description, imageUrl, icon, productCount];
}
