import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class PlantNetApi {
  static const String _apiKey = '2b10gROkX2f9ReB6H1cCcAnyu';

  Future<Map<String, dynamic>> identifyPlant(File imageFile) async {
    // Append API key as query parameter
    final uri = Uri.parse(
      'https://my-api.plantnet.org/v2/identify/all?include-related-images=true&api-key=$_apiKey',
    );


    var request = http.MultipartRequest('POST', uri);

    // Remove the header with Api-Key, it should NOT be in headers

    request.files.add(await http.MultipartFile.fromPath('images', imageFile.path));

    // Add optional fields if needed:
    // request.fields['organs'] = 'flower';

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      return json.decode(responseBody) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to identify plant. Status code: ${response.statusCode}');
    }
  }
}
