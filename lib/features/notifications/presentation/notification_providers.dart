import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/repository_providers.dart';
import '../../profile/presentation/profile_providers.dart';
import '../data/models/app_notification.dart';

final notificationsProvider = StreamProvider<List<AppNotification>>((ref) {
  final repo = ref.watch(notificationRepositoryProvider);
  final uid = ref.watch(authStateProvider).value?.uid;
  if (repo == null || uid == null) return Stream.value([]);
  return repo.watchNotifications(uid);
});

final unreadNotificationCountProvider = Provider<int>((ref) {
  final notifications = ref.watch(notificationsProvider).value ?? [];
  return notifications.where((n) => !n.read).length;
});

final notificationActionsProvider =
    AsyncNotifierProvider<NotificationActionsController, void>(
  NotificationActionsController.new,
);

class NotificationActionsController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> markAsRead(String id) async {
    final repo = ref.read(notificationRepositoryProvider);
    if (repo == null) return;
    await repo.markAsRead(id);
  }

  Future<void> markAllAsRead() async {
    final repo = ref.read(notificationRepositoryProvider);
    final uid = ref.read(authStateProvider).value?.uid;
    if (repo == null || uid == null) return;
    await repo.markAllAsRead(uid);
  }
}
