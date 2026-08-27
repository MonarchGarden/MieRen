import 'package:flutter/material.dart';

enum ProductCategory {
  all,
  sayur,
  buah,
  standard,
}

extension ProductCategoryExtension on ProductCategory {
  String get label {
    switch (this) {
      case ProductCategory.all:
        return 'Semua Varian';
      case ProductCategory.sayur:
        return 'Mie Sayur';
      case ProductCategory.buah:
        return 'Mie Buah';
      case ProductCategory.standard:
        return 'Mie Standar';
    }
  }
}

class ProductVariant {
  final String id;
  final String name;
  final ProductCategory category;
  final String description;
  final String shortDescription;
  final String imageAsset;
  final String colorHex;
  final Color primaryColor;
  final List<String> ingredients;
  final List<String> highlights;
  final String weightInfo;
  final String badgeText;
  final bool isPopular;

  const ProductVariant({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.shortDescription,
    required this.imageAsset,
    required this.colorHex,
    required this.primaryColor,
    required this.ingredients,
    required this.highlights,
    this.weightInfo = '38 gram / pc (Bisa Custom)',
    required this.badgeText,
    this.isPopular = false,
  });
}
