import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteProvider extends ChangeNotifier {
  List<String> _favoriteIds = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<String> get favorites => _favoriteIds;

  FavoriteProvider() {
    loadFavorites();
  }

  // Toggle favorite state (Add or Remove)
  void toggleFavorite(DocumentSnapshot product) async {
    String productId = product.id;
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
      await _removeFavorite(productId);
    } else {
      _favoriteIds.add(productId);
      await _addFavorite(productId);
    }
    notifyListeners();
  }

  // Check if a product/recipe is already favorited
  bool isExist(DocumentSnapshot product) {
    return _favoriteIds.contains(product.id);
  }

  // Add favorite document to Firestore
  Future<void> _addFavorite(String productId) async {
    try {
      await _firestore.collection("userFavorite").doc(productId).set({
        'isFavorite': true,
      });
    } catch (e) {
      debugPrint("Error adding favorite: $e");
    }
  }

  // Remove favorite document from Firestore
  Future<void> _removeFavorite(String productId) async {
    try {
      await _firestore.collection("userFavorite").doc(productId).delete();
    } catch (e) {
      debugPrint("Error removing favorite: $e");
    }
  }

  // Load initial favorites from Firestore
  Future<void> loadFavorites() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection("userFavorite")
          .get();
      _favoriteIds = snapshot.docs.map((doc) => doc.id).toList();

      // Delay notify until post-frame to prevent setState during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    } catch (e) {
      debugPrint("Error loading favorites: $e");
    }
  }

  // Static helper to quickly access provider anywhere without boilerplate
  static FavoriteProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of<FavoriteProvider>(context, listen: listen);
  }
}
