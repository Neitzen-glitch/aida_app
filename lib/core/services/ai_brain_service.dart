import 'dart:convert';
import 'package:http/http.dart' as http;

class AiBrainService {
  // Use http://10.0.0.2:8000 for Android Emulator or your local IP for Web
  static const String _baseUrl = "http://127.0.0.1:8000";

  Future<String?> requestMarketingPost({
    required String businessId,
    required String name,
    required String niche,
    required String platform,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/generate-post"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "business_id": businessId,
          "business_name": name,
          "niche": niche,
          "platform": platform,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['content'];
      }
    } catch (e) {
      print("AI Brain Error: $e");
    }
    return null;
  }
}