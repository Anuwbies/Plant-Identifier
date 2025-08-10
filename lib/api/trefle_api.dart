import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class Plant {
  final String commonName;
  final String scientificName;
  final String imageUrl;

  Plant({
    required this.commonName,
    required this.scientificName,
    required this.imageUrl,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      commonName: json['common_name'] ?? 'Unknown',
      scientificName: json['scientific_name'] ?? 'Unknown',
      imageUrl: json['image_url'] ?? '',
    );
  }
}

class TrefleApi {
  static const String _baseUrl = 'https://trefle.io/api/v1';
  static const String _token = 'jP6_wxVkm4zkskMQl3S0vFUiNJrnW6sY1-Ytx_1myUA'; // Replace with your token

  static Future<List<Plant>> getRandomPlants({int limit = 10}) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/plants?token=$_token&page_size=50'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> plantsJson = data['data'];

        final plants = plantsJson.map((json) => Plant.fromJson(json)).toList();

        // Shuffle and take 'limit' plants
        plants.shuffle(Random());
        return plants.take(limit).toList();
      } else {
        throw Exception('Failed to load plants: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching plants: $e');
    }
  }
}
