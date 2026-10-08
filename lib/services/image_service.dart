import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

class ImageService {
  Future<String> upload(File file) async {
    if (!AppConfig.cloudinaryReady) {
      throw Exception('د عکس خدمت لا تنظیم شوی نه دی. CLOUDINARY_CLOUD_NAME او CLOUDINARY_UPLOAD_PRESET ته اړتیا ده.');
    }
    final uri = Uri.parse('https://api.cloudinary.com/v1_1/${AppConfig.cloudinaryCloudName}/image/upload');
    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = AppConfig.cloudinaryUploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', file.path));
    final response = await request.send();
    final body = await response.stream.bytesToString();
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('د عکس پورته کول ناکام شول.');
    }
    final data = jsonDecode(body) as Map<String, dynamic>;
    final url = data['secure_url'] as String?;
    if (url == null || url.isEmpty) throw Exception('د عکس URL ترلاسه نه شو.');
    return url;
  }
}
