import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/content_item.dart';

/// All Firestore access for content lives here — screens never talk to
/// Firestore directly. Reads are open to any signed-in user; writes are
/// gated by Firestore Security Rules to the admin UID (see firebase/firestore.rules).
class ContentService {
  ContentService({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _contentRef =>
      _db.collection('content_items');

  Stream<List<ContentItem>> streamByCategory(ContentCategory category) {
    return _contentRef
        .where('category', isEqualTo: category.name)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(ContentItem.fromFirestore).toList());
  }

  /// Enforcement happens server-side in Security Rules — this call will
  /// fail for any non-admin UID regardless of what the client sends.
  Future<void> addContent(ContentItem item) {
    return _contentRef.add(item.toFirestore());
  }

  Future<void> deleteContent(String contentId) {
    return _contentRef.doc(contentId).delete();
  }

  Future<void> reportContent({
    required String contentId,
    required String reporterUid,
    required String reason,
  }) {
    return _db.collection('reports').add({
      'contentId': contentId,
      'reporterUid': reporterUid,
      'reason': reason,
      'createdAt': FieldValue.serverTimestamp(),
      'status': 'open',
    });
  }
}
