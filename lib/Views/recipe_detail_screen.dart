import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../Provider/favorite_provider.dart';
import '../Provider/quantity.dart';
import '../Utils/constants.dart';
import '../Widget/my_icon_button.dart';
import '../Widget/quantity_increment_decrement.dart';
import 'cooking_steps_screen.dart';
import 'notifications_screen.dart';

class RecipeDetailScreen extends StatefulWidget {
  final DocumentSnapshot<Object?> documentSnapshot;
  const RecipeDetailScreen({super.key, required this.documentSnapshot});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Schedule state initialization right after the initial frame finishes building
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final data =
          widget.documentSnapshot.data() as Map<String, dynamic>? ?? {};
      final rawAmounts = data['ingredientsAmount'] as List<dynamic>? ?? [];

      List<double> baseAmounts = rawAmounts
          .map((amount) => double.tryParse(amount.toString()) ?? 0.0)
          .toList();

      Provider.of<QuantityProvider>(
        context,
        listen: false,
      ).setBaseIngredientAmounts(baseAmounts);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = FavoriteProvider.of(context);
    final quantityProvider = Provider.of<QuantityProvider>(context);
    final data = widget.documentSnapshot.data() as Map<String, dynamic>? ?? {};

    final String image = data['image']?.toString() ?? '';
    final String name = data['name']?.toString() ?? 'Recipe Detail';
    final String cal = data['cal']?.toString() ?? '0';
    final String time = data['time']?.toString() ?? '0';
    final String rate = data['rate']?.toString() ?? '0.0';
    final String reviews = data['reviews']?.toString() ?? '0';
    final List<dynamic> ingredientsImage =
        data['ingredientsImage'] as List<dynamic>? ?? [];
    final List<dynamic> ingredientsName =
        data['ingredientsName'] as List<dynamic>? ?? [];

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: startCookingAndFavoriteButton(provider),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Hero(
                  tag: image,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 2.1,
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.grey.shade200),
                    child: image.isNotEmpty
                        ? Image.network(
                            image,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Center(
                                  child: Icon(
                                    Iconsax.gallery_slash,
                                    color: Colors.grey,
                                    size: 48,
                                  ),
                                ),
                          )
                        : const Center(
                            child: Icon(
                              Iconsax.image,
                              color: Colors.grey,
                              size: 48,
                            ),
                          ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 10,
                  right: 10,
                  child: Row(
                    children: [
                      MyIconButton(
                        icon: Icons.arrow_back_ios_new,
                        pressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const Spacer(),
                      MyIconButton(
                        icon: Iconsax.notification,
                        pressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const NotificationsScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: MediaQuery.of(context).size.width,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
            Center(
              child: Container(
                width: 40,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Iconsax.flash_1, size: 20, color: Colors.grey),
                      Text(
                        "$cal Cal",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const Text(
                        " · ",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Colors.grey,
                        ),
                      ),
                      const Icon(Iconsax.clock, size: 20, color: Colors.grey),
                      const SizedBox(width: 5),
                      Text(
                        "$time Min",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Iconsax.star1, color: Colors.amberAccent),
                      const SizedBox(width: 5),
                      Text(
                        rate,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Text("/5"),
                      const SizedBox(width: 5),
                      Text(
                        "($reviews Reviews)",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Ingredients",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "How many servings?",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                      const Spacer(),
                      QuantityIncrementDecrement(
                        currentNumber: quantityProvider.currentNumber,
                        onAdd: () => quantityProvider.increaseQuantity(),
                        onRemove: () => quantityProvider.decreaseQuantity(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // List of ingredients
                  Row(
                    children: [
                      // Ingredient images
                      Column(
                        children: ingredientsImage
                            .map(
                              (imageUrl) => Container(
                                height: 60,
                                width: 60,
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.grey.shade100,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    imageUrl.toString(),
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Center(
                                              child: Icon(
                                                Iconsax.image,
                                                color: Colors.grey,
                                                size: 24,
                                              ),
                                            ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(width: 20),
                      // Ingredient names
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: ingredientsName
                            .map(
                              (ingredient) => SizedBox(
                                height: 60,
                                child: Center(
                                  child: Text(
                                    ingredient.toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const Spacer(),
                      // Ingredient amounts (updated by QuantityProvider)
                      Column(
                        children: quantityProvider.updateIngredientAmounts
                            .map(
                              (amount) => SizedBox(
                                height: 60,
                                child: Center(
                                  child: Text(
                                    "${amount}gm",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget startCookingAndFavoriteButton(FavoriteProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kprimaryColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CookingStepsScreen(
                      documentSnapshot: widget.documentSnapshot,
                    ),
                  ),
                );
              },
              child: const Text(
                "Start Cooking",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300, width: 2),
            ),
            child: IconButton(
              onPressed: () {
                provider.toggleFavorite(widget.documentSnapshot);
              },
              icon: Icon(
                provider.isExist(widget.documentSnapshot)
                    ? Iconsax.heart5
                    : Iconsax.heart,
                color: provider.isExist(widget.documentSnapshot)
                    ? Colors.red
                    : Colors.black,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
