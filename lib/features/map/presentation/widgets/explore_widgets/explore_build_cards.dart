import 'package:latlong2/latlong.dart';

double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const Distance distance = Distance();
  return distance.as(
    LengthUnit.Kilometer,
    LatLng(lat1, lon1),
    LatLng(lat2, lon2),
  );
}

