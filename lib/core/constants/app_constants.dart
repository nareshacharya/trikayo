/// Application constants
class AppConstants {
  // App Information
  static const String appName = 'Trikayo';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static const String apiBaseUrl = 'https://api.trikayo.com';
  static const int apiTimeout = 30000; // milliseconds
  
  // Storage Keys
  static const String userDataKey = 'user_data';
  static const String userPreferencesKey = 'user_preferences';
  static const String favoriteMealsKey = 'favorite_meals';
  static const String authTokenKey = 'auth_token';
  
  // Hive Box Names
  static const String userBoxName = 'user';
  static const String mealsBoxName = 'meals';
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int minPhoneLength = 10;
  static const int maxPhoneLength = 15;
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double defaultRadius = 8.0;
  static const double largeRadius = 12.0;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Error Messages
  static const String networkErrorMessage = 'Network error. Please check your connection.';
  static const String serverErrorMessage = 'Server error. Please try again later.';
  static const String unknownErrorMessage = 'An unknown error occurred.';
  static const String invalidInputMessage = 'Please check your input and try again.';
  
  // Success Messages
  static const String loginSuccessMessage = 'Successfully logged in!';
  static const String logoutSuccessMessage = 'Successfully logged out!';
  static const String saveSuccessMessage = 'Successfully saved!';
  static const String deleteSuccessMessage = 'Successfully deleted!';
}
