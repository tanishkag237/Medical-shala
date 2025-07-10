import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart'; 

class GeminiService {
  static String get _apiKey => ApiConfig.geminiApiKey;

  static Future<String> getFlashResponse(String userQuery) async {
    if (_apiKey.isEmpty) {
      throw Exception('❌ Gemini API key not found.');
    }

    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash:generateContent?key=$_apiKey',
    );

    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {"text": userQuery}
          ]
        }
      ]
    });

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        print("❌ API Error: ${response.body}");
        throw Exception('❌ Gemini API Error: ${response.body}');
      }
    } catch (e) {
      print("❌ Request Error: $e");
      rethrow;
    }
  }
}