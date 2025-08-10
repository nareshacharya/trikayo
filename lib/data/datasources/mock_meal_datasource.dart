import '../../domain/entities/meal.dart';
import '../../domain/entities/macros.dart';

/// Mock data source for meals
class MockMealDataSource {
  static List<Meal> getMockMeals() {
    return [
      Meal(
        id: '1',
        title: 'Grilled Chicken Salad',
        description: 'Fresh mixed greens with grilled chicken breast, cherry tomatoes, and balsamic vinaigrette',
        imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400',
        price: 12.99,
        calories: 350,
        macros: const Macros(
          protein: 35.0,
          carbs: 15.0,
          fat: 18.0,
          fiber: 8.0,
          sugar: 5.0,
          sodium: 450.0,
        ),
        allergens: ['dairy'],
        tags: ['healthy', 'protein', 'salad', 'low-carb'],
        vendorId: 'vendor1',
        isAvailable: true,
        rating: 4.5,
        reviewCount: 128,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now(),
      ),
      Meal(
        id: '2',
        title: 'Quinoa Buddha Bowl',
        description: 'Nutritious quinoa bowl with roasted vegetables, avocado, and tahini dressing',
        imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400',
        price: 14.99,
        calories: 420,
        macros: const Macros(
          protein: 18.0,
          carbs: 45.0,
          fat: 22.0,
          fiber: 12.0,
          sugar: 8.0,
          sodium: 380.0,
        ),
        allergens: ['nuts'],
        tags: ['vegan', 'vegetarian', 'healthy', 'bowl'],
        vendorId: 'vendor2',
        isAvailable: true,
        rating: 4.7,
        reviewCount: 95,
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
        updatedAt: DateTime.now(),
      ),
      Meal(
        id: '3',
        title: 'Salmon Teriyaki',
        description: 'Grilled salmon with teriyaki glaze, steamed rice, and seasonal vegetables',
        imageUrl: 'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=400',
        price: 18.99,
        calories: 580,
        macros: const Macros(
          protein: 42.0,
          carbs: 55.0,
          fat: 28.0,
          fiber: 6.0,
          sugar: 12.0,
          sodium: 620.0,
        ),
        allergens: ['fish', 'soy'],
        tags: ['protein', 'omega-3', 'japanese', 'healthy'],
        vendorId: 'vendor1',
        isAvailable: true,
        rating: 4.8,
        reviewCount: 156,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        updatedAt: DateTime.now(),
      ),
      Meal(
        id: '4',
        title: 'Mediterranean Pasta',
        description: 'Whole wheat pasta with olive oil, cherry tomatoes, olives, and feta cheese',
        imageUrl: 'https://images.unsplash.com/photo-1621996346565-e3dbc353d2e5?w=400',
        price: 13.99,
        calories: 480,
        macros: const Macros(
          protein: 16.0,
          carbs: 65.0,
          fat: 24.0,
          fiber: 8.0,
          sugar: 6.0,
          sodium: 520.0,
        ),
        allergens: ['dairy', 'gluten'],
        tags: ['mediterranean', 'vegetarian', 'pasta'],
        vendorId: 'vendor3',
        isAvailable: true,
        rating: 4.3,
        reviewCount: 87,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now(),
      ),
      Meal(
        id: '5',
        title: 'Beef Stir Fry',
        description: 'Tender beef strips with colorful vegetables in a savory sauce, served with brown rice',
        imageUrl: 'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=400',
        price: 16.99,
        calories: 520,
        macros: const Macros(
          protein: 38.0,
          carbs: 48.0,
          fat: 26.0,
          fiber: 7.0,
          sugar: 8.0,
          sodium: 680.0,
        ),
        allergens: ['soy'],
        tags: ['protein', 'asian', 'stir-fry', 'beef'],
        vendorId: 'vendor2',
        isAvailable: true,
        rating: 4.6,
        reviewCount: 112,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        updatedAt: DateTime.now(),
      ),
      Meal(
        id: '6',
        title: 'Vegetable Curry',
        description: 'Spicy vegetable curry with chickpeas, served with basmati rice and naan bread',
        imageUrl: 'https://images.unsplash.com/photo-1455619452474-d2be8b1e70cd?w=400',
        price: 11.99,
        calories: 380,
        macros: const Macros(
          protein: 12.0,
          carbs: 52.0,
          fat: 18.0,
          fiber: 14.0,
          sugar: 10.0,
          sodium: 420.0,
        ),
        allergens: ['gluten'],
        tags: ['vegan', 'vegetarian', 'indian', 'spicy', 'curry'],
        vendorId: 'vendor3',
        isAvailable: true,
        rating: 4.4,
        reviewCount: 73,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  static Meal? getMealById(String id) {
    try {
      return getMockMeals().firstWhere((meal) => meal.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<Meal> searchMeals(String query) {
    final meals = getMockMeals();
    final lowercaseQuery = query.toLowerCase();
    
    return meals.where((meal) {
      return meal.title.toLowerCase().contains(lowercaseQuery) ||
             meal.description.toLowerCase().contains(lowercaseQuery) ||
             meal.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }

  static List<Meal> getMealsByTags(List<String> tags) {
    final meals = getMockMeals();
    
    return meals.where((meal) {
      return tags.any((tag) => meal.tags.contains(tag));
    }).toList();
  }

  static List<Meal> getMealsByCalorieRange(int minCalories, int maxCalories) {
    final meals = getMockMeals();
    
    return meals.where((meal) {
      return meal.calories >= minCalories && meal.calories <= maxCalories;
    }).toList();
  }
}
