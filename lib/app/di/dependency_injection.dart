import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../services/auth_service.dart';
import '../../services/nutrition_service.dart';
import '../../services/payment_service.dart';
import '../../services/location_service.dart';
import '../../services/subscription_service.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/meal_repository.dart';
import '../../data/repositories/user_repository.dart';

// Dio instance for HTTP requests
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  dio.options.baseUrl = 'https://api.trikayo.com';
  dio.options.connectTimeout = const Duration(seconds: 30);
  dio.options.receiveTimeout = const Duration(seconds: 30);

  // Add interceptors for logging, auth, etc.
  dio.interceptors.add(LogInterceptor(
    requestBody: true,
    responseBody: true,
  ));

  return dio;
});

// SharedPreferences instance - will be initialized in main
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be initialized');
});

// Hive box providers
final userBoxProvider = Provider<Box>((ref) {
  return Hive.box('user');
});

final mealBoxProvider = Provider<Box>((ref) {
  return Hive.box('meals');
});

// Service providers
final authServiceProvider = Provider<AuthService>((ref) {
  return MockAuthService();
});

final nutritionServiceProvider = Provider<NutritionService>((ref) {
  return MockNutritionService();
});

final paymentServiceProvider = Provider<PaymentService>((ref) {
  return PaymentService();
});

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

final subscriptionServiceProvider = Provider<SubscriptionService>((ref) {
  return MockSubscriptionService();
});

// Repository providers
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authService = ref.watch(authServiceProvider);
  final sharedPrefs = ref.watch(sharedPreferencesProvider);
  return AuthRepository(authService, sharedPrefs);
});

final mealRepositoryProvider = Provider<MealRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final mealBox = ref.watch(mealBoxProvider);
  return MealRepository(dio, mealBox);
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final userBox = ref.watch(userBoxProvider);
  return UserRepository(userBox);
});

// Initialize dependencies
Future<void> initializeDependencies() async {
  // Initialize SharedPreferences
  // Note: This is handled in main.dart now

  // Initialize Hive boxes
  await Hive.openBox('user');
  await Hive.openBox('meals');

  // Override the SharedPreferences provider
  // Note: In a real app, you might want to use a more sophisticated DI approach
  // This is a simplified version for demonstration
}
