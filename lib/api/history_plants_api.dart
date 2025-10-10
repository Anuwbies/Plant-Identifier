import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HistoryPlantsApi {
  static const String baseUrl = 'http://10.0.2.2:8000';

  /// Fetch plant history for the logged-in user
  static Future<List<dynamic>> fetchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');

    if (userId == null) {
      throw Exception('User ID not found in SharedPreferences');
    }

    final url = Uri.parse('$baseUrl/plant-history/?user_id=$userId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Failed to fetch history: ${response.body}');
        throw Exception('Failed to fetch plant history (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error fetching plant history: $e');
    }
  }

  /// Save a new plant identification to history
  static Future<Map<String, dynamic>> saveHistory({
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

    final url = Uri.parse('$baseUrl/plant-history/');
    final headers = {'Content-Type': 'application/json'};

    final body = jsonEncode({
      'user_id': userId,
      'species_id': speciesId,
      'common_name': commonName,
      'scientific_name': scientificName,
      'confidence': confidence, // Can be null
      'image_url': imageUrl,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        print('Failed to save history: ${response.body}');
        throw Exception('Failed to save plant history (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error saving plant history: $e');
    }
  }

  /// Delete a specific plant from history (optional if you add delete endpoint)
  static Future<void> deleteHistory(int historyId) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');

    if (userId == null) {
      throw Exception('User ID not found in SharedPreferences');
    }

    final url = Uri.parse('$baseUrl/plant-history/$historyId/?user_id=$userId');

    try {
      final response = await http.delete(url);

      if (response.statusCode != 204) {
        print('Failed to delete history: ${response.body}');
        throw Exception('Failed to delete plant history (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error deleting plant history: $e');
    }
  }
}
