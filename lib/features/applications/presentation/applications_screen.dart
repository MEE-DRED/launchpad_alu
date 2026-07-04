import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/placeholder_screen.dart';

/// Placeholder applications screen. Apply/track lands in Phase 4.
class ApplicationsScreen extends ConsumerWidget {
  const ApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const PlaceholderScreen(
      title: 'Applications',
      phase: 'Phase 4 — Applications & Engagement',
      icon: Icons.assignment_rounded,
    );
  }
}
