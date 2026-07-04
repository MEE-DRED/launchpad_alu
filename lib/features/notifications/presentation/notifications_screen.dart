import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/placeholder_screen.dart';

/// Placeholder notifications screen. In-app alerts land in Phase 4.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const PlaceholderScreen(
      title: 'Notifications',
      phase: 'Phase 4 — Applications & Engagement',
      icon: Icons.notifications_rounded,
    );
  }
}
