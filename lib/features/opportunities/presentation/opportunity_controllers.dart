import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/failure.dart';
import '../../../core/providers/repository_providers.dart';
import '../../profile/presentation/profile_providers.dart';
import '../data/models/opportunity.dart';
import 'opportunity_providers.dart';

class OpportunityFormController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<String?> save({
    Opportunity? existing,
    required String title,
    required String description,
    required List<String> skillsRequired,
    required String duration,
    required InternshipType internshipType,
    required WorkMode workMode,
    required DateTime deadline,
    required int openings,
    required String responsibilities,
    required String benefits,
  }) async {
    state = const AsyncLoading();
    late String? resultId;
    state = await AsyncValue.guard(() async {
      final repo = ref.read(opportunityRepositoryProvider);
      final startup = ref.read(currentStartupProvider).value;
      final uid = ref.read(authStateProvider).value?.uid;
      if (repo == null || startup == null || uid == null) {
        throw Failures.notAuthenticated;
      }

      final opportunity = Opportunity(
        id: existing?.id ?? '',
        startupId: startup.id,
        startupName: startup.name,
        title: title,
        description: description,
        skillsRequired: skillsRequired,
        duration: duration,
        internshipType: internshipType,
        workMode: workMode,
        deadline: deadline,
        openings: openings,
        responsibilities: responsibilities,
        benefits: benefits,
        industry: startup.industry,
        createdAt: existing?.createdAt,
      );

      if (existing == null) {
        resultId = await repo.createOpportunity(opportunity);
      } else {
        await repo.updateOpportunity(opportunity);
        resultId = existing.id;
      }
    });
    return state.hasError ? null : resultId;
  }

  Future<void> delete(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(opportunityRepositoryProvider);
      if (repo == null) throw Failures.network;
      await repo.deleteOpportunity(id);
    });
  }
}

final opportunityFormControllerProvider =
    AsyncNotifierProvider<OpportunityFormController, void>(
  OpportunityFormController.new,
);
