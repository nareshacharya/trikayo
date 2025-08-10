import 'dart:async';
import '../core/result/result.dart';

// Mock user class for development
class MockUser {
  final String uid;
  final String? email;
  final String? phoneNumber;
  final bool emailVerified;

  MockUser({
    required this.uid,
    this.email,
    this.phoneNumber,
    this.emailVerified = false,
  });
}

// Mock user credential class for development
class MockUserCredential {
  final MockUser user;

  MockUserCredential({required this.user});
}

/// Interface for authentication service
abstract class AuthService {
  /// Get the current user
  MockUser? get currentUser;

  /// Sign in with phone number
  Future<Result<MockUserCredential>> signInWithPhoneNumber(String phoneNumber);

  /// Verify OTP code
  Future<Result<MockUserCredential>> verifyOTP(
      String verificationId, String smsCode);

  /// Sign out
  Future<Result<void>> signOut();

  /// Get auth state changes stream
  Stream<MockUser?> get authStateChanges;
}

/// Mock implementation of AuthService for development
class MockAuthService implements AuthService {
  MockUser? _currentUser;
  final StreamController<MockUser?> _authStateController =
      StreamController<MockUser?>.broadcast();

  @override
  MockUser? get currentUser => _currentUser;

  @override
  Future<Result<MockUserCredential>> signInWithPhoneNumber(
      String phoneNumber) async {
    try {
      // Mock implementation - simulate sending OTP
      await Future.delayed(const Duration(seconds: 1));
      return Success(MockUserCredential(
        user: MockUser(
          uid: 'mock_uid_${DateTime.now().millisecondsSinceEpoch}',
          phoneNumber: phoneNumber,
        ),
      ));
    } catch (e) {
      return Failure(Exception('Failed to send OTP: $e'));
    }
  }

  @override
  Future<Result<MockUserCredential>> verifyOTP(
      String verificationId, String smsCode) async {
    try {
      // Mock implementation - simulate OTP verification
      await Future.delayed(const Duration(seconds: 1));
      if (smsCode == '123456') {
        // Mock valid OTP
        _currentUser = MockUser(
          uid: 'mock_uid_${DateTime.now().millisecondsSinceEpoch}',
          phoneNumber: '+1234567890',
        );
        _authStateController.add(_currentUser);
        return Success(MockUserCredential(user: _currentUser!));
      } else {
        return Failure(Exception('Invalid OTP'));
      }
    } catch (e) {
      return Failure(Exception('Failed to verify OTP: $e'));
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      _currentUser = null;
      _authStateController.add(null);
      return const Success(null);
    } catch (e) {
      return Failure(Exception('Sign out failed: $e'));
    }
  }

  @override
  Stream<MockUser?> get authStateChanges => _authStateController.stream;
}
