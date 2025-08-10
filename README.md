# Trikayo - Meal Management & Nutrition Tracking App

A Flutter app for meal management and nutrition tracking built with modern architecture patterns and best practices.

## 🚀 Features

- **Authentication**: Phone number verification with Firebase Auth
- **Meal Catalog**: Browse and search meals
- **Meal Details**: View detailed meal information and nutrition
- **Post Meals**: Create and share meals
- **Checkout**: Payment processing and order management
- **Profile**: User profile and preferences management
- **Paywall**: Premium features and subscriptions
- **Theme Support**: Light and dark theme with accessibility features

## 🏗️ Architecture

This project follows the **MVC (Model-View-Controller)** architecture with repositories and services:

- **Views**: Flutter widgets (UI layer)
- **Controllers**: Business logic and state management using Riverpod
- **Models**: Data classes and entities
- **Repositories**: Data access layer
- **Services**: External service integrations

### Project Structure

```
lib/
├── app/                    # App configuration
│   ├── di/                # Dependency injection
│   ├── router/            # Navigation routing
│   └── theme/             # App theming
├── core/                  # Core utilities
│   ├── base/              # Base classes
│   ├── constants/         # App constants
│   ├── error/             # Error handling
│   ├── result/            # Result type
│   └── utils/             # Utility functions
├── data/                  # Data layer
│   ├── datasources/       # Data sources
│   ├── dtos/              # Data transfer objects
│   ├── models/            # Data models
│   └── repositories/      # Repository implementations
├── domain/                # Domain layer (optional)
│   ├── entities/          # Business entities
│   ├── repositories/      # Repository interfaces
│   └── usecases/          # Use cases
├── features/              # Feature modules
│   ├── auth/              # Authentication feature
│   ├── catalog/           # Meal catalog feature
│   ├── checkout/          # Checkout feature
│   ├── home/              # Home screen feature
│   ├── meal_details/      # Meal details feature
│   ├── paywall/           # Premium features
│   ├── post_meal/         # Post meal feature
│   └── profile/           # User profile feature
└── services/              # External services
    ├── auth_service.dart
    ├── location_service.dart
    ├── nutrition_service.dart
    └── payment_service.dart
```

## 🛠️ Tech Stack

- **Framework**: Flutter 3+ with Dart 3 (null-safe)
- **State Management**: Riverpod
- **Navigation**: go_router
- **Networking**: Dio with JSON serialization
- **Storage**: SharedPreferences + Hive for caching
- **Authentication**: Firebase Auth (OTP)
- **Internationalization**: intl package
- **Testing**: Unit tests + Widget tests

## 📱 Flavors

The app supports two flavors:

- **dev**: Development environment with debug features
- **prod**: Production environment

## 🚀 Getting Started

### Prerequisites

- Flutter 3.0 or higher
- Dart 3.0 or higher
- Android Studio / VS Code
- Firebase project setup

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd trikayo
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Setup environment variables**
   - Copy `.env.example` to `.env`
   - Fill in your Firebase configuration

4. **Run the app**
   ```bash
   # Development flavor
   flutter run --flavor dev
   
   # Production flavor
   flutter run --flavor prod
   ```

### Build Commands

```bash
# Build APK for development
flutter build apk --flavor dev

# Build APK for production
flutter build apk --flavor prod

# Build iOS for development
flutter build ios --flavor dev

# Build iOS for production
flutter build ios --flavor prod
```

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run widget tests
flutter test test/widget_test.dart

# Run with coverage
flutter test --coverage
```

## 📦 Dependencies

### Core Dependencies
- `flutter_riverpod`: State management
- `go_router`: Navigation
- `dio`: HTTP client
- `json_annotation`: JSON serialization
- `shared_preferences`: Light storage
- `hive`: Local database
- `intl`: Internationalization
- `equatable`: Value equality
- `firebase_core`: Firebase core
- `firebase_auth`: Firebase authentication
- `flutter_dotenv`: Environment variables

### Development Dependencies
- `build_runner`: Code generation
- `json_serializable`: JSON code generation
- `hive_generator`: Hive code generation
- `flutter_lints`: Linting rules
- `mockito`: Testing mocks

## 🎨 Theming

The app supports both light and dark themes with:
- Scalable text sizes
- Large tap targets for accessibility
- Material 3 design system
- Custom color schemes

## 🔧 Configuration

### Environment Variables
Create a `.env` file in the root directory:

```env
# API Configuration
API_BASE_URL=https://api.trikayo.com
API_TIMEOUT=30000

# Firebase Configuration
FIREBASE_API_KEY=your_firebase_api_key
FIREBASE_APP_ID=your_firebase_app_id
FIREBASE_MESSAGING_SENDER_ID=your_sender_id
FIREBASE_PROJECT_ID=your_project_id

# App Configuration
APP_NAME=Trikayo
APP_VERSION=1.0.0
ENVIRONMENT=dev
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📞 Support

For support, email support@trikayo.com or create an issue in the repository.
