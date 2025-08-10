import 'package:firebase_auth/firebase_auth.dart';

import '../core/result/result.dart';

/// Interface for authentication service
abstract class AuthService {
  /// Get the current user
  User? get currentUser;

  /// Sign in with phone number
  Future<Result<UserCredential>> signInWithPhoneNumber(String phoneNumber);

  /// Verify OTP code
  Future<Result<UserCredential>> verifyOTP(String verificationId, String smsCode);

  /// Sign out
  Future<Result<void>> signOut();

  /// Get auth state changes stream
  Stream<User?> get authStateChanges;
}

/// Firebase implementation of AuthService
class FirebaseAuthService implements AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  User? get currentUser => _auth.currentUser;

  @override
  Future<Result<UserCredential>> signInWithPhoneNumber(String phoneNumber) async {
    try {
      final result = await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification if the phone number is instantly verified
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          throw Exception('Verification failed: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          // Store verificationId for later use
          _verificationId = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
      
      // This will throw an exception if verification fails
      return const Failure(Exception('Phone verification not completed'));
    } catch (e) {
      return Failure(Exception('Sign in failed: $e'));
    }
  }

  @override
  Future<Result<UserCredential>> verifyOTP(String verificationId, String smsCode) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      
      final userCredential = await _auth.signInWithCredential(credential);
      return Success(userCredential);
    } catch (e) {
      return Failure(Exception('OTP verification failed: $e'));
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await _auth.signOut();
      return const Success(null);
    } catch (e) {
      return Failure(Exception('Sign out failed: $e'));
    }
  }

  @override
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  String? _verificationId;
}
