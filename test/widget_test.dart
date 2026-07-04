import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:launchpad_alu/app.dart';
import 'package:launchpad_alu/core/providers/app_providers.dart';

void main() {
  testWidgets('App boots into splash then redirects to login without Firebase',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [firebaseReadyProvider.overrideWithValue(false)],
        child: const App(),
      ),
    );

    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
  });
}
