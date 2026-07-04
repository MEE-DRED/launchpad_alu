/// A domain-level error that is safe to surface to the UI.
///
/// Repositories catch low-level exceptions (Firebase, network, etc.) and map
/// them to a [Failure] with a user-friendly [message].
class Failure implements Exception {
  const Failure(this.message, {this.code});

  final String message;
  final String? code;

  @override
  String toString() => 'Failure(code: $code, message: $message)';
}

/// Common failures reused across features.
class Failures {
  const Failures._();

  static const Failure network = Failure(
    'No internet connection. Please check your network and try again.',
    code: 'network',
  );

  static const Failure unknown = Failure(
    'Something went wrong. Please try again.',
    code: 'unknown',
  );

  static const Failure notAuthenticated = Failure(
    'You need to be signed in to do that.',
    code: 'unauthenticated',
  );
}
