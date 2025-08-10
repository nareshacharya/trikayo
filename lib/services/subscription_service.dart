import '../domain/entities/subscription_plan.dart';

abstract class SubscriptionService {
  Future<PlanTier?> getUserTier(String userId);
  Future<void> updateUserTier(String userId, PlanTier tier);
  Future<bool> hasFeature(String userId, String feature);
  Future<List<String>> getAvailableFeatures(String userId);
}

class MockSubscriptionService implements SubscriptionService {
  // Mock user tiers for PoC - in real app this would come from backend
  static final Map<String, PlanTier> _userTiers = {
    'user1': PlanTier.basic,
    'user2': PlanTier.plus,
    'user3': PlanTier.pro,
    // Default tier for new users
    'default': PlanTier.basic,
  };

  @override
  Future<PlanTier?> getUserTier(String userId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 100));
    return _userTiers[userId] ?? _userTiers['default'];
  }

  @override
  Future<void> updateUserTier(String userId, PlanTier tier) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));
    _userTiers[userId] = tier;
  }

  @override
  Future<bool> hasFeature(String userId, String feature) async {
    final tier = await getUserTier(userId);
    if (tier == null) return false;

    switch (feature) {
      case 'macros':
        return tier == PlanTier.plus || tier == PlanTier.pro;
      case 'meal_planning':
        return tier == PlanTier.pro;
      case 'ai_picks':
        return tier == PlanTier.pro;
      case 'priority_support':
        return tier == PlanTier.pro;
      default:
        return false;
    }
  }

  @override
  Future<List<String>> getAvailableFeatures(String userId) async {
    final tier = await getUserTier(userId);
    if (tier == null) return [];

    final features = <String>['basic_meals', 'calories'];

    switch (tier) {
      case PlanTier.plus:
        features.addAll(['macros', 'nutrition_tracking']);
        break;
      case PlanTier.pro:
        features.addAll([
          'macros',
          'nutrition_tracking',
          'meal_planning',
          'ai_picks',
          'priority_support',
        ]);
        break;
      case PlanTier.basic:
        break;
    }

    return features;
  }

  // Debug method to change user tier instantly for PoC
  static void setDebugTier(String userId, PlanTier tier) {
    _userTiers[userId] = tier;
  }

  // Debug method to get all user tiers
  static Map<String, PlanTier> getDebugTiers() {
    return Map.from(_userTiers);
  }
}
