import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_app/Provider/quantity.dart';

void main() {
  group('QuantityProvider Servings & Ingredient Scaling Tests', () {
    test('initial servings count defaults to 1', () {
      final provider = QuantityProvider();
      expect(provider.currentNumber, 1);
    });

    test('increaseQuantity increments the servings count', () {
      final provider = QuantityProvider();
      provider.increaseQuantity();
      expect(provider.currentNumber, 2);
      provider.increaseQuantity();
      expect(provider.currentNumber, 3);
    });

    test('decreaseQuantity decrements servings count with minimum clamp at 1', () {
      final provider = QuantityProvider();
      provider.increaseQuantity();
      provider.increaseQuantity();
      expect(provider.currentNumber, 3);

      provider.decreaseQuantity();
      expect(provider.currentNumber, 2);

      provider.decreaseQuantity();
      expect(provider.currentNumber, 1);

      // Decreasing at 1 should not go to 0 or negative
      provider.decreaseQuantity();
      expect(provider.currentNumber, 1);
    });

    test('updateIngredientAmounts dynamically scales base amounts by servings count', () {
      final provider = QuantityProvider();
      provider.setBaseIngredientAmounts([150.0, 50.0, 2.5]);

      // Servings = 1
      expect(provider.updateIngredientAmounts, ['150.0', '50.0', '2.5']);

      // Double servings (servings = 2)
      provider.increaseQuantity();
      expect(provider.updateIngredientAmounts, ['300.0', '100.0', '5.0']);

      // Triple servings (servings = 3)
      provider.increaseQuantity();
      expect(provider.updateIngredientAmounts, ['450.0', '150.0', '7.5']);
    });
  });
}
