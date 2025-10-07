import 'dart:convert';
import 'package:http/http.dart' as http;

class Plant {
  final String commonName;
  final String scientificName;
  final String sampleImage;

  Plant({
    required this.commonName,
    required this.scientificName,
    required this.sampleImage,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      commonName: json['common_name'] ?? 'Unknown',
      scientificName: json['scientific_name'] ?? 'Unknown',
      sampleImage: json['sample_image'] ?? 'Not available',
    );
  }
}

class RandomPlantApi {
  static const String baseUrl = "http://10.0.2.2:8000";

  static Future<List<Plant>> fetchRandomPlants() async {
    final url = Uri.parse("$baseUrl/random-plants/");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // API returns {"plants": [...]}
      final List<dynamic> plantsJson = data['plants'];

      return plantsJson.map((plant) => Plant.fromJson(plant)).toList();
    } else {
      throw Exception("Failed to load random plants: ${response.statusCode}");
    }
  }
}