import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  final String id;
  final String name;
  final String image;
  final String category;
  final String cal;
  final int time;
  final double rating;
  final int reviews;
  final List<String> ingredientsName;
  final List<String> ingredientsAmount;
  final List<String> ingredientsImage;

  Recipe({
    required this.id,
    required this.name,
    required this.image,
    required this.category,
    required this.cal,
    required this.time,
    required this.rating,
    required this.reviews,
    required this.ingredientsName,
    required this.ingredientsAmount,
    required this.ingredientsImage,
  });

  factory Recipe.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    // Safe parsing for ingredients lists
    List<String> parseList(dynamic field) {
      if (field is List) {
        return field.map((e) => e.toString()).toList();
      }
      return [];
    }

    return Recipe(
      id: doc.id,
      name: data['name'] ?? '',
      // Fallback placeholder image if no URL is provided in Firestore
      image:
          data['image'] ??
          'https://images.unsplash.com/photo-1495521821757-a1efb6729352?w=800',
      category: data['category'] ?? 'All',
      cal: data['cal']?.toString() ?? '0',
      time: (data['time'] is num) ? (data['time'] as num).toInt() : 0,
      rating: double.tryParse(data['rate']?.toString() ?? '0.0') ?? 0.0,
      reviews: (data['reviews'] is num) ? (data['reviews'] as num).toInt() : 0,
      ingredientsName: parseList(data['ingredientsName']),
      ingredientsAmount: parseList(data['ingredientsAmount']),
      ingredientsImage: parseList(data['ingredientsImage']),
    );
  }
}
