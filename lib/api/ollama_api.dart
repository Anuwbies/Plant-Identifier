import 'dart:convert';
import 'package:http/http.dart' as http;

class OllamaApi {
  final String baseUrl;

  const OllamaApi({this.baseUrl = 'http://192.168.100.4:11434'});

  Future<String> sendPrompt({
    required String model,
    required String prompt,
  }) async {
    final url = Uri.parse('$baseUrl/api/generate');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'model': model,
          'prompt': prompt,
          'stream': false,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['response'] ?? '').toString().trim();
      } else {
        throw Exception(
          'Ollama API error: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception(
        'Failed to connect to Ollama at $baseUrl.\n'
            'Make sure your server is running and your device can reach it.\n'
            'Error: $e',
      );
    }
  }
}