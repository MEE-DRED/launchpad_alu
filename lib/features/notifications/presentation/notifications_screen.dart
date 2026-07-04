import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_empty_state.dart';
import '../../../shared/widgets/app_loading.dart';
import 'notification_providers.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsProvider);
    final dateFormat = DateFormat('MMM d · HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () =>
                ref.read(notificationActionsProvider.notifier).markAllAsRead(),
            child: const Text('Mark all read'),
          ),
        ],
      ),
      body: notificationsAsync.when(
        loading: () => const AppLoading(label: 'Loading notifications...'),
        error: (_, _) => const AppEmptyState(
          title: 'Could not load notifications',
          icon: Icons.error_outline,
        ),
        data: (items) {
          if (items.isEmpty) {
            return const AppEmptyState(
              title: 'No notifications',
              message: 'Updates about applications and opportunities appear here.',
              icon: Icons.notifications_none_outlined,
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final notification = items[index];
              return Material(
                color: notification.read
                    ? AppColors.surface
                    : AppColors.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(14),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(color: AppColors.border),
                  ),
                  onTap: () {
                    ref
                        .read(notificationActionsProvider.notifier)
                        .markAsRead(notification.id);
                    if (notification.relatedId != null) {
                      context.push(
                        AppRoutes.applicationDetail(notification.relatedId!),
                      );
                    }
                  },
                  leading: Icon(
                    Icons.notifications_active_outlined,
                    color: notification.read
                        ? AppColors.textTertiary
                        : AppColors.primary,
                  ),
                  title: Text(
                    notification.title,
                    style: TextStyle(
                      fontWeight: notification.read
                          ? FontWeight.w500
                          : FontWeight.w700,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(notification.body),
                      if (notification.createdAt != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          dateFormat.format(notification.createdAt!),
                          style: TextStyle(
                            color: AppColors.textTertiary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
