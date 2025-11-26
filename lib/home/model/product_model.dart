import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final double oldPrice;
  final String discount;
  final String imagePath;
  final double rating;
  final int ratingCount;
  final bool isTrending;
  final String category;
  final String brand;
  final int stock;
  final DateTime createdAt;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.oldPrice,
    required this.discount,
    required this.imagePath,
    required this.rating,
    required this.ratingCount,
    required this.isTrending,
    required this.category,
    required this.brand,
    required this.stock,
    required this.createdAt,
    required this.isFavorite,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    try {
      print('Parsing product map: $map');

      final product = Product(
        id: map['id']?.toString() ?? '',
        title: map['title']?.toString() ?? 'No Title',
        description: map['description']?.toString() ?? '',
        price: _parseDouble(map['price']),
        oldPrice: _parseDouble(map['oldPrice']),
        discount: map['discount']?.toString() ?? '',
        imagePath:
            map['imagePath']?.toString() ??
            map['imageUrl']?.toString() ??
            map['image']?.toString() ??
            'https://via.placeholder.com/200',
        rating: _parseDouble(map['rating']),
        ratingCount: _parseInt(map['ratingCount']),
        isTrending: map['isTrending'] ?? false,
        category: map['category']?.toString()?.toLowerCase() ?? 'unknown',
        brand: map['brand']?.toString() ?? '',
        stock: _parseInt(map['stock']),
        createdAt: _parseDateTime(map['createdAt']),
        isFavorite: map['isFavorite'] ?? false,
      );

      print('Successfully parsed: ${product.title}');
      return product;
    } catch (e) {
      print('Error parsing product: $e');
      print('Problematic map data: $map');
      rethrow;
    }
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      final parsed = double.tryParse(value);
      return parsed ?? 0.0;
    }
    return 0.0;
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      final parsed = int.tryParse(value);
      return parsed ?? 0;
    }
    return 0;
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is DateTime) return value;
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        print('Error parsing date: $value');
        return DateTime.now();
      }
    }
    if (value is Timestamp) {
      return value.toDate();
    }
    return DateTime.now();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'oldPrice': oldPrice,
      'discount': discount,
      'imagePath': imagePath,
      'rating': rating,
      'ratingCount': ratingCount,
      'isTrending': isTrending,
      'category': category,
      'brand': brand,
      'stock': stock,
      'createdAt': createdAt.toIso8601String(),
      'isFavorite': isFavorite,
    };
  }

  @override
  String toString() {
    return 'Product{id: $id, title: $title, category: $category, price: $price}';
  }
}
