import 'dart:convert';

import 'package:fuel_finder/core/utils/token_services.dart';
import 'package:http/http.dart' as http;

class FeedBackRemoteDatasource {
  final String baseUrl = 'https://fuel-backend-1uy6.onrender.com/api';
  final TokenService tokenService;

  FeedBackRemoteDatasource({required this.tokenService});

  Future<void> createFeedback(
    String stationId,
    int rating,
    String comment,
  ) async {
    try {
      final token = await tokenService.getAuthToken();
      await http.post(
        Uri.parse('$baseUrl/feedback'),
        body: jsonEncode({
          "station_id": stationId,
          "rating": rating,
          "comment": comment,
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    } catch (e) {
      throw 'Failed to create feedback: ${e.toString()}';
    }
  }

  Future<Map<String, dynamic>> getFeedBackByStationAndUser(
    String stationId,
  ) async {
    try {
      final userId = tokenService.getUserId();
      final token = await tokenService.getAuthToken();
      final response = await http.get(
        Uri.parse('$baseUrl/feedback/station/$stationId/user/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode != 200) {
        throw 'Error ${response.body}';
      }
      return jsonDecode(response.body);
    } catch (e) {
      throw 'Failed to getFeedback ${e.toString()}';
    }
  }
}

