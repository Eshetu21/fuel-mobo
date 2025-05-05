import 'package:fuel_finder/features/fuel_price/data/datasources/fuel_price_remote_repository.dart';
import 'package:fuel_finder/features/fuel_price/domain/repositories/fuel_price_repository.dart';

class FuelPriceRepositoryImpl extends FuelPriceRepository {
  final FuelPriceRemoteRepository fuelPriceRemoteRepository;

  FuelPriceRepositoryImpl({required this.fuelPriceRemoteRepository});
  @override
  Future<Map<String, dynamic>> getFuelPrice() {
    return fuelPriceRemoteRepository.getFuelPrice();
  }
}

