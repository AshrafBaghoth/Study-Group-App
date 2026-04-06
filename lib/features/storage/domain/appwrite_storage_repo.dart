import 'dart:io';
import 'package:instproject/core/rebos/appwrite_storage_api.dart';
import 'package:instproject/features/storage/domain/storage_repo.dart';

class AppwriteStorageRepo implements StorageRepo {
  @override
  Future<String?> uploadProfileImageMobile(String imagePath, String uid) async {
    final file = File(imagePath);
    final fileName = '${uid}_profile.jpg';
    return await AppwriteStorageAPI.uploadImage(file, fileName);
  }

  
  Future<void> deleteFileByUrl(String fileUrl) async {
    try {
      await AppwriteStorageAPI.deleteFileByUrl(fileUrl);
    } catch (e) {
      throw Exception('Failed to delete file: $e');
    }
  }

  
  Future<String?> uploadPostImage(String imagePath, String postId) async {
    final file = File(imagePath);
    final fileName = '${postId}_post.jpg';
    return await AppwriteStorageAPI.uploadImage(file, fileName);
  }
}
