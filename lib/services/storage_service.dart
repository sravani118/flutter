import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

/// Firebase Storage service for uploading and managing files
class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Upload a file to Firebase Storage
  Future<String> uploadFile(File file, String path) async {
    try {
      final ref = _storage.ref().child(path);
      final uploadTask = await ref.putFile(file);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
  }

  /// Upload an image file
  Future<String> uploadImage(File imageFile, String userId) async {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final path = 'uploads/$userId/$fileName';
    return uploadFile(imageFile, path);
  }

  /// Delete a file from Firebase Storage
  Future<void> deleteFile(String fileUrl) async {
    try {
      final ref = _storage.refFromURL(fileUrl);
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete file: $e');
    }
  }

  /// Get download URL for a file
  Future<String> getDownloadUrl(String path) async {
    try {
      final ref = _storage.ref().child(path);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to get download URL: $e');
    }
  }
}
