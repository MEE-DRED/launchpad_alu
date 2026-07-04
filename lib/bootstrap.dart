import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import 'firebase_options.dart';

/// Result of attempting to initialise Firebase at startup.
class BootstrapResult {
  const BootstrapResult({required this.firebaseReady, this.error});

  final bool firebaseReady;
  final Object? error;
}

/// Initialises Firebase using values from [DefaultFirebaseOptions].
Future<BootstrapResult> bootstrap() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    return const BootstrapResult(firebaseReady: true);
  } catch (error, stack) {
    debugPrint('Firebase initialisation failed: $error\n$stack');
    return BootstrapResult(firebaseReady: false, error: error);
  }
}
