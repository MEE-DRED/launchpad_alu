import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/placeholder_screen.dart';

/// Placeholder opportunities screen. Browse/search/filter lands in Phase 3.
class OpportunitiesScreen extends ConsumerWidget {
  const OpportunitiesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const PlaceholderScreen(
      title: 'Opportunities',
      phase: 'Phase 3 — Opportunities & Discovery',
      icon: Icons.work_rounded,
    );
  }
}
