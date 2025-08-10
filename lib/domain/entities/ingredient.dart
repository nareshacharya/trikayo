import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'macros.dart';

part 'ingredient.g.dart';

@JsonSerializable()
class Ingredient extends Equatable {
  final String id;
  final String name;
  final String description;
  final double quantity;
  final String unit;
  final Macros macros;
  final int calories;
  final List<String> allergens;
  final String? imageUrl;

  const Ingredient({
    required this.id,
    required this.name,
    required this.description,
    required this.quantity,
    required this.unit,
    required this.macros,
    required this.calories,
    this.allergens = const [],
    this.imageUrl,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) => _$IngredientFromJson(json);
  Map<String, dynamic> toJson() => _$IngredientToJson(this);

  Ingredient copyWith({
    String? id,
    String? name,
    String? description,
    double? quantity,
    String? unit,
    Macros? macros,
    int? calories,
    List<String>? allergens,
    String? imageUrl,
  }) {
    return Ingredient(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      macros: macros ?? this.macros,
      calories: calories ?? this.calories,
      allergens: allergens ?? this.allergens,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        quantity,
        unit,
        macros,
        calories,
        allergens,
        imageUrl,
      ];
}
