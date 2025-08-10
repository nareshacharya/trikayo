# Trikayo - Meal Management & Nutrition Tracking App

A Flutter app for meal management and nutrition tracking built with modern architecture patterns.

## 🏗️ Architecture

- **Framework**: Flutter 3+ with Dart 3 (null-safe)
- **Architecture**: MVC with repositories & services
- **State Management**: Riverpod
- **Navigation**: go_router
- **Networking**: Dio with JSON serialization
- **Storage**: SharedPreferences + Hive for caching
- **Authentication**: Firebase Auth (OTP)
- **Internationalization**: intl with English as default

## 📁 Project Structure

```
lib/
├── app/                    # App-level configuration
│   ├── di/                # Dependency injection
│   ├── router/            # Navigation setup
│   └── theme/             # App theming
├── core/                  # Core utilities
│   ├── base/              # Base classes
│   ├── constants/         # App constants
│   ├── error/             # Error handling
│   ├── result/            # Result type
│   └── utils/             # Utility functions
├── data/                  # Data layer
│   ├── datasources/       # Data sources (API, local)
│   ├── dtos/              # Data transfer objects
│   ├── models/            # Data models
│   └── repositories/      # Repository implementations
├── domain/                # Domain layer
│   ├── entities/          # Business entities
│   ├── repositories/      # Repository interfaces
│   └── usecases/          # Business logic
├── features/              # Feature modules
│   ├── auth/              # Authentication
│   ├── catalog/           # Meal catalog
│   ├── checkout/          # Order checkout
│   ├── home/              # Home screen
│   ├── meal_details/      # Meal details
│   ├── paywall/           # Subscription paywall
│   ├── post_meal/         # Post meal creation
│   └── profile/           # User profile
└── services/              # External services
    ├── auth_service.dart
    ├── location_service.dart
    ├── nutrition_service.dart
    └── payment_service.dart
```

## 🚀 Features Implemented

### ✅ Foundation (Prompt 1)
- [x] Flutter app scaffold with proper folder structure
- [x] Dependencies configured (Riverpod, Dio, go_router, etc.)
- [x] AppTheme with light/dark theme support
- [x] AppRouter with navigation setup
- [x] Environment configuration (.env)
- [x] Base Controller class with error handling
- [x] Result<T> type for success/failure handling
- [x] Feature modules created (auth, catalog, meal_details, etc.)
- [x] Linting configuration (analysis_options.yaml)

### ✅ Data Models & Services (Prompt 2)
- [x] Core entities with json_serializable:
  - [x] User, Vendor, Meal, Ingredient, Order
  - [x] SubscriptionPlan, NutritionProfile, Subscription
  - [x] Macros entity for nutritional information
- [x] Repository interfaces:
  - [x] MealRepository, OrderRepository, UserRepository
- [x] NutritionService interface with methods:
  - [x] estimateFromIngredients()
  - [x] findEquivalentMeals()
  - [x] rebalanceAfterCheat()
- [x] Mock implementations for offline development
- [x] Sample meals data with nutritional information

## 🎯 Current Status

The app is now running with:
- ✅ Placeholder home screen with navigation
- ✅ Working light/dark theme toggle
- ✅ Catalog screen displaying mock meals
- ✅ Proper navigation between screens
- ✅ Mock data loading from repositories
- ✅ Error handling and loading states

## 🛠️ Development Setup

1. **Install dependencies**:
   ```bash
   flutter pub get
   ```

2. **Generate code**:
   ```bash
   flutter packages pub run build_runner build
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

## 📱 Screenshots

The app includes the following screens:
- **Home**: Welcome screen with feature navigation
- **Catalog**: Browse meals with search and filtering
- **Meal Details**: Detailed meal information
- **Auth**: Phone number verification
- **Profile**: User profile management
- **Checkout**: Order processing
- **Paywall**: Subscription plans
- **Post Meal**: Meal creation

## 🔧 Configuration

### Environment Variables
Create a `.env` file in the root directory:
```env
# API Configuration
API_BASE_URL=https://api.trikayo.com
API_TIMEOUT=30000

# Firebase Configuration
FIREBASE_API_KEY=your_firebase_api_key_here
FIREBASE_APP_ID=your_firebase_app_id_here
FIREBASE_MESSAGING_SENDER_ID=your_sender_id_here
FIREBASE_PROJECT_ID=your_project_id_here

# App Configuration
APP_NAME=Trikayo
APP_VERSION=1.0.0
ENVIRONMENT=dev
```

## 🧪 Testing

The project includes:
- Unit tests for controllers
- Widget tests for key screens
- Mock implementations for offline development

## 📦 Dependencies

Key dependencies:
- `flutter_riverpod`: State management
- `go_router`: Navigation
- `dio`: HTTP client
- `json_annotation`: JSON serialization
- `shared_preferences`: Local storage
- `hive`: Caching
- `firebase_auth`: Authentication
- `intl`: Internationalization

## 🎨 Design System

- Material 3 design
- Light/dark theme support
- Scalable text
- Large tap targets for accessibility
- Consistent color scheme and typography

## 🔄 Next Steps

1. Implement real API integration
2. Add Firebase configuration
3. Implement authentication flow
4. Add meal creation functionality
5. Implement payment processing
6. Add push notifications
7. Implement offline sync
8. Add comprehensive testing

## 📄 License

This project is part of a development exercise and follows the specified guardrails and architecture patterns.
