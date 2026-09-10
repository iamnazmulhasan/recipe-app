import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../Utils/constants.dart';
import '../Widget/food_items_display.dart';

class RecipeSearchScreen extends StatefulWidget {
  const RecipeSearchScreen({super.key});

  @override
  State<RecipeSearchScreen> createState() => _RecipeSearchScreenState();
}

class _RecipeSearchScreenState extends State<RecipeSearchScreen> {
  String searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackgroundColor,
      appBar: AppBar(
        backgroundColor: kbackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          onChanged: (value) {
            setState(() {
              searchQuery = value.trim().toLowerCase();
            });
          },
          decoration: InputDecoration(
            hintText: "Search recipes...",
            border: InputBorder.none,
            suffixIcon: searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        searchQuery = "";
                      });
                    },
                  )
                : const Icon(Iconsax.search_normal, color: Colors.grey),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Complete-Flutter-App")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No recipes available.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          // Filter documents locally by search query
          final filteredDocs = snapshot.data!.docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>? ?? {};
            final name = (data['name'] ?? '').toString().toLowerCase();
            return name.contains(searchQuery);
          }).toList();

          if (filteredDocs.isEmpty) {
            return const Center(
              child: Text(
                "No matching recipes found.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(15),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              // Lower aspect ratio gives each grid cell enough height
              childAspectRatio: 0.62,
              crossAxisSpacing: 10,
              mainAxisSpacing: 15,
            ),
            itemCount: filteredDocs.length,
            itemBuilder: (context, index) {
              return FoodItemsDisplay(documentSnapshot: filteredDocs[index]);
            },
          );
        },
      ),
    );
  }
}
