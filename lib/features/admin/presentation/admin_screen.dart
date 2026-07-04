import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/app_empty_state.dart';
import '../../../shared/widgets/app_loading.dart';
import '../../../shared/widgets/app_snackbar.dart';
import 'admin_providers.dart';

class AdminScreen extends ConsumerWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startupsAsync = ref.watch(unverifiedStartupsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Admin — Verify startups')),
      body: startupsAsync.when(
        loading: () => const AppLoading(label: 'Loading startups...'),
        error: (_, _) => const AppEmptyState(
          title: 'Could not load startups',
          icon: Icons.error_outline,
        ),
        data: (startups) {
          if (startups.isEmpty) {
            return const AppEmptyState(
              title: 'All startups verified',
              message: 'No pending verifications right now.',
              icon: Icons.verified_outlined,
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: startups.length,
            itemBuilder: (context, index) {
              final startup = startups[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: startup.logoUrl != null
                        ? CachedNetworkImageProvider(startup.logoUrl!)
                        : null,
                    child: startup.logoUrl == null
                        ? const Icon(Icons.business)
                        : null,
                  ),
                  title: Text(
                    startup.name,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text('${startup.industry} · ${startup.founderName}'),
                  trailing: ElevatedButton(
                    onPressed: () async {
                      await ref
                          .read(adminActionsProvider.notifier)
                          .verifyStartup(startup.id);
                      if (context.mounted) {
                        AppSnackbar.success(context, '${startup.name} verified.');
                      }
                    },
                    child: const Text('Verify'),
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
