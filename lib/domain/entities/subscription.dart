import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'subscription_plan.dart';

part 'subscription.g.dart';

enum SubscriptionStatus {
  active,
  cancelled,
  expired,
  pending,
  trial,
}

enum BillingCycle {
  monthly,
  yearly,
}

@JsonSerializable()
class Subscription extends Equatable {
  final String id;
  final String userId;
  final String planId;
  final SubscriptionPlan plan;
  final SubscriptionStatus status;
  final BillingCycle billingCycle;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime? cancelledAt;
  final DateTime? trialEndDate;
  final double currentPrice;
  final String? paymentMethodId;
  final bool autoRenew;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Subscription({
    required this.id,
    required this.userId,
    required this.planId,
    required this.plan,
    this.status = SubscriptionStatus.pending,
    required this.billingCycle,
    required this.startDate,
    required this.endDate,
    this.cancelledAt,
    this.trialEndDate,
    required this.currentPrice,
    this.paymentMethodId,
    this.autoRenew = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) => _$SubscriptionFromJson(json);
  Map<String, dynamic> toJson() => _$SubscriptionToJson(this);

  /// Check if subscription is currently active
  bool get isActive => status == SubscriptionStatus.active;

  /// Check if subscription is in trial period
  bool get isInTrial {
    if (trialEndDate == null) return false;
    return DateTime.now().isBefore(trialEndDate!);
  }

  /// Check if subscription will expire soon (within 7 days)
  bool get isExpiringSoon {
    final daysUntilExpiry = endDate.difference(DateTime.now()).inDays;
    return daysUntilExpiry <= 7 && daysUntilExpiry > 0;
  }

  /// Get days remaining in subscription
  int get daysRemaining {
    final difference = endDate.difference(DateTime.now());
    return difference.isNegative ? 0 : difference.inDays;
  }

  /// Get next billing date
  DateTime get nextBillingDate {
    if (billingCycle == BillingCycle.monthly) {
      return DateTime(startDate.year, startDate.month + 1, startDate.day);
    } else {
      return DateTime(startDate.year + 1, startDate.month, startDate.day);
    }
  }

  Subscription copyWith({
    String? id,
    String? userId,
    String? planId,
    SubscriptionPlan? plan,
    SubscriptionStatus? status,
    BillingCycle? billingCycle,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? cancelledAt,
    DateTime? trialEndDate,
    double? currentPrice,
    String? paymentMethodId,
    bool? autoRenew,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Subscription(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      planId: planId ?? this.planId,
      plan: plan ?? this.plan,
      status: status ?? this.status,
      billingCycle: billingCycle ?? this.billingCycle,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      trialEndDate: trialEndDate ?? this.trialEndDate,
      currentPrice: currentPrice ?? this.currentPrice,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      autoRenew: autoRenew ?? this.autoRenew,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        planId,
        plan,
        status,
        billingCycle,
        startDate,
        endDate,
        cancelledAt,
        trialEndDate,
        currentPrice,
        paymentMethodId,
        autoRenew,
        createdAt,
        updatedAt,
      ];
}
