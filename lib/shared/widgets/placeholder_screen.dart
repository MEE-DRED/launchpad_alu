import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// A temporary screen used for features that will be implemented in later
/// phases. Keeps the app navigable end-to-end during Phase 1.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({
    super.key,
    required this.title,
    required this.phase,
    this.icon = Icons.construction_outlined,
    this.showAppBar = true,
  });

  final String title;
  final String phase;
  final IconData icon;
  final bool showAppBar;

  @override
  Widget build(BuildContext context) {
    final body = Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 44, color: AppColors.accentDark),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'Planned for $phase',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );

    if (!showAppBar) return body;
    return Scaffold(appBar: AppBar(title: Text(title)), body: body);
  }
}
