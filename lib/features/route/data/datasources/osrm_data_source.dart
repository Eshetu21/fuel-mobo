import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

class OSRMDataSource {
  final Dio _dio;

  OSRMDataSource(this._dio);

  Future<Map<String, dynamic>> fetchRoute({
    required List<LatLng> waypoints,
    required String profile,
    bool alternatives = false,
    bool steps = false,
    String overview = 'simplified',
    String geometries = 'polyline',
  }) async {
    final waypointsString = waypoints
        .map((coord) => '${coord.longitude},${coord.latitude}')
        .join(';');

    final response = await _dio.get(
      'http://router.project-osrm.org/route/v1/$profile/$waypointsString',
      queryParameters: {
        'alternatives': alternatives.toString(),
        'steps': steps.toString(),
        'overview': overview,
        'geometries': geometries,
      },
    );

    if (response.statusCode == 200) {
      debugPrint("Route ${response.data}");
      return response.data;
    } else {
      print("routeResponse: $response");
      throw ('Failed to load route}');
    }
  }
}
