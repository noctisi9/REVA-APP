import 'package:cloud_firestore/cloud_firestore.dart';

/// Handles "save for later" and light-touch reactions (no free-text
/// comments — see REVA's content-safety decision to keep in-app
/// engagement to reactions/saves only, with discussion on Facebook).
class UserPrefsService {
  UserPrefsService({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _db.collection('users').doc(uid);

  Stream<Set<String>> streamSavedIds(String uid) {
    return _userDoc(uid).collection('saved').snapshots().map(
          (snap) => snap.docs.map((d) => d.id).toSet(),
        );
  }

  Future<void> toggleSaved(String uid, String contentId, bool isSaved) {
    final ref = _userDoc(uid).collection('saved').doc(contentId);
    return isSaved
        ? ref.set({'savedAt': FieldValue.serverTimestamp()})
        : ref.delete();
  }

  /// reaction is a short preset key, e.g. "resonated" | "helped" | "needed_today"
  Future<void> setReaction(String uid, String contentId, String reaction) {
    return _userDoc(uid).collection('reactions').doc(contentId).set({
      'reaction': reaction,
      'reactedAt': FieldValue.serverTimestamp(),
    });
  }
}
