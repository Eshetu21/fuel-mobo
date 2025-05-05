import 'package:latlong2/latlong.dart';

class RouteModel {
  final List<LatLng> coordinates;
  final double distance;
  final double duration;
  final String geometry;
  final List<RouteStep>? steps;
  final RouteSummary summary;

  RouteModel({
    required this.coordinates,
    required this.distance,
    required this.duration,
    required this.geometry,
    this.steps,
    required this.summary,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    final geometry = json['routes'][0]['geometry'];
    final coordinates = _decodePolyline(geometry);

    return RouteModel(
      coordinates: coordinates,
      distance: json['routes'][0]['distance'].toDouble(),
      duration: json['routes'][0]['duration'].toDouble(),
      geometry: geometry,
      steps:
          json['routes'][0]['legs']?[0]['steps'] != null
              ? (json['routes'][0]['legs'][0]['steps'] as List)
                  .map((step) => RouteStep.fromJson(step))
                  .toList()
              : null,
      summary: RouteSummary.fromJson(json['routes'][0]),
    );
  }

  static List<LatLng> _decodePolyline(String encoded) {
    final List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1e5, lng / 1e5));
    }
    return points;
  }
}

class RouteStep {
  final double distance;
  final double duration;
  final String name;
  final String? mode;
  final String? instruction;
  final List<LatLng> coordinates;

  RouteStep({
    required this.distance,
    required this.duration,
    required this.name,
    this.mode,
    this.instruction,
    required this.coordinates,
  });

  factory RouteStep.fromJson(Map<String, dynamic> json) {
    return RouteStep(
      distance: json['distance'].toDouble(),
      duration: json['duration'].toDouble(),
      name: json['name'],
      mode: json['mode'],
      instruction: json['instruction'],
      coordinates: RouteModel._decodePolyline(json['geometry']),
    );
  }
}

class RouteSummary {
  final double totalDistance;
  final double totalDuration;

  RouteSummary({required this.totalDistance, required this.totalDuration});

  factory RouteSummary.fromJson(Map<String, dynamic> json) {
    return RouteSummary(
      totalDistance: json['distance'].toDouble(),
      totalDuration: json['duration'].toDouble(),
    );
  }
}
