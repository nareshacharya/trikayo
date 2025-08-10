import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'macros.dart';

part 'meal.g.dart';

@JsonSerializable()
class Meal extends Equatable {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  final int calories;
  final Macros macros;
  final List<String> allergens;
  final List<String> tags;
  final String vendorId;
  final bool isAvailable;
  final double rating;
  final int reviewCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Meal({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.calories,
    required this.macros,
    this.allergens = const [],
    this.tags = const [],
    required this.vendorId,
    this.isAvailable = true,
    this.rating = 0.0,
    this.reviewCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Meal.fromJson(Map<String, dynamic> json) => _$MealFromJson(json);
  Map<String, dynamic> toJson() => _$MealToJson(this);

  Meal copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    double? price,
    int? calories,
    Macros? macros,
    List<String>? allergens,
    List<String>? tags,
    String? vendorId,
    bool? isAvailable,
    double? rating,
    int? reviewCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Meal(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      calories: calories ?? this.calories,
      macros: macros ?? this.macros,
      allergens: allergens ?? this.allergens,
      tags: tags ?? this.tags,
      vendorId: vendorId ?? this.vendorId,
      isAvailable: isAvailable ?? this.isAvailable,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        imageUrl,
        price,
        calories,
        macros,
        allergens,
        tags,
        vendorId,
        isAvailable,
        rating,
        reviewCount,
        createdAt,
        updatedAt,
      ];
}
