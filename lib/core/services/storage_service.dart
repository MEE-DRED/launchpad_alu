import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/error/firebase_error_mapper.dart';

/// Uploads files to Firebase Cloud Storage and returns download URLs.
class StorageService {
  StorageService({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance;

  final FirebaseStorage _storage;

  Future<String> uploadXFile({
    required XFile file,
    required String path,
    String? contentType,
  }) async {
    try {
      final ref = _storage.ref().child(path);
      final bytes = await file.readAsBytes();
      await ref.putData(
        Uint8List.fromList(bytes),
        SettableMetadata(contentType: contentType),
      );
      return ref.getDownloadURL();
    } catch (error) {
      throw FirebaseErrorMapper.map(error);
    }
  }

  Future<String> uploadBytes({
    required List<int> bytes,
    required String path,
    String? contentType,
  }) async {
    try {
      final ref = _storage.ref().child(path);
      await ref.putData(
        Uint8List.fromList(bytes),
        SettableMetadata(contentType: contentType),
      );
      return ref.getDownloadURL();
    } catch (error) {
      throw FirebaseErrorMapper.map(error);
    }
  }
}
