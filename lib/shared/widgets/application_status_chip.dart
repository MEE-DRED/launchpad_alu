import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../features/applications/data/models/application.dart';

class ApplicationStatusChip extends StatelessWidget {
  const ApplicationStatusChip({super.key, required this.status});

  final ApplicationStatus status;

  @override
  Widget build(BuildContext context) {
    final (color, bg) = _colors(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }

  (Color, Color) _colors(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.pending:
        return (AppColors.warning, AppColors.warning.withValues(alpha: 0.12));
      case ApplicationStatus.reviewed:
        return (AppColors.info, AppColors.info.withValues(alpha: 0.12));
      case ApplicationStatus.shortlisted:
        return (AppColors.primary, AppColors.primary.withValues(alpha: 0.12));
      case ApplicationStatus.accepted:
        return (AppColors.success, AppColors.success.withValues(alpha: 0.12));
      case ApplicationStatus.rejected:
        return (AppColors.error, AppColors.error.withValues(alpha: 0.12));
    }
  }
}

class ApplicationTimeline extends StatelessWidget {
  const ApplicationTimeline({super.key, required this.status});

  final ApplicationStatus status;

  static const _steps = [
    ApplicationStatus.pending,
    ApplicationStatus.reviewed,
    ApplicationStatus.shortlisted,
    ApplicationStatus.accepted,
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = _steps.indexOf(status);
    final isRejected = status == ApplicationStatus.rejected;

    return Column(
      children: List.generate(_steps.length, (index) {
        final step = _steps[index];
        final isComplete =
            !isRejected && currentIndex >= index && currentIndex != -1;
        final isActive = !isRejected && currentIndex == index;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isComplete
                        ? AppColors.primary
                        : AppColors.surfaceVariant,
                    border: isActive
                        ? Border.all(color: AppColors.primary, width: 2)
                        : null,
                  ),
                  child: isComplete
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
                if (index < _steps.length - 1)
                  Container(
                    width: 2,
                    height: 28,
                    color: isComplete
                        ? AppColors.primary
                        : AppColors.border,
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  step.label,
                  style: TextStyle(
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    color: isComplete || isActive
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
