import '../../core/result/result.dart';
import '../entities/meal.dart';

/// Repository interface for meal-related operations
abstract class MealRepository {
  /// Get all meals
  Future<Result<List<Meal>>> getMeals();

  /// Get meal by ID
  Future<Result<Meal>> getMealById(String id);

  /// Get meals by vendor ID
  Future<Result<List<Meal>>> getMealsByVendor(String vendorId);

  /// Search meals by query
  Future<Result<List<Meal>>> searchMeals(String query);

  /// Get meals by tags
  Future<Result<List<Meal>>> getMealsByTags(List<String> tags);

  /// Get meals within calorie range
  Future<Result<List<Meal>>> getMealsByCalorieRange(int minCalories, int maxCalories);

  /// Get meals compatible with dietary restrictions
  Future<Result<List<Meal>>> getMealsByDietaryRestrictions(List<String> restrictions);

  /// Create a new meal
  Future<Result<Meal>> createMeal(Meal meal);

  /// Update an existing meal
  Future<Result<Meal>> updateMeal(Meal meal);

  /// Delete a meal
  Future<Result<void>> deleteMeal(String id);

  /// Get favorite meals for a user
  Future<Result<List<Meal>>> getFavoriteMeals(String userId);

  /// Add meal to favorites
  Future<Result<void>> addToFavorites(String userId, String mealId);

  /// Remove meal from favorites
  Future<Result<void>> removeFromFavorites(String userId, String mealId);

  /// Check if meal is in user's favorites
  Future<Result<bool>> isFavorite(String userId, String mealId);
}
