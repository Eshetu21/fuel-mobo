import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuel_finder/features/gas_station/domain/usecases/get_gas_station_usecase.dart';
import 'package:fuel_finder/features/gas_station/presentation/bloc/gas_station_event.dart';
import 'package:fuel_finder/features/gas_station/presentation/bloc/gas_station_state.dart';

class GasStationBloc extends Bloc<GasStationEvent, GasStationState> {
  final GetGasStationUsecase getGasStationUsecase;

  GasStationBloc({required this.getGasStationUsecase})
    : super(GasStationInitial()) {
    on<GetGasStationsEvent>(_getGasStations);
  }

  Future<void> _getGasStations(
    GetGasStationsEvent event,
    Emitter<GasStationState> emit,
  ) async {
    emit(GasStationLoading());
    try {
      final response = await getGasStationUsecase(
        event.latitude,
        event.longitude,
      );
      if (response is! Map<String, dynamic>) {
        throw Exception('Invalid response format');
      }

      final data = response['data'];
      if (data == null) {
        emit(GasStationNull(message: "No gas stations found"));
      } else if (data is List) {
        emit(
          GasStationSucess(
            message: "Gas stations fetched",
            gasStation: List<Map<String, dynamic>>.from(data),
          ),
        );
      } else {
        throw Exception('Unexpected data format: ${data.runtimeType}');
      }
    } catch (e) {
      emit(GasStationFailure(error: e.toString()));
    }
  }
}

