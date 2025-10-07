import 'dart:convert';
import 'package:http/http.dart' as http;

class OllamaApi {
  final String baseUrl;

  const OllamaApi({this.baseUrl = 'http://10.0.2.2:11434'});

  Future<String> sendPrompt({
    required String model,
    required String prompt,
  }) async {
    final url = Uri.parse('$baseUrl/api/generate');

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
  }

  Stream<String> streamPrompt({
    required String model,
    required String prompt,
  }) async* {
    final url = Uri.parse('$baseUrl/api/generate');

    final request = http.Request('POST', url)
      ..headers.addAll({'Content-Type': 'application/json'})
      ..body = jsonEncode({
        'model': model,
        'prompt': prompt,
        'stream': true,
      });

    final client = http.Client();
    final streamedResponse = await client.send(request);

    if (streamedResponse.statusCode == 200) {
      await for (var chunk in streamedResponse.stream.transform(utf8.decoder)) {
        for (var line in chunk.split('\n')) {
          if (line.trim().isEmpty) continue;
          try {
            final data = jsonDecode(line);
            if (data['response'] != null) {
              yield data['response'].toString();
            }
          } catch (_) {
          }
        }
      }
    } else {
      throw Exception(
        'Ollama API error: ${streamedResponse.statusCode}',
      );
    }
  }
}
