import 'package:hive_flutter/hive_flutter.dart';

import '../../core/result/result.dart';

/// Repository for user-related data operations
class UserRepository {
  final Box _userBox;

  UserRepository(this._userBox);

  /// Save user profile
  Future<Result<void>> saveUserProfile(Map<String, dynamic> userProfile) async {
    try {
      await _userBox.put('profile', userProfile);
      return const Success(null);
    } catch (e) {
      return Failure(Exception('Failed to save user profile: $e'));
    }
  }

  /// Get user profile
  Future<Result<Map<String, dynamic>?>> getUserProfile() async {
    try {
      final profile = _userBox.get('profile');
      if (profile != null) {
        return Success(Map<String, dynamic>.from(profile));
      }
      return const Success(null);
    } catch (e) {
      return Failure(Exception('Failed to get user profile: $e'));
    }
  }

  /// Save user preferences
  Future<Result<void>> saveUserPreferences(Map<String, dynamic> preferences) async {
    try {
      await _userBox.put('preferences', preferences);
      return const Success(null);
    } catch (e) {
      return Failure(Exception('Failed to save user preferences: $e'));
    }
  }

  /// Get user preferences
  Future<Result<Map<String, dynamic>?>> getUserPreferences() async {
    try {
      final preferences = _userBox.get('preferences');
      if (preferences != null) {
        return Success(Map<String, dynamic>.from(preferences));
      }
      return const Success(null);
    } catch (e) {
      return Failure(Exception('Failed to get user preferences: $e'));
    }
  }

  /// Save user's favorite meals
  Future<Result<void>> saveFavoriteMeals(List<String> mealIds) async {
    try {
      await _userBox.put('favorite_meals', mealIds);
      return const Success(null);
    } catch (e) {
      return Failure(Exception('Failed to save favorite meals: $e'));
    }
  }

  /// Get user's favorite meals
  Future<Result<List<String>>> getFavoriteMeals() async {
    try {
      final favoriteMeals = _userBox.get('favorite_meals');
      if (favoriteMeals != null) {
        return Success(List<String>.from(favoriteMeals));
      }
      return const Success([]);
    } catch (e) {
      return Failure(Exception('Failed to get favorite meals: $e'));
    }
  }

  /// Add meal to favorites
  Future<Result<void>> addToFavorites(String mealId) async {
    try {
      final currentFavorites = await getFavoriteMeals();
      if (currentFavorites.isSuccess) {
        final favorites = currentFavorites.successValue ?? [];
        if (!favorites.contains(mealId)) {
          favorites.add(mealId);
          await saveFavoriteMeals(favorites);
        }
      }
      return const Success(null);
    } catch (e) {
      return Failure(Exception('Failed to add to favorites: $e'));
    }
  }

  /// Remove meal from favorites
  Future<Result<void>> removeFromFavorites(String mealId) async {
    try {
      final currentFavorites = await getFavoriteMeals();
      if (currentFavorites.isSuccess) {
        final favorites = currentFavorites.successValue ?? [];
        favorites.remove(mealId);
        await saveFavoriteMeals(favorites);
      }
      return const Success(null);
    } catch (e) {
      return Failure(Exception('Failed to remove from favorites: $e'));
    }
  }

  /// Check if meal is in favorites
  Future<Result<bool>> isFavorite(String mealId) async {
    try {
      final favorites = await getFavoriteMeals();
      if (favorites.isSuccess) {
        return Success(favorites.successValue?.contains(mealId) ?? false);
      }
      return const Success(false);
    } catch (e) {
      return Failure(Exception('Failed to check favorite status: $e'));
    }
  }

  /// Clear all user data
  Future<Result<void>> clearUserData() async {
    try {
      await _userBox.clear();
      return const Success(null);
    } catch (e) {
      return Failure(Exception('Failed to clear user data: $e'));
    }
  }
}
