import 'dart:convert';
import 'package:http/http.dart' as http;

// Model for Plant
class Plant {
  final String speciesId;
  final String commonName;
  final String scientificName;
  final String? sampleImage;

  Plant({
    required this.speciesId,
    required this.commonName,
    required this.scientificName,
    this.sampleImage,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      speciesId: json['species_id'],
      commonName: json['common_name'],
      scientificName: json['scientific_name'],
      sampleImage: json['sample_image'],
    );
  }
}

// API class to fetch random plants
class RandomPlantApi {
  final String baseUrl;

  RandomPlantApi({required this.baseUrl});

  Future<List<Plant>> fetchRandomPlants() async {
    final url = Uri.parse('$baseUrl/api/random-plants/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final plantsJson = data['plants'] as List;
      return plantsJson.map((json) => Plant.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch random plants');
    }
  }
}
