import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuel_finder/features/route/data/models/route_model.dart';
import 'package:fuel_finder/features/route/data/repositories/route_repository.dart';
import 'package:latlong2/latlong.dart';

abstract class RouteEvent {
  const RouteEvent();
  List<Object> get props => [];
}

class CalculateRoute extends RouteEvent {
  final List<LatLng> waypoints;
  final String profile;
  final bool steps;
  final String overview;
  final String geometries;

  const CalculateRoute({
    required this.waypoints,
    this.profile = 'driving',
    this.steps = false,
    this.overview = 'simplified',
    this.geometries = 'polyline',
  });

  @override
  List<Object> get props => [waypoints, profile, steps, overview, geometries];
}

abstract class RouteState {
  const RouteState();

  List<Object> get props => [];
}

class RouteInitial extends RouteState {}

class RouteLoading extends RouteState {}

class RouteLoaded extends RouteState {
  final RouteModel route;

  const RouteLoaded({required this.route});

  @override
  List<Object> get props => [route];
}

class RouteError extends RouteState {
  final String message;

  const RouteError({required this.message});

  @override
  List<Object> get props => [message];
}

class RouteBloc extends Bloc<RouteEvent, RouteState> {
  final RouteRepository routeRepository;

  RouteBloc(this.routeRepository) : super(RouteInitial()) {
    on<CalculateRoute>(_onCalculateRoute);
  }

  Future<void> _onCalculateRoute(
    CalculateRoute event,
    Emitter<RouteState> emit,
  ) async {
    emit(RouteLoading());
    try {
      final route = await routeRepository.getRoute(
        waypoints: event.waypoints,
        profile: event.profile,
        steps: event.steps,
        overview: event.overview,
        geometries: event.geometries,
      );
      emit(RouteLoaded(route: route));
    } catch (e) {
      emit(RouteError(message: e.toString()));
    }
  }
}

