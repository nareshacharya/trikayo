import 'package:shared_preferences/shared_preferences.dart';

import '../../services/auth_service.dart';
import '../../core/result/result.dart';

/// Repository for authentication-related data operations
class AuthRepository {
  final AuthService _authService;
  final SharedPreferences _prefs;

  AuthRepository(this._authService, this._prefs);

  /// Get the current user
  MockUser? get currentUser => _authService.currentUser;

  /// Sign in with phone number
  Future<Result<MockUserCredential>> signInWithPhoneNumber(
      String phoneNumber) async {
    return await _authService.signInWithPhoneNumber(phoneNumber);
  }

  /// Verify OTP code
  Future<Result<MockUserCredential>> verifyOTP(
      String verificationId, String smsCode) async {
    return await _authService.verifyOTP(verificationId, smsCode);
  }

  /// Sign out
  Future<Result<void>> signOut() async {
    // Clear local storage
    await _prefs.clear();
    return await _authService.signOut();
  }

  /// Get auth state changes stream
  Stream<MockUser?> get authStateChanges => _authService.authStateChanges;

  /// Save user data to local storage
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _prefs.setString('user_data', userData.toString());
  }

  /// Get user data from local storage
  Map<String, dynamic>? getUserData() {
    final userDataString = _prefs.getString('user_data');
    if (userDataString != null) {
      // Parse the string back to Map (simplified implementation)
      return {'user_data': userDataString};
    }
    return null;
  }

  /// Check if user is logged in
  bool get isLoggedIn => currentUser != null;

  /// Get user ID
  String? get userId => currentUser?.uid;
}
