import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'macros.g.dart';

@JsonSerializable()
class Macros extends Equatable {
  final double protein;
  final double carbs;
  final double fat;
  final double fiber;
  final double sugar;
  final double sodium;

  const Macros({
    required this.protein,
    required this.carbs,
    required this.fat,
    this.fiber = 0.0,
    this.sugar = 0.0,
    this.sodium = 0.0,
  });

  factory Macros.fromJson(Map<String, dynamic> json) => _$MacrosFromJson(json);
  Map<String, dynamic> toJson() => _$MacrosToJson(this);

  /// Total calories calculated from macros
  double get totalCalories => (protein * 4) + (carbs * 4) + (fat * 9);

  /// Protein percentage of total calories
  double get proteinPercentage => (protein * 4) / totalCalories * 100;

  /// Carbs percentage of total calories
  double get carbsPercentage => (carbs * 4) / totalCalories * 100;

  /// Fat percentage of total calories
  double get fatPercentage => (fat * 9) / totalCalories * 100;

  Macros copyWith({
    double? protein,
    double? carbs,
    double? fat,
    double? fiber,
    double? sugar,
    double? sodium,
  }) {
    return Macros(
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      fiber: fiber ?? this.fiber,
      sugar: sugar ?? this.sugar,
      sodium: sodium ?? this.sodium,
    );
  }

  @override
  List<Object?> get props => [
        protein,
        carbs,
        fat,
        fiber,
        sugar,
        sodium,
      ];
}
