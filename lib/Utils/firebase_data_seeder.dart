import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirebaseDataSeeder {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> seedInitialData() async {
    // 5 Brand-New Unique Recipes
    final List<Map<String, dynamic>> newRecipes = [
      {
        "name": "Creamy Carbonara",
        "category": "Dinner",
        "cal": "290",
        "time": 20,
        "rate": "4.9",
        "reviews": 42,
        "image": "https://images.unsplash.com/photo-1612874742237-6526221588e3?w=600",
        "ingredientsName": ["Spaghetti", "Parmesan", "Bacon"],
        "ingredientsAmount": ["250", "60", "100"],
        "ingredientsImage": [
          "https://cdn-icons-png.flaticon.com/512/2718/2718224.png",
          "https://cdn-icons-png.flaticon.com/512/3050/3050158.png",
          "https://cdn-icons-png.flaticon.com/512/3143/3143643.png",
        ],
      },
      {
        "name": "Avocado Toast",
        "category": "Breakfast",
        "cal": "130",
        "time": 10,
        "rate": "4.6",
        "reviews": 31,
        "image": "https://images.unsplash.com/photo-1588137378633-dea1336ce1e2?w=600",
        "ingredientsName": ["Sourdough Bread", "Avocado", "Poached Egg"],
        "ingredientsAmount": ["80", "120", "60"],
        "ingredientsImage": [
          "https://cdn-icons-png.flaticon.com/512/883/883514.png",
          "https://cdn-icons-png.flaticon.com/512/2329/2329865.png",
          "https://cdn-icons-png.flaticon.com/512/837/837560.png",
        ],
      },
      {
        "name": "Teriyaki Salmon Bowl",
        "category": "Lunch",
        "cal": "240",
        "time": 25,
        "rate": "4.9",
        "reviews": 75,
        "image": "https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=600",
        "ingredientsName": ["Salmon Fillet", "Jasmine Rice", "Broccoli"],
        "ingredientsAmount": ["200", "150", "80"],
        "ingredientsImage": [
          "https://cdn-icons-png.flaticon.com/512/3143/3143643.png",
          "https://cdn-icons-png.flaticon.com/512/992/992747.png",
          "https://cdn-icons-png.flaticon.com/512/2329/2329865.png",
        ],
      },
      {
        "name": "Berry Acai Bowl",
        "category": "Breakfast",
        "cal": "160",
        "time": 8,
        "rate": "4.8",
        "reviews": 39,
        "image": "https://images.unsplash.com/photo-1590080875515-8a3a8dc5735e?w=600",
        "ingredientsName": ["Acai Puree", "Blueberries", "Granola"],
        "ingredientsAmount": ["150", "60", "40"],
        "ingredientsImage": [
          "https://cdn-icons-png.flaticon.com/512/590/590685.png",
          "https://cdn-icons-png.flaticon.com/512/590/590685.png",
          "https://cdn-icons-png.flaticon.com/512/992/992747.png",
        ],
      },
      {
        "name": "Pulled Beef Tacos",
        "category": "Dinner",
        "cal": "320",
        "time": 30,
        "rate": "4.7",
        "reviews": 58,
        "image":
            "https://images.unsplash.com/photo-1551504734-5ee1c4a1479b?w=600",
        "ingredientsName": ["Taco Shells", "Shredded Beef", "Coriander"],
        "ingredientsAmount": ["90", "220", "15"],
        "ingredientsImage": [
          "https://cdn-icons-png.flaticon.com/512/1404/1404945.png",
          "https://cdn-icons-png.flaticon.com/512/3143/3143643.png",
          "https://cdn-icons-png.flaticon.com/512/2329/2329865.png",
        ],
      },
    ];

    // Seed only the new recipes without touching old ones
    for (var recipe in newRecipes) {
      final existing = await _firestore
          .collection("Complete-Flutter-App")
          .where("name", isEqualTo: recipe["name"])
          .get();

      if (existing.docs.isEmpty) {
        await _firestore.collection("Complete-Flutter-App").add(recipe);
        debugPrint("Added new recipe: ${recipe['name']}");
      }
    }

    debugPrint("5 new recipes successfully added to Firestore!");
  }
}
