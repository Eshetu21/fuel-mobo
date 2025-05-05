import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

abstract class GeolocationEvent {}

class FetchUserLocation extends GeolocationEvent {}

abstract class GeolocationState {}

class GeolocationInitial extends GeolocationState {}

class GeolocationLoading extends GeolocationState {}

class GeolocationLoaded extends GeolocationState {
  final double latitude;
  final double longitude;

  GeolocationLoaded({required this.latitude, required this.longitude});
}

class GeolocationError extends GeolocationState {
  final String message;

  GeolocationError({required this.message});
}

class GeolocationBloc extends Bloc<GeolocationEvent, GeolocationState> {
  GeolocationBloc() : super(GeolocationInitial()) {
    on<FetchUserLocation>((event, emit) async {
      emit(GeolocationLoading());
      try {
        Position position = await Geolocator.getCurrentPosition();
        emit(
          GeolocationLoaded(
            latitude: position.latitude,
            longitude: position.longitude,
          ),
        );
      } catch (e) {
        emit(GeolocationError(message: e.toString()));
      }
    });
  }
}
