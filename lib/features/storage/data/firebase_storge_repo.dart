import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:instproject/core/appconfig.dart';
import 'package:instproject/features/storage/domain/storage_repo.dart';

class StorageRepoAppWrite implements StorageRepo {
  final String bucketId = bucketId1;
  final String projectId = projectId1;
  final String endpoint = appwriteEndpoint;

  
  @override
  Future<String?> uploadProfileImageMobile(
    String imagePath,
    String fileName,
  ) async {
    try {
      final url = Uri.parse('$endpoint/storage/buckets/$bucketId/files');

      final request = http.MultipartRequest('POST', url)
        ..headers['X-Appwrite-Project'] = projectId
        ..files.add(
          await http.MultipartFile.fromPath(
            'file',
            imagePath,
            filename: fileName,
          ),
        );

      final response = await request.send();
      final resBody = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        final data = jsonDecode(resBody);
        final fileId = data['\$id'];
        return '$endpoint/storage/buckets/$bucketId/files/$fileId/view?project=$projectId';
      } else {
        print(' Upload failed: $resBody');
        return null;
      }
    } catch (e) {
      print(' Error uploading image: $e');
      return null;
    }
  }

  
  Future<void> deleteFileByUrl(String fileUrl) async {
    try {
      
      final uri = Uri.parse(fileUrl);
      final segments = uri.pathSegments;
      final fileIdIndex = segments.indexOf('files') + 1;
      final fileId = segments[fileIdIndex];

      final deleteUrl = Uri.parse(
        '$endpoint/storage/buckets/$bucketId/files/$fileId',
      );

      final response = await http.delete(
        deleteUrl,
        headers: {
          'X-Appwrite-Project': projectId,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 204) {
        print('File deleted successfully');
      } else {
        print('Failed to delete file: ${response.body}');
      }
    } catch (e) {
      print('Error deleting file: $e');
    }
  }
}
