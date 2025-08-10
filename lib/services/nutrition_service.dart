import '../core/result/result.dart';
import '../domain/entities/meal.dart';
import '../domain/entities/ingredient.dart';
import '../domain/entities/macros.dart';

/// Interface for nutrition-related services
abstract class NutritionService {
  /// Estimate nutrition from ingredients
  Future<Result<Macros>> estimateFromIngredients(List<Ingredient> ingredients);

  /// Find equivalent meals based on criteria
  Future<Result<List<Meal>>> findEquivalentMeals({
    required int targetCalories,
    required Macros macroRange,
    List<String>? tags,
    double? radiusKm,
  });

  /// Rebalance nutrition after cheat meal
  Future<Result<Macros>> rebalanceAfterCheat(Macros cheatMealMacros, Macros dailyTarget);

  /// Calculate daily nutrition needs
  Future<Result<Macros>> calculateDailyNeeds({
    required double weight,
    required double height,
    required int age,
    required String gender,
    required String activityLevel,
    required String goal,
  });

  /// Analyze meal nutrition
  Future<Result<Map<String, dynamic>>> analyzeMealNutrition(Meal meal);

  /// Get nutrition recommendations
  Future<Result<List<String>>> getNutritionRecommendations(Macros currentMacros, Macros targetMacros);

  /// Calculate meal compatibility score
  Future<Result<double>> calculateCompatibilityScore(Meal meal, Macros targetMacros, List<String> restrictions);
}

/// Mock implementation of NutritionService
class MockNutritionService implements NutritionService {
  @override
  Future<Result<Macros>> estimateFromIngredients(List<Ingredient> ingredients) async {
    // Mock implementation
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFat = 0;

    for (final ingredient in ingredients) {
      totalProtein += ingredient.macros.protein * ingredient.quantity;
      totalCarbs += ingredient.macros.carbs * ingredient.quantity;
      totalFat += ingredient.macros.fat * ingredient.quantity;
    }

    return Success(Macros(
      protein: totalProtein,
      carbs: totalCarbs,
      fat: totalFat,
    ));
  }

  @override
  Future<Result<List<Meal>>> findEquivalentMeals({
    required int targetCalories,
    required Macros macroRange,
    List<String>? tags,
    double? radiusKm,
  }) async {
    // Mock implementation - return empty list for now
    return const Success([]);
  }

  @override
  Future<Result<Macros>> rebalanceAfterCheat(Macros cheatMealMacros, Macros dailyTarget) async {
    // Mock implementation - reduce other meals proportionally
    final remainingProtein = dailyTarget.protein - cheatMealMacros.protein;
    final remainingCarbs = dailyTarget.carbs - cheatMealMacros.carbs;
    final remainingFat = dailyTarget.fat - cheatMealMacros.fat;

    return Success(Macros(
      protein: remainingProtein > 0 ? remainingProtein : 0,
      carbs: remainingCarbs > 0 ? remainingCarbs : 0,
      fat: remainingFat > 0 ? remainingFat : 0,
    ));
  }

  @override
  Future<Result<Macros>> calculateDailyNeeds({
    required double weight,
    required double height,
    required int age,
    required String gender,
    required String activityLevel,
    required String goal,
  }) async {
    // Mock BMR calculation using Mifflin-St Jeor Equation
    double bmr;
    if (gender.toLowerCase() == 'male') {
      bmr = 10 * weight + 6.25 * height - 5 * age + 5;
    } else {
      bmr = 10 * weight + 6.25 * height - 5 * age - 161;
    }

    // Activity multiplier
    double activityMultiplier = 1.2; // Sedentary
    switch (activityLevel.toLowerCase()) {
      case 'lightly_active':
        activityMultiplier = 1.375;
        break;
      case 'moderately_active':
        activityMultiplier = 1.55;
        break;
      case 'very_active':
        activityMultiplier = 1.725;
        break;
      case 'extremely_active':
        activityMultiplier = 1.9;
        break;
    }

    double tdee = bmr * activityMultiplier;

    // Goal adjustment
    switch (goal.toLowerCase()) {
      case 'weight_loss':
        tdee *= 0.85; // 15% deficit
        break;
      case 'muscle_gain':
        tdee *= 1.1; // 10% surplus
        break;
    }

    // Macro distribution (40% carbs, 30% protein, 30% fat)
    final protein = (tdee * 0.3) / 4; // 4 calories per gram
    final carbs = (tdee * 0.4) / 4; // 4 calories per gram
    final fat = (tdee * 0.3) / 9; // 9 calories per gram

    return Success(Macros(
      protein: protein,
      carbs: carbs,
      fat: fat,
    ));
  }

  @override
  Future<Result<Map<String, dynamic>>> analyzeMealNutrition(Meal meal) async {
    final analysis = {
      'calories': meal.calories,
      'protein_percentage': meal.macros.proteinPercentage,
      'carbs_percentage': meal.macros.carbsPercentage,
      'fat_percentage': meal.macros.fatPercentage,
      'is_balanced': meal.macros.proteinPercentage >= 20 && meal.macros.proteinPercentage <= 35,
      'allergen_warnings': meal.allergens,
      'nutrition_score': _calculateNutritionScore(meal),
    };

    return Success(analysis);
  }

  @override
  Future<Result<List<String>>> getNutritionRecommendations(Macros currentMacros, Macros targetMacros) async {
    final recommendations = <String>[];

    if (currentMacros.protein < targetMacros.protein * 0.8) {
      recommendations.add('Consider adding more protein to your meals');
    }
    if (currentMacros.carbs > targetMacros.carbs * 1.2) {
      recommendations.add('Try reducing carbohydrate intake');
    }
    if (currentMacros.fat > targetMacros.fat * 1.2) {
      recommendations.add('Consider lower fat options');
    }

    return Success(recommendations);
  }

  @override
  Future<Result<double>> calculateCompatibilityScore(Meal meal, Macros targetMacros, List<String> restrictions) async {
    double score = 1.0;

    // Check calorie compatibility
    final calorieRatio = meal.calories / targetMacros.totalCalories;
    if (calorieRatio > 1.5 || calorieRatio < 0.5) {
      score *= 0.7;
    }

    // Check macro compatibility
    final proteinDiff = (meal.macros.proteinPercentage - targetMacros.proteinPercentage).abs();
    final carbsDiff = (meal.macros.carbsPercentage - targetMacros.carbsPercentage).abs();
    final fatDiff = (meal.macros.fatPercentage - targetMacros.fatPercentage).abs();

    score *= (1 - (proteinDiff + carbsDiff + fatDiff) / 300);

    // Check restrictions
    for (final restriction in restrictions) {
      if (meal.allergens.contains(restriction) || meal.tags.contains(restriction)) {
        score = 0.0;
        break;
      }
    }

    return Success(score.clamp(0.0, 1.0));
  }

  double _calculateNutritionScore(Meal meal) {
    double score = 100;

    // Deduct points for high sodium
    if (meal.macros.sodium > 500) {
      score -= 10;
    }

    // Deduct points for high sugar
    if (meal.macros.sugar > 25) {
      score -= 10;
    }

    // Add points for good protein content
    if (meal.macros.protein >= 20) {
      score += 10;
    }

    // Add points for fiber
    if (meal.macros.fiber >= 5) {
      score += 10;
    }

    return score.clamp(0, 100);
  }
}
