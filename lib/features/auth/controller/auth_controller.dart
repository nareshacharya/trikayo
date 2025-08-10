import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app/di/dependency_injection.dart';
import '../../../services/auth_service.dart';

/// State class for authentication
class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final bool isGuest;
  final String? error;
  final String? verificationId;
  final String? phoneNumber;
  final MockUser? user;

  const AuthState({
    required this.isLoading,
    required this.isAuthenticated,
    required this.isGuest,
    this.error,
    this.verificationId,
    this.phoneNumber,
    this.user,
  });

  factory AuthState.initial() => const AuthState(
        isLoading: false,
        isAuthenticated: false,
        isGuest: false,
      );

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    bool? isGuest,
    String? error,
    String? verificationId,
    String? phoneNumber,
    MockUser? user,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isGuest: isGuest ?? this.isGuest,
      error: error,
      verificationId: verificationId ?? this.verificationId,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      user: user ?? this.user,
    );
  }
}

/// Controller for managing authentication state and operations
class AuthController extends StateNotifier<AuthState> {
  final AuthService _authService;
  final SharedPreferences _prefs;

  AuthController(this._authService, this._prefs) : super(AuthState.initial()) {
    _loadAuthState();
  }

  /// Load authentication state from SharedPreferences
  Future<void> _loadAuthState() async {
    try {
      final isAuthenticated = _prefs.getBool('is_authenticated') ?? false;
      final isGuest = _prefs.getBool('is_guest') ?? false;
      final phoneNumber = _prefs.getString('phone_number');
      final userId = _prefs.getString('user_id');

      if (isAuthenticated && userId != null) {
        final user = MockUser(
          uid: userId,
          phoneNumber: phoneNumber,
          emailVerified: false,
        );

        state = state.copyWith(
          isAuthenticated: true,
          isGuest: isGuest,
          phoneNumber: phoneNumber,
          user: user,
        );
      }
    } catch (e) {
      // If there's an error loading state, start fresh
      state = AuthState.initial();
    }
  }

  /// Save authentication state to SharedPreferences
  Future<void> _saveAuthState() async {
    try {
      await _prefs.setBool('is_authenticated', state.isAuthenticated);
      await _prefs.setBool('is_guest', state.isGuest);
      await _prefs.setString('phone_number', state.phoneNumber ?? '');
      await _prefs.setString('user_id', state.user?.uid ?? '');
    } catch (e) {
      // Handle persistence error
      state = state.copyWith(error: 'Failed to save authentication state');
    }
  }

  /// Clear authentication state from SharedPreferences
  Future<void> _clearAuthState() async {
    try {
      await _prefs.remove('is_authenticated');
      await _prefs.remove('is_guest');
      await _prefs.remove('phone_number');
      await _prefs.remove('user_id');
    } catch (e) {
      // Handle persistence error
    }
  }

  /// Sign in with phone number
  Future<void> signInWithPhoneNumber(String phoneNumber) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _authService.signInWithPhoneNumber(phoneNumber);

      result.when(
        success: (credential) {
          state = state.copyWith(
            isLoading: false,
            verificationId:
                credential.user.uid, // Using uid as verificationId for mock
            phoneNumber: phoneNumber,
          );
        },
        failure: (error) {
          state = state.copyWith(
            isLoading: false,
            error: error.toString(),
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Verify OTP code
  Future<void> verifyOTP(String smsCode) async {
    if (state.verificationId == null) {
      state = state.copyWith(error: 'Please enter phone number first');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final result =
          await _authService.verifyOTP(state.verificationId!, smsCode);

      result.when(
        success: (credential) {
          state = state.copyWith(
            isLoading: false,
            isAuthenticated: true,
            user: credential.user,
          );
          _saveAuthState();
        },
        failure: (error) {
          state = state.copyWith(
            isLoading: false,
            error: error.toString(),
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Continue as guest
  Future<void> continueAsGuest() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Create a mock guest user
      final guestUser = MockUser(
        uid: 'guest_${DateTime.now().millisecondsSinceEpoch}',
        phoneNumber: null,
        emailVerified: false,
      );

      await Future.delayed(const Duration(milliseconds: 500)); // Simulate delay

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: guestUser,
        isGuest: true,
      );
      _saveAuthState();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Sign out
  Future<void> signOut() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _authService.signOut();

      result.when(
        success: (_) {
          state = AuthState.initial();
          _clearAuthState();
        },
        failure: (error) {
          state = state.copyWith(
            isLoading: false,
            error: error.toString(),
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Reset to initial state
  void reset() {
    state = AuthState.initial();
    _clearAuthState();
  }
}

/// Provider for AuthController
final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  final sharedPrefs = ref.watch(sharedPreferencesProvider);
  return AuthController(authService, sharedPrefs);
});
