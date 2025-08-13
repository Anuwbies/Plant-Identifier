import 'dart:convert';
import 'package:http/http.dart' as http;

class DjangoApi {
  static const String baseUrl = "http://192.168.100.4:8000";

  static Future<Map<String, dynamic>> registerUser({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final url = Uri.parse('$baseUrl/api/register/');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          'confirm_password': confirmPassword,
        }),
      );

      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': 'User registered successfullie',
        };
      } else {
        final errors = jsonDecode(response.body);
        return {
          'success': false,
          'errors': errors, // directly pass the dict
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }
}