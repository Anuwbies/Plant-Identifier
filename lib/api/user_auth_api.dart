import 'dart:convert';
import 'package:http/http.dart' as http;

class UserAuthApi {
  static const String baseUrl = "http://10.0.2.2:8000";

  //======================================================================
  // REGISTER USER
  //======================================================================
  static Future<Map<String, dynamic>> registerUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final url = Uri.parse('$baseUrl/register/');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'password': password,
          'confirm_password': confirmPassword,
        }),
      );

      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': 'User registered successfully',
        };
      } else {
        final errors = jsonDecode(response.body);
        return {
          'success': false,
          'errors': errors, // direct error dict from backend
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  //======================================================================
  // LOGIN USER
  //======================================================================
  static Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/login/');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        return {
          'success': true,
          'user': responseData['user'],
        };
      } else {
        return {
          'success': false,
          'errors': responseData,
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
