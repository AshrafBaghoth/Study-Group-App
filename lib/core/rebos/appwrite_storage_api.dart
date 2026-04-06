import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:instproject/core/appconfig.dart';


class AppwriteStorageAPI {
  
  static Future<String?> uploadImage(File file, String fileName) async {
    try {
      final url = Uri.parse(
        '$appwriteEndpoint/storage/buckets/$bucketId1/files',
      );

      final request = http.MultipartRequest('POST', url)
        ..headers['X-Appwrite-Project'] = projectId1
        ..headers['X-Appwrite-Key'] = apiKey
        ..fields['fileId'] = 'unique()'
        ..files.add(
          await http.MultipartFile.fromPath(
            'file',
            file.path,
            filename: fileName,
          ),
        );

      final response = await request.send();
      final resBody = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        final data = jsonDecode(resBody);
        final fileId = data['\$id'];
        print('Uploaded file ID: $fileId');
        return getFileUrl(fileId);
      } else {
        print(' Upload failed: ${response.statusCode} - $resBody');
        return null;
      }
    } catch (e) {
      print('Exception during upload: $e');
      return null;
    }
  }

  
  static Future<void> deleteFileByUrl(String fileUrl) async {
    try {
      final fileId = extractFileIdFromUrl(fileUrl);

      final url = Uri.parse(
        '$appwriteEndpoint/storage/buckets/$bucketId1/files/$fileId',
      );

      final response = await http.delete(
        url,
        headers: {'X-Appwrite-Project': projectId1, 'X-Appwrite-Key': apiKey},
      );

      if (response.statusCode == 204) {
        print(' File deleted successfully.');
      } else {
        print(
          ' Failed to delete file: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print(' Exception during delete: $e');
    }
  }

  
  static String getFileUrl(String fileId) {
    return '$appwriteEndpoint/storage/buckets/$bucketId1/files/$fileId/view?project=$projectId1';
  }

  
  static String extractFileIdFromUrl(String url) {
    try {
      final parts = url.split('/');
      final fileIdIndex = parts.indexOf('files') + 1;
      if (fileIdIndex > 0 && fileIdIndex < parts.length) {
        return parts[fileIdIndex];
      }
      throw Exception('Invalid Appwrite file URL');
    } catch (e) {
      throw Exception('Failed to extract file ID: $e');
    }
  }
}
