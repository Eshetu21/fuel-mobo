import 'package:fuel_finder/features/gas_station/data/datasources/gas_station_remote_data_source.dart';
import 'package:fuel_finder/features/gas_station/domain/repositories/gas_repository.dart';

class GasStationRepositoryImpl extends GasRepository {
  final GasStationRemoteDataSource gasStationRemoteDataSource;

  GasStationRepositoryImpl({required this.gasStationRemoteDataSource});
  @override
  Future<Map<String, dynamic>> getGasStations(
    String latitude,
    String longitude,
  ) {
    return gasStationRemoteDataSource.getGasStations(latitude, longitude);
  }
}

