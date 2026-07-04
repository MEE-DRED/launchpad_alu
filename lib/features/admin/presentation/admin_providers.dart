import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/presentation/auth_providers.dart';
import '../../startup/data/models/startup_profile.dart';

final unverifiedStartupsProvider =
    StreamProvider<List<StartupProfile>>((ref) {
  final repo = ref.watch(startupRepositoryProvider);
  if (repo == null) return Stream.value([]);
  return repo.watchUnverifiedStartups();
});

final adminActionsProvider =
    AsyncNotifierProvider<AdminActionsController, void>(
  AdminActionsController.new,
);

class AdminActionsController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> verifyStartup(String startupId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(startupRepositoryProvider);
      if (repo == null) throw Exception('Startup repository unavailable');
      await repo.verifyStartup(startupId);
    });
  }
}
