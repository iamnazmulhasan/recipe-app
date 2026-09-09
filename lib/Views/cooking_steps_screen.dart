import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../Utils/constants.dart';

class CookingStepsScreen extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;

  const CookingStepsScreen({super.key, required this.documentSnapshot});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data =
        documentSnapshot.data() as Map<String, dynamic>? ?? {};

    final String recipeName = data['name'] ?? 'Recipe Instructions';
    final List<dynamic> ingredients = data['ingredientsName'] ?? [];
    final List<dynamic> amounts = data['ingredientsAmount'] ?? [];

    return Scaffold(
      backgroundColor: kbackgroundColor,
      appBar: AppBar(
        backgroundColor: kbackgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          recipeName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Iconsax.note_2, color: kprimaryColor),
                    SizedBox(width: 8),
                    Text(
                      "Ingredients Checklist",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: ingredients.length,
                  itemBuilder: (context, index) {
                    final ingredient = ingredients[index];
                    final amount = index < amounts.length ? amounts[index] : '';
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle_outline,
                            color: kBannerColor,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "$ingredient",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            "${amount}g",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Iconsax.timer_1, color: kprimaryColor),
                    SizedBox(width: 8),
                    Text(
                      "Preparation Steps",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                _buildStep(
                  step: 1,
                  title: "Prepare the Ingredients",
                  description: "Wash, cut, and measure all ingredients according to the quantities listed above.",
                ),
                _buildStep(
                  step: 2,
                  title: "Cook on Medium Heat",
                  description: "Preheat your pan or pot with a small amount of oil or butter. Cook until evenly browned.",
                ),
                _buildStep(
                  step: 3,
                  title: "Simmer & Season",
                  description: "Add your spices and sauce, reduce to low heat, and let it simmer for the recommended time.",
                ),
                _buildStep(
                  step: 4,
                  title: "Serve Fresh",
                  description: "Garnish with fresh herbs and serve hot. Enjoy your homemade dish!",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep({
    required int step,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: kprimaryColor,
            child: Text(
              "$step",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(color: Colors.grey, height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
