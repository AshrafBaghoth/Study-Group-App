import 'dart:io';
import 'package:instproject/core/rebos/appwrite_storage_api.dart';

class AppwritePostStorageRepo {
  Future<String?> uploadPostImage(String imagePath, String userId) async {
    final file = File(imagePath);
    final fileName = '${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
    return await AppwriteStorageAPI.uploadImage(file, fileName);
  }
}
