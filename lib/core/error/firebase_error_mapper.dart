import 'package:firebase_auth/firebase_auth.dart';

import 'failure.dart';

/// Translates raw Firebase exceptions into user-friendly [Failure]s.
class FirebaseErrorMapper {
  const FirebaseErrorMapper._();

  static Failure map(Object error) {
    if (error is FirebaseAuthException) {
      return Failure(_authMessage(error.code), code: error.code);
    }
    if (error is FirebaseException) {
      if (error.code == 'unavailable' ||
          error.code == 'network-request-failed') {
        return Failures.network;
      }
      return Failure(
        error.message ?? 'A Firebase error occurred.',
        code: error.code,
      );
    }
    return Failures.unknown;
  }

  static String _authMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return 'That email address is not valid.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'weak-password':
        return 'Please choose a stronger password (at least 6 characters).';
      case 'network-request-failed':
        return 'No internet connection. Please try again.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait a moment and try again.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
