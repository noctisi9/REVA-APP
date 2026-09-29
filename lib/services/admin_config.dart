/// Client-side admin check, used only to show/hide the upload UI.
///
/// This is NOT the real security boundary — Firestore/Storage Security
/// Rules enforce the actual write restriction server-side. Even if this
/// constant were somehow read out of the compiled app, it grants nothing
/// by itself: writes still require authenticating as this exact UID.
///
/// Replace with your real Firebase Auth UID (Firebase Console > Authentication).
class AdminConfig {
  static const String adminUid = 'REPLACE_WITH_YOUR_FIREBASE_UID';

  static bool isAdmin(String? uid) => uid != null && uid == adminUid;
}
