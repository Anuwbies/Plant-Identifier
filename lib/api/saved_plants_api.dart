import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SavedPlantsApi {
  static const String baseUrl = 'http://10.0.2.2:8000';

  // Save a plant for the logged-in user
  static Future<Map<String, dynamic>> savePlant({
    required int speciesId,
    required String commonName,
    required String scientificName,
    double? confidence,
    required String imageUrl,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');

    if (userId == null) {
      throw Exception('User ID not found in SharedPreferences');
    }

    final url = Uri.parse('$baseUrl/saved-plants/');
    final headers = {'Content-Type': 'application/json'};

    final body = jsonEncode({
      'user_id': userId,
      'species_id': speciesId,
      'common_name': commonName,
      'scientific_name': scientificName,
      'confidence': confidence,
      'image_url': imageUrl,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        print('Failed to save plant: ${response.body}');
        throw Exception('Failed to save plant: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error saving plant: $e');
    }
  }

  // Fetch all saved plants for the logged-in user
  static Future<List<dynamic>> fetchSavedPlants() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');

    if (userId == null) {
      throw Exception('User ID not found in SharedPreferences');
    }

    final url = Uri.parse('$baseUrl/saved-plants/?user_id=$userId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Failed to fetch saved plants: ${response.body}');
        throw Exception('Failed to fetch saved plants: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching saved plants: $e');
    }
  }

  // Delete a saved plant
  static Future<void> deleteSavedPlant(int plantId) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');

    if (userId == null) {
      throw Exception('User ID not found in SharedPreferences');
    }

    final url = Uri.parse('$baseUrl/saved-plants/$plantId/?user_id=$userId');

    try {
      final response = await http.delete(url);

      if (response.statusCode != 204) {
        print('Failed to delete saved plant: ${response.body}');
        throw Exception('Failed to delete saved plant: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting saved plant: $e');
    }
  }
}
