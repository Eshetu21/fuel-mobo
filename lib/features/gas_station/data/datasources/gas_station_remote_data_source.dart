import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:fuel_finder/core/utils/token_services.dart';
import 'package:http/http.dart' as http;

class GasStationRemoteDataSource {
  final String baseUrl = "https://fuel-backend-1uy6.onrender.com/api";
  final TokenService tokenService;

  GasStationRemoteDataSource({required this.tokenService});
  Future<Map<String, dynamic>> getGasStations(
    String latitude,
    String longitude,
  ) async {
    final token = await tokenService.getAuthToken();
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/station/near-station'),
        body: jsonEncode({"latitude": latitude, "longitude": longitude}),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      final responseData = jsonDecode(response.body);
      debugPrint("Gas Station ResponseData: $responseData");
      return responseData;
    } catch (e) {
      throw e.toString();
    }
  }
}

