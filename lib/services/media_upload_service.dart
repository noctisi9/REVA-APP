import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

/// Uploads admin-supplied media (images/video) to Firebase Storage.
/// Write access is restricted to the admin UID by Storage Security
/// Rules (see firebase/storage.rules) — this service does not itself
/// enforce that, the rules do.
class MediaUploadService {
  MediaUploadService({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance;

  final FirebaseStorage _storage;

  Future<String> uploadContentFile(File file, String fileName) async {
    final ref = _storage.ref().child('content/$fileName');
    final task = await ref.putFile(file);
    return task.ref.getDownloadURL();
  }
}
