import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Whether Firebase initialised successfully at startup.
///
/// Overridden in `main()` with the real bootstrap result. Features guard
/// against running before Firebase is configured by watching this.
final firebaseReadyProvider = Provider<bool>((ref) => false);
