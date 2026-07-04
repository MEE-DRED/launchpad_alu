import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/error/firebase_error_mapper.dart';

/// Wraps [FirebaseAuth] and exposes a clean, testable API for the app.
///
/// All low-level Firebase exceptions are mapped to user-friendly [Failure]s so
/// the presentation layer never has to reason about Firebase error codes.
class AuthRepository {
  AuthRepository({FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  /// Emits the current [User] whenever the auth state changes. Drives session
  /// persistence and auto-login.
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<User> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return credential.user!;
    } catch (error) {
      throw FirebaseErrorMapper.map(error);
    }
  }

  Future<User> register({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return credential.user!;
    } catch (error) {
      throw FirebaseErrorMapper.map(error);
    }
  }

  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } catch (error) {
      throw FirebaseErrorMapper.map(error);
    }
  }

  Future<void> signOut() => _auth.signOut();
}
