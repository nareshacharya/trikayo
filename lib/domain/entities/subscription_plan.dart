import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'subscription_plan.g.dart';

enum PlanTier {
  basic,
  plus,
  pro,
}

@JsonSerializable()
class SubscriptionPlan extends Equatable {
  final String id;
  final String name;
  final String description;
  final PlanTier tier;
  final double monthlyPrice;
  final double yearlyPrice;
  final List<String> features;
  final int maxMealsPerDay;
  final int maxCaloriesPerMeal;
  final bool includesNutritionTracking;
  final bool includesMealPlanning;
  final bool includesPrioritySupport;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SubscriptionPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.tier,
    required this.monthlyPrice,
    required this.yearlyPrice,
    this.features = const [],
    this.maxMealsPerDay = 3,
    this.maxCaloriesPerMeal = 800,
    this.includesNutritionTracking = false,
    this.includesMealPlanning = false,
    this.includesPrioritySupport = false,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) => _$SubscriptionPlanFromJson(json);
  Map<String, dynamic> toJson() => _$SubscriptionPlanToJson(this);

  /// Get yearly savings percentage
  double get yearlySavings {
    final monthlyTotal = monthlyPrice * 12;
    return ((monthlyTotal - yearlyPrice) / monthlyTotal) * 100;
  }

  /// Check if plan includes a specific feature
  bool hasFeature(String feature) => features.contains(feature);

  SubscriptionPlan copyWith({
    String? id,
    String? name,
    String? description,
    PlanTier? tier,
    double? monthlyPrice,
    double? yearlyPrice,
    List<String>? features,
    int? maxMealsPerDay,
    int? maxCaloriesPerMeal,
    bool? includesNutritionTracking,
    bool? includesMealPlanning,
    bool? includesPrioritySupport,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SubscriptionPlan(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      tier: tier ?? this.tier,
      monthlyPrice: monthlyPrice ?? this.monthlyPrice,
      yearlyPrice: yearlyPrice ?? this.yearlyPrice,
      features: features ?? this.features,
      maxMealsPerDay: maxMealsPerDay ?? this.maxMealsPerDay,
      maxCaloriesPerMeal: maxCaloriesPerMeal ?? this.maxCaloriesPerMeal,
      includesNutritionTracking: includesNutritionTracking ?? this.includesNutritionTracking,
      includesMealPlanning: includesMealPlanning ?? this.includesMealPlanning,
      includesPrioritySupport: includesPrioritySupport ?? this.includesPrioritySupport,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        tier,
        monthlyPrice,
        yearlyPrice,
        features,
        maxMealsPerDay,
        maxCaloriesPerMeal,
        includesNutritionTracking,
        includesMealPlanning,
        includesPrioritySupport,
        isActive,
        createdAt,
        updatedAt,
      ];
}
