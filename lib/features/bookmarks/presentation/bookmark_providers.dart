import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/failure.dart';
import '../../../core/providers/repository_providers.dart';
import '../../profile/presentation/profile_providers.dart';

final bookmarkedIdsProvider = StreamProvider<Set<String>>((ref) {
  final repo = ref.watch(bookmarkRepositoryProvider);
  final uid = ref.watch(authStateProvider).value?.uid;
  if (repo == null || uid == null) return Stream.value({});
  return repo.watchBookmarkedOpportunityIds(uid);
});

final bookmarkToggleProvider =
    AsyncNotifierProvider<BookmarkToggleController, void>(
  BookmarkToggleController.new,
);

class BookmarkToggleController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> toggle(String opportunityId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(bookmarkRepositoryProvider);
      final uid = ref.read(authStateProvider).value?.uid;
      if (repo == null || uid == null) throw Failures.notAuthenticated;
      await repo.toggleBookmark(
        userId: uid,
        opportunityId: opportunityId,
      );
    });
  }
}
