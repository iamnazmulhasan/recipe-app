import 'package:flutter/material.dart';

class QuantityProvider extends ChangeNotifier {
  int _currentNumber = 1;
  List<double> _baseIngredientAmounts = [];

  int get currentNumber => _currentNumber;

  // Set initial ingredient amounts
  void setBaseIngredientAmounts(List<double> amounts) {
    _baseIngredientAmounts = amounts;
    _currentNumber = 1; // Reset servings count when opening new recipe

    // Defer notification until the current build phase is completed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  // Update ingredient amounts based on the quantity
  List<String> get updateIngredientAmounts {
    return _baseIngredientAmounts
        .map((amount) => (amount * _currentNumber).toStringAsFixed(1))
        .toList();
  }

  // Increase servings
  void increaseQuantity() {
    _currentNumber++;
    notifyListeners();
  }

  // Decrease servings
  void decreaseQuantity() {
    if (_currentNumber > 1) {
      _currentNumber--;
      notifyListeners();
    }
  }
}
