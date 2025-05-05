class GasStationEvent {}

class GetGasStationsEvent extends GasStationEvent {
  final String latitude;
  final String longitude;

  GetGasStationsEvent({required this.latitude, required this.longitude});
}

