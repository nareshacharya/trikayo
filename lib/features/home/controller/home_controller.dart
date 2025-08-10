import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/meal.dart';
import '../../../domain/entities/subscription_plan.dart';
import '../../../domain/repositories/meal_repository.dart';
import '../../../services/subscription_service.dart';
import '../../../app/di/dependency_injection.dart';

// State class for home screen
class HomeState extends Equatable {
  final bool isLoading;
  final List<Meal> meals;
  final List<Meal> filteredMeals;
  final List<Meal> aiPicks;
  final PlanTier? userTier;
  final String? error;
  final String searchQuery;
  final List<String> selectedTags;
  final List<String> selectedCuisines;
  final int? minCalories;
  final int? maxCalories;
  final double? maxDistance;

  const HomeState({
    this.isLoading = false,
    this.meals = const [],
    this.filteredMeals = const [],
    this.aiPicks = const [],
    this.userTier,
    this.error,
    this.searchQuery = '',
    this.selectedTags = const [],
    this.selectedCuisines = const [],
    this.minCalories,
    this.maxCalories,
    this.maxDistance,
  });

  HomeState copyWith({
    bool? isLoading,
    List<Meal>? meals,
    List<Meal>? filteredMeals,
    List<Meal>? aiPicks,
    PlanTier? userTier,
    String? error,
    String? searchQuery,
    List<String>? selectedTags,
    List<String>? selectedCuisines,
    int? minCalories,
    int? maxCalories,
    double? maxDistance,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      meals: meals ?? this.meals,
      filteredMeals: filteredMeals ?? this.filteredMeals,
      aiPicks: aiPicks ?? this.aiPicks,
      userTier: userTier ?? this.userTier,
      error: error ?? this.error,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedTags: selectedTags ?? this.selectedTags,
      selectedCuisines: selectedCuisines ?? this.selectedCuisines,
      minCalories: minCalories ?? this.minCalories,
      maxCalories: maxCalories ?? this.maxCalories,
      maxDistance: maxDistance ?? this.maxDistance,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        meals,
        filteredMeals,
        aiPicks,
        userTier,
        error,
        searchQuery,
        selectedTags,
        selectedCuisines,
        minCalories,
        maxCalories,
        maxDistance,
      ];
}

// Home controller
class HomeController extends StateNotifier<HomeState> {
  final MealRepository _mealRepository;
  final SubscriptionService _subscriptionService;
  final String _userId;

  HomeController(this._mealRepository, this._subscriptionService, this._userId)
      : super(const HomeState());

  // Initialize the controller
  Future<void> initialize() async {
    await Future.wait([
      _loadUserTier(),
      _loadMeals(),
    ]);
  }

  // Load user subscription tier
  Future<void> _loadUserTier() async {
    try {
      final tier = await _subscriptionService.getUserTier(_userId);
      state = state.copyWith(userTier: tier);
    } catch (e) {
      state = state.copyWith(error: 'Failed to load user tier: $e');
    }
  }

  // Load meals from repository
  Future<void> _loadMeals() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _mealRepository.getMeals();
      result.when(
        success: (meals) {
          state = state.copyWith(
            meals: meals,
            filteredMeals: meals,
            isLoading: false,
          );
          _generateAiPicks(meals);
        },
        failure: (error) {
          state = state.copyWith(
            error: 'Failed to load meals: $error',
            isLoading: false,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Unexpected error: $e',
        isLoading: false,
      );
    }
  }

  // Generate AI picks for Pro users
  void _generateAiPicks(List<Meal> meals) {
    if (state.userTier == PlanTier.pro && meals.isNotEmpty) {
      // Simple algorithm: pick meals with high ratings and diverse macros
      final sortedMeals = List<Meal>.from(meals)
        ..sort((a, b) => b.rating.compareTo(a.rating));

      final aiPicks = sortedMeals.take(5).toList();
      state = state.copyWith(aiPicks: aiPicks);
    }
  }

  // Search meals
  void searchMeals(String query) {
    state = state.copyWith(searchQuery: query);
    _applyFilters();
  }

  // Add/remove tag filter
  void toggleTagFilter(String tag) {
    final tags = List<String>.from(state.selectedTags);
    if (tags.contains(tag)) {
      tags.remove(tag);
    } else {
      tags.add(tag);
    }
    state = state.copyWith(selectedTags: tags);
    _applyFilters();
  }

  // Add/remove cuisine filter
  void toggleCuisineFilter(String cuisine) {
    final cuisines = List<String>.from(state.selectedCuisines);
    if (cuisines.contains(cuisine)) {
      cuisines.remove(cuisine);
    } else {
      cuisines.add(cuisine);
    }
    state = state.copyWith(selectedCuisines: cuisines);
    _applyFilters();
  }

  // Set calorie range filter
  void setCalorieRange(int? min, int? max) {
    state = state.copyWith(
      minCalories: min,
      maxCalories: max,
    );
    _applyFilters();
  }

  // Set distance filter
  void setDistanceFilter(double? maxDistance) {
    state = state.copyWith(maxDistance: maxDistance);
    _applyFilters();
  }

  // Apply all filters
  void _applyFilters() {
    List<Meal> filtered = List<Meal>.from(state.meals);

    // Search filter
    if (state.searchQuery.isNotEmpty) {
      final query = state.searchQuery.toLowerCase();
      filtered = filtered.where((meal) {
        return meal.title.toLowerCase().contains(query) ||
            meal.description.toLowerCase().contains(query) ||
            meal.tags.any((tag) => tag.toLowerCase().contains(query));
      }).toList();
    }

    // Tag filter
    if (state.selectedTags.isNotEmpty) {
      filtered = filtered.where((meal) {
        return state.selectedTags.any((tag) => meal.tags.contains(tag));
      }).toList();
    }

    // Cuisine filter (assuming cuisine is in tags for now)
    if (state.selectedCuisines.isNotEmpty) {
      filtered = filtered.where((meal) {
        return state.selectedCuisines
            .any((cuisine) => meal.tags.contains(cuisine));
      }).toList();
    }

    // Calorie filter
    if (state.minCalories != null || state.maxCalories != null) {
      filtered = filtered.where((meal) {
        if (state.minCalories != null && meal.calories < state.minCalories!) {
          return false;
        }
        if (state.maxCalories != null && meal.calories > state.maxCalories!) {
          return false;
        }
        return true;
      }).toList();
    }

    state = state.copyWith(filteredMeals: filtered);
  }

  // Clear all filters
  void clearFilters() {
    state = state.copyWith(
      searchQuery: '',
      selectedTags: const [],
      selectedCuisines: const [],
      minCalories: null,
      maxCalories: null,
      maxDistance: null,
      filteredMeals: state.meals,
    );
  }

  // Refresh data
  Future<void> refresh() async {
    await _loadMeals();
  }

  // Check if user has access to a feature
  bool hasFeature(String feature) {
    if (state.userTier == null) return false;

    switch (feature) {
      case 'macros':
        return state.userTier == PlanTier.plus ||
            state.userTier == PlanTier.pro;
      case 'meal_planning':
        return state.userTier == PlanTier.pro;
      case 'ai_picks':
        return state.userTier == PlanTier.pro;
      default:
        return false;
    }
  }

  // Get available tags from meals
  List<String> getAvailableTags() {
    final tags = <String>{};
    for (final meal in state.meals) {
      tags.addAll(meal.tags);
    }
    return tags.toList()..sort();
  }

  // Get available cuisines from meals
  List<String> getAvailableCuisines() {
    // For now, extract cuisines from tags
    final cuisines = <String>{};
    for (final meal in state.meals) {
      for (final tag in meal.tags) {
        if (['japanese', 'mediterranean', 'indian', 'asian', 'american']
            .contains(tag)) {
          cuisines.add(tag);
        }
      }
    }
    return cuisines.toList()..sort();
  }
}

// Provider for home controller
final homeControllerProvider =
    StateNotifierProvider.family<HomeController, HomeState, String>(
  (ref, userId) {
    final mealRepository = ref.watch(mealRepositoryProvider);
    final subscriptionService = ref.watch(subscriptionServiceProvider);
    return HomeController(mealRepository, subscriptionService, userId);
  },
);
