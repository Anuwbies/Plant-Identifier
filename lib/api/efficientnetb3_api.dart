import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class EfficientNetB3Api {
  static const String baseUrl = "http://192.168.100.4:8000";

  static Future<Map<String, dynamic>> predictPlant(File imageFile) async {
    final uri = Uri.parse("$baseUrl/predict/");
    final request = http.MultipartRequest('POST', uri);

    request.files.add(
      await http.MultipartFile.fromPath('image', imageFile.path),
    );

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        return {
          "error":
          "Server responded with status ${response.statusCode}: ${response.body}"
        };
      }
    } catch (e) {
      return {"error": e.toString()};
    }
  }
}
