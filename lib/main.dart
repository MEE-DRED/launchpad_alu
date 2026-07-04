import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'bootstrap.dart';
import 'core/providers/app_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final result = await bootstrap();

  runApp(
    ProviderScope(
      overrides: [
        firebaseReadyProvider.overrideWithValue(result.firebaseReady),
      ],
      child: const App(),
    ),
  );
}
