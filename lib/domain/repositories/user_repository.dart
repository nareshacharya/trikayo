import '../../core/result/result.dart';
import '../entities/user.dart';
import '../entities/nutrition_profile.dart';
import '../entities/subscription.dart';

/// Repository interface for user-related operations
abstract class UserRepository {
  /// Get user by ID
  Future<Result<User>> getUserById(String id);

  /// Get current user
  Future<Result<User>> getCurrentUser();

  /// Create a new user
  Future<Result<User>> createUser(User user);

  /// Update user profile
  Future<Result<User>> updateUser(User user);

  /// Delete user account
  Future<Result<void>> deleteUser(String id);

  /// Update user preferences
  Future<Result<User>> updateUserPreferences(String userId, Map<String, dynamic> preferences);

  /// Get user nutrition profile
  Future<Result<NutritionProfile>> getUserNutritionProfile(String userId);

  /// Create or update nutrition profile
  Future<Result<NutritionProfile>> saveNutritionProfile(NutritionProfile profile);

  /// Get user subscription
  Future<Result<Subscription?>> getUserSubscription(String userId);

  /// Create or update subscription
  Future<Result<Subscription>> saveSubscription(Subscription subscription);

  /// Cancel user subscription
  Future<Result<Subscription>> cancelSubscription(String userId);

  /// Get user statistics
  Future<Result<Map<String, dynamic>>> getUserStatistics(String userId);

  /// Check if user exists
  Future<Result<bool>> userExists(String id);

  /// Get user by email
  Future<Result<User>> getUserByEmail(String email);

  /// Get user by phone number
  Future<Result<User>> getUserByPhone(String phoneNumber);
}
