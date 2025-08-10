import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'macros.dart';

part 'nutrition_profile.g.dart';

@JsonSerializable()
class NutritionProfile extends Equatable {
  final String id;
  final String userId;
  final String name;
  final int targetCalories;
  final Macros targetMacros;
  final List<String> dietaryRestrictions;
  final List<String> allergies;
  final List<String> preferences;
  final double? weight;
  final double? height;
  final int? age;
  final String? activityLevel;
  final String? goal; // weight_loss, maintenance, muscle_gain
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const NutritionProfile({
    required this.id,
    required this.userId,
    required this.name,
    required this.targetCalories,
    required this.targetMacros,
    this.dietaryRestrictions = const [],
    this.allergies = const [],
    this.preferences = const [],
    this.weight,
    this.height,
    this.age,
    this.activityLevel,
    this.goal,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NutritionProfile.fromJson(Map<String, dynamic> json) => _$NutritionProfileFromJson(json);
  Map<String, dynamic> toJson() => _$NutritionProfileToJson(this);

  /// Check if a food item is compatible with dietary restrictions
  bool isCompatibleWith(List<String> foodAllergens, List<String> foodTags) {
    // Check allergies
    for (final allergy in allergies) {
      if (foodAllergens.contains(allergy)) {
        return false;
      }
    }

    // Check dietary restrictions
    for (final restriction in dietaryRestrictions) {
      if (restriction == 'vegetarian' && foodTags.contains('meat')) {
        return false;
      }
      if (restriction == 'vegan' && (foodTags.contains('meat') || foodTags.contains('dairy'))) {
        return false;
      }
      if (restriction == 'gluten_free' && foodTags.contains('gluten')) {
        return false;
      }
      if (restriction == 'dairy_free' && foodTags.contains('dairy')) {
        return false;
      }
    }

    return true;
  }

  /// Calculate BMI if weight and height are available
  double? get bmi {
    if (weight != null && height != null) {
      final heightInMeters = height! / 100;
      return weight! / (heightInMeters * heightInMeters);
    }
    return null;
  }

  /// Get BMI category
  String? get bmiCategory {
    final bmiValue = bmi;
    if (bmiValue == null) return null;

    if (bmiValue < 18.5) return 'Underweight';
    if (bmiValue < 25) return 'Normal';
    if (bmiValue < 30) return 'Overweight';
    return 'Obese';
  }

  NutritionProfile copyWith({
    String? id,
    String? userId,
    String? name,
    int? targetCalories,
    Macros? targetMacros,
    List<String>? dietaryRestrictions,
    List<String>? allergies,
    List<String>? preferences,
    double? weight,
    double? height,
    int? age,
    String? activityLevel,
    String? goal,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NutritionProfile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      targetCalories: targetCalories ?? this.targetCalories,
      targetMacros: targetMacros ?? this.targetMacros,
      dietaryRestrictions: dietaryRestrictions ?? this.dietaryRestrictions,
      allergies: allergies ?? this.allergies,
      preferences: preferences ?? this.preferences,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      age: age ?? this.age,
      activityLevel: activityLevel ?? this.activityLevel,
      goal: goal ?? this.goal,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        targetCalories,
        targetMacros,
        dietaryRestrictions,
        allergies,
        preferences,
        weight,
        height,
        age,
        activityLevel,
        goal,
        isActive,
        createdAt,
        updatedAt,
      ];
}
