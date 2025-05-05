abstract class GasRepository {
  Future<Map<String, dynamic>> getGasStations(
    String latitude,
    String longitude,
  );
}

