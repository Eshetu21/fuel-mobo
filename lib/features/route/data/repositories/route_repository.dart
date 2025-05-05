import 'package:fuel_finder/features/route/data/datasources/osrm_data_source.dart';
import 'package:fuel_finder/features/route/data/models/route_model.dart';
import 'package:latlong2/latlong.dart';

abstract class RouteRepository {
  Future<RouteModel> getRoute({
    required List<LatLng> waypoints,
    required String profile,
    bool alternatives = false,
    bool steps = false,
    String overview = 'simplified',
    String geometries = 'polyline',
  });
}

class RouteRepositoryImpl implements RouteRepository {
  final OSRMDataSource dataSource;

  RouteRepositoryImpl(this.dataSource);

  @override
  Future<RouteModel> getRoute({
    required List<LatLng> waypoints,
    required String profile,
    bool alternatives = false,
    bool steps = false,
    String overview = 'simplified',
    String geometries = 'polyline',
  }) async {
    try {
      final response = await dataSource.fetchRoute(
        waypoints: waypoints,
        profile: profile,
        alternatives: alternatives,
        steps: steps,
        overview: overview,
        geometries: geometries,
      );
      return RouteModel.fromJson(response);
    } catch (e) {
      throw ('Failed to get route please check you internet connection');
    }
  }
}
