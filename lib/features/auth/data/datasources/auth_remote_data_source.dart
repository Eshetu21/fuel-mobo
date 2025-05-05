import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class AuthRemoteDataSource {
  final String baseUrl = "https://fuel-backend-1uy6.onrender.com/api/auth";

  Future<Map<String, dynamic>> signUp(
    String firstName,
    String lastName,
    String userName,
    String email,
    String password,
    String role,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/signup'),
        body: jsonEncode({
          "first_name": firstName,
          "last_name": lastName,
          "username": userName,
          "password": password,
          "email": email,
          "role": role,
        }),
        headers: {"Content-Type": "application/json"},
      );

      final responseData = jsonDecode(response.body);
      debugPrint("SIGNUP RESPONSE: $responseData");

      if (response.statusCode != 201) {
        final errorMsg = responseData['error'] ?? 'Registration failed';
        throw errorMsg;
      }

      return responseData;
    } catch (e) {
      debugPrint("Signup error: $e");
      throw e.toString();
    }
  }

  Future<Map<String, dynamic>> signIn(String userName, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        body: jsonEncode({"username": userName, "password": password}),
        headers: {"Content-Type": "application/json"},
      );

      final responseData = jsonDecode(response.body);
      debugPrint("LOGIN RESPONSE: $responseData");

      if (response.statusCode != 200) {
        final errorMsg = responseData['error'] ?? 'Invalid credentials';
        throw errorMsg;
      }

      return responseData;
    } catch (e) {
      debugPrint("Login error: $e");
      throw 'Invalid credentials';
    }
  }

  Future<void> logOut() async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/logout"),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode != 200) {
        throw 'Logout failed';
      }
    } catch (e) {
      debugPrint("Logout error: $e");
      throw e.toString();
    }
  }

  Future<void> verifyEmail(String userId, String token) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/verify/$userId"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"token": token}),
      );

      final responseBody = json.decode(response.body);
      debugPrint("Verification response: $responseBody");

      if (response.statusCode != 200) {
        final errorMsg = responseBody["message"] ?? "Email verification failed";
        throw errorMsg;
      }
    } catch (e) {
      debugPrint("Verification error: $e");
      throw e.toString();
    }
  }
}

