class GasStationState {}

class GasStationInitial extends GasStationState {}

class GasStationLoading extends GasStationState {}

class GasStationSucess extends GasStationState {
  final String message;
  final List<Map<String, dynamic>> gasStation;

  GasStationSucess({required this.message, required this.gasStation});
}

class GasStationFailure extends GasStationState {
  final String error;

  GasStationFailure({required this.error});
}

class GasStationNull extends GasStationState {
  final String message;

  GasStationNull({required this.message});
}

