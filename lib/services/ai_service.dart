import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

class AiService {
  Future<String> ask(String prompt) async {
    if (!AppConfig.aiReady) throw Exception('AI خدمت لا تنظیم شوی نه دی.');
    final response = await http.post(
      Uri.parse('${AppConfig.aiBaseUrl}/chat'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'prompt': prompt}),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) throw Exception('AI خدمت ته اړیکه ناکامه شوه.');
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return (data['answer'] ?? '').toString();
  }
}
