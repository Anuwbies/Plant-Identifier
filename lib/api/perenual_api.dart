import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class PerenualApi {
  static const String _baseUrl = 'https://perenual.com/api/species-list';
  static const String _apiKey = 'sk-TwXb689813352b63311773'; // Replace with your API key

  static Future<List<Map<String, dynamic>>> fetchRandomPlants() async {
    try {
      // Fetch the first 100 plants to have enough data to pick random ones
      final response = await http.get(
        Uri.parse('$_baseUrl?key=$_apiKey&page=1&size=100'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List plants = data['data'] ?? [];

        if (plants.isEmpty) return [];

        // Shuffle and take 10 random plants
        plants.shuffle(Random());
        final randomPlants = plants.take(10).map((plant) {
          return {
            'common_name': plant['common_name'] ?? 'Unknown',
            'scientific_name': (plant['scientific_name'] is List
                ? plant['scientific_name'].join(', ')
                : plant['scientific_name']) ?? 'Unknown',
            'image_url': plant['default_image']?['original_url'] ?? '',
          };
        }).toList();

        return randomPlants;
      } else {
        throw Exception('Failed to fetch plants: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching plants: $e');
    }
  }
}