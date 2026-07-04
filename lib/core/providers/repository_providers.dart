import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/applications/data/application_repository.dart';
import '../../features/bookmarks/data/bookmark_repository.dart';
import '../../features/notifications/data/notification_repository.dart';
import '../../features/opportunities/data/opportunity_repository.dart';
import 'app_providers.dart';

final opportunityRepositoryProvider = Provider<OpportunityRepository?>((ref) {
  final firebaseReady = ref.watch(firebaseReadyProvider);
  if (!firebaseReady) return null;
  return OpportunityRepository();
});

final applicationRepositoryProvider = Provider<ApplicationRepository?>((ref) {
  final firebaseReady = ref.watch(firebaseReadyProvider);
  if (!firebaseReady) return null;
  return ApplicationRepository();
});

final bookmarkRepositoryProvider = Provider<BookmarkRepository?>((ref) {
  final firebaseReady = ref.watch(firebaseReadyProvider);
  if (!firebaseReady) return null;
  return BookmarkRepository();
});

final notificationRepositoryProvider =
    Provider<NotificationRepository?>((ref) {
  final firebaseReady = ref.watch(firebaseReadyProvider);
  if (!firebaseReady) return null;
  return NotificationRepository();
});
