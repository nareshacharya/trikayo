import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/meal.dart';
import '../../../domain/repositories/meal_repository.dart';
import '../../../app/di/dependency_injection.dart';

final catalogControllerProvider =
    StateNotifierProvider<CatalogController, AsyncValue<List<Meal>>>((ref) {
  final mealRepository = ref.watch(mealRepositoryProvider);
  return CatalogController(mealRepository);
});

class CatalogController extends StateNotifier<AsyncValue<List<Meal>>> {
  final MealRepository _mealRepository;

  CatalogController(this._mealRepository) : super(const AsyncValue.loading()) {
    loadMeals();
  }

  Future<void> loadMeals() async {
    try {
      state = const AsyncValue.loading();
      final result = await _mealRepository.getMeals();
      result.when(
        success: (meals) => state = AsyncValue.data(meals),
        failure: (exception) =>
            state = AsyncValue.error(exception, StackTrace.current),
      );
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> searchMeals(String query) async {
    if (query.isEmpty) {
      await loadMeals();
      return;
    }

    try {
      state = const AsyncValue.loading();
      final result = await _mealRepository.searchMeals(query);
      result.when(
        success: (meals) => state = AsyncValue.data(meals),
        failure: (exception) =>
            state = AsyncValue.error(exception, StackTrace.current),
      );
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> filterByTags(List<String> tags) async {
    try {
      state = const AsyncValue.loading();
      final result = await _mealRepository.getMealsByTags(tags);
      result.when(
        success: (meals) => state = AsyncValue.data(meals),
        failure: (exception) =>
            state = AsyncValue.error(exception, StackTrace.current),
      );
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> filterByCalorieRange(int minCalories, int maxCalories) async {
    try {
      state = const AsyncValue.loading();
      final result = await _mealRepository.getMealsByCalorieRange(
          minCalories, maxCalories);
      result.when(
        success: (meals) => state = AsyncValue.data(meals),
        failure: (exception) =>
            state = AsyncValue.error(exception, StackTrace.current),
      );
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> filterByDietaryRestrictions(List<String> restrictions) async {
    try {
      state = const AsyncValue.loading();
      final result =
          await _mealRepository.getMealsByDietaryRestrictions(restrictions);
      result.when(
        success: (meals) => state = AsyncValue.data(meals),
        failure: (exception) =>
            state = AsyncValue.error(exception, StackTrace.current),
      );
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
