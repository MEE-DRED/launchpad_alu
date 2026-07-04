import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/error/firebase_error_mapper.dart';
import 'models/opportunity.dart';

/// CRUD and query operations for opportunity documents.
class OpportunityRepository {
  OpportunityRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _opportunities =>
      _firestore.collection(AppConstants.opportunitiesCollection);

  Stream<List<Opportunity>> watchOpportunities({OpportunityFilters? filters}) {
    return _opportunities
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      var items = snapshot.docs
          .map(Opportunity.fromFirestore)
          .where((item) => !item.isExpired)
          .toList();

      final f = filters ?? const OpportunityFilters();
      items = _applyFilters(items, f);
      return _sort(items, f.sort);
    });
  }

  Stream<List<Opportunity>> watchOpportunitiesByStartup(String startupId) {
    return _opportunities
        .where('startupId', isEqualTo: startupId)
        .snapshots()
        .map((snapshot) {
      final items = snapshot.docs.map(Opportunity.fromFirestore).toList();
      items.sort(
        (a, b) => (b.createdAt ?? DateTime(1970))
            .compareTo(a.createdAt ?? DateTime(1970)),
      );
      return items;
    });
  }

  Stream<List<Opportunity>> watchStartupOpportunities(String startupId) {
    return watchOpportunitiesByStartup(startupId);
  }

  Stream<Opportunity?> watchOpportunity(String id) {
    return _opportunities.doc(id).snapshots().map((doc) {
      if (!doc.exists) return null;
      return Opportunity.fromFirestore(doc);
    });
  }

  Future<Opportunity?> getOpportunity(String id) async {
    try {
      final doc = await _opportunities.doc(id).get();
      if (!doc.exists) return null;
      return Opportunity.fromFirestore(doc);
    } catch (error) {
      throw FirebaseErrorMapper.map(error);
    }
  }

  Future<String> createOpportunity(Opportunity opportunity) async {
    try {
      final docRef = _opportunities.doc();
      await docRef.set({
        ...opportunity.toFirestore(),
        'createdAt': FieldValue.serverTimestamp(),
      });
      return docRef.id;
    } catch (error) {
      throw FirebaseErrorMapper.map(error);
    }
  }

  Future<void> updateOpportunity(Opportunity opportunity) async {
    try {
      await _opportunities
          .doc(opportunity.id)
          .set(opportunity.toFirestore(), SetOptions(merge: true));
    } catch (error) {
      throw FirebaseErrorMapper.map(error);
    }
  }

  Future<void> deleteOpportunity(String id) async {
    try {
      await _opportunities.doc(id).delete();
    } catch (error) {
      throw FirebaseErrorMapper.map(error);
    }
  }

  List<Opportunity> _applyFilters(
    List<Opportunity> items,
    OpportunityFilters filters,
  ) {
    final query = filters.searchQuery.trim().toLowerCase();

    return items.where((item) {
      if (query.isNotEmpty) {
        final haystack =
            '${item.title} ${item.description} ${item.startupName} ${item.skillsRequired.join(' ')}'
                .toLowerCase();
        if (!haystack.contains(query)) return false;
      }
      if (filters.industry != null &&
          item.industry?.toLowerCase() != filters.industry!.toLowerCase()) {
        return false;
      }
      if (filters.skill != null &&
          !item.skillsRequired
              .any((s) => s.toLowerCase().contains(filters.skill!.toLowerCase()))) {
        return false;
      }
      if (filters.duration != null &&
          item.duration.toLowerCase() != filters.duration!.toLowerCase()) {
        return false;
      }
      if (filters.internshipType != null &&
          item.internshipType != filters.internshipType) {
        return false;
      }
      if (filters.workMode != null && item.workMode != filters.workMode) {
        return false;
      }
      if (filters.recentOnly) {
        final cutoff = DateTime.now().subtract(const Duration(days: 7));
        if (item.createdAt == null || item.createdAt!.isBefore(cutoff)) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  List<Opportunity> _sort(List<Opportunity> items, OpportunitySort sort) {
    final sorted = [...items];
    switch (sort) {
      case OpportunitySort.newest:
        sorted.sort((a, b) =>
            (b.createdAt ?? DateTime(1970)).compareTo(a.createdAt ?? DateTime(1970)));
      case OpportunitySort.deadline:
        sorted.sort((a, b) => a.deadline.compareTo(b.deadline));
    }
    return sorted;
  }
}
