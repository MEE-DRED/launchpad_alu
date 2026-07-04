import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/error/firebase_error_mapper.dart';

/// Bookmark persistence for saved opportunities.
class BookmarkRepository {
  BookmarkRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _bookmarks =>
      _firestore.collection(AppConstants.bookmarksCollection);

  Stream<Set<String>> watchBookmarkedOpportunityIds(String userId) {
    return _bookmarks
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => doc.data()['opportunityId'] as String? ?? '')
            .where((id) => id.isNotEmpty)
            .toSet());
  }

  Future<bool> isBookmarked({
    required String userId,
    required String opportunityId,
  }) async {
    try {
      final snapshot = await _bookmarks
          .where('userId', isEqualTo: userId)
          .where('opportunityId', isEqualTo: opportunityId)
          .limit(1)
          .get();
      return snapshot.docs.isNotEmpty;
    } catch (error) {
      throw FirebaseErrorMapper.map(error);
    }
  }

  Future<void> toggleBookmark({
    required String userId,
    required String opportunityId,
  }) async {
    try {
      final snapshot = await _bookmarks
          .where('userId', isEqualTo: userId)
          .where('opportunityId', isEqualTo: opportunityId)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        await snapshot.docs.first.reference.delete();
        return;
      }

      await _bookmarks.add({
        'userId': userId,
        'opportunityId': opportunityId,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (error) {
      throw FirebaseErrorMapper.map(error);
    }
  }
}
