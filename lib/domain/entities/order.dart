import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'meal.dart';

part 'order.g.dart';

enum OrderStatus {
  pending,
  confirmed,
  preparing,
  ready,
  delivered,
  cancelled,
}

enum OrderSlot {
  breakfast,
  lunch,
  dinner,
  snack,
}

@JsonSerializable()
class OrderItem extends Equatable {
  final String mealId;
  final String mealTitle;
  final String mealImageUrl;
  final double price;
  final int quantity;
  final int calories;
  final Map<String, dynamic>? customizations;

  const OrderItem({
    required this.mealId,
    required this.mealTitle,
    required this.mealImageUrl,
    required this.price,
    required this.quantity,
    required this.calories,
    this.customizations,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => _$OrderItemFromJson(json);
  Map<String, dynamic> toJson() => _$OrderItemToJson(this);

  double get totalPrice => price * quantity;
  int get totalCalories => calories * quantity;

  OrderItem copyWith({
    String? mealId,
    String? mealTitle,
    String? mealImageUrl,
    double? price,
    int? quantity,
    int? calories,
    Map<String, dynamic>? customizations,
  }) {
    return OrderItem(
      mealId: mealId ?? this.mealId,
      mealTitle: mealTitle ?? this.mealTitle,
      mealImageUrl: mealImageUrl ?? this.mealImageUrl,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      calories: calories ?? this.calories,
      customizations: customizations ?? this.customizations,
    );
  }

  @override
  List<Object?> get props => [
        mealId,
        mealTitle,
        mealImageUrl,
        price,
        quantity,
        calories,
        customizations,
      ];
}

@JsonSerializable()
class DeliveryAddress extends Equatable {
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final double latitude;
  final double longitude;
  final String? apartment;
  final String? instructions;

  const DeliveryAddress({
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    required this.latitude,
    required this.longitude,
    this.apartment,
    this.instructions,
  });

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) => _$DeliveryAddressFromJson(json);
  Map<String, dynamic> toJson() => _$DeliveryAddressToJson(this);

  String get fullAddress {
    final parts = [street];
    if (apartment != null) parts.add('Apt $apartment');
    parts.addAll([city, state, zipCode, country]);
    return parts.join(', ');
  }

  DeliveryAddress copyWith({
    String? street,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    double? latitude,
    double? longitude,
    String? apartment,
    String? instructions,
  }) {
    return DeliveryAddress(
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      apartment: apartment ?? this.apartment,
      instructions: instructions ?? this.instructions,
    );
  }

  @override
  List<Object?> get props => [
        street,
        city,
        state,
        zipCode,
        country,
        latitude,
        longitude,
        apartment,
        instructions,
      ];
}

@JsonSerializable()
class Order extends Equatable {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final DeliveryAddress address;
  final OrderSlot slot;
  final OrderStatus status;
  final DateTime orderDate;
  final DateTime? deliveryDate;
  final double subtotal;
  final double tax;
  final double deliveryFee;
  final double total;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.address,
    required this.slot,
    this.status = OrderStatus.pending,
    required this.orderDate,
    this.deliveryDate,
    required this.subtotal,
    this.tax = 0.0,
    this.deliveryFee = 0.0,
    required this.total,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
  Map<String, dynamic> toJson() => _$OrderToJson(this);

  int get totalCalories => items.fold(0, (sum, item) => sum + item.totalCalories);
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  Order copyWith({
    String? id,
    String? userId,
    List<OrderItem>? items,
    DeliveryAddress? address,
    OrderSlot? slot,
    OrderStatus? status,
    DateTime? orderDate,
    DateTime? deliveryDate,
    double? subtotal,
    double? tax,
    double? deliveryFee,
    double? total,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Order(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      address: address ?? this.address,
      slot: slot ?? this.slot,
      status: status ?? this.status,
      orderDate: orderDate ?? this.orderDate,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      total: total ?? this.total,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        items,
        address,
        slot,
        status,
        orderDate,
        deliveryDate,
        subtotal,
        tax,
        deliveryFee,
        total,
        notes,
        createdAt,
        updatedAt,
      ];
}
