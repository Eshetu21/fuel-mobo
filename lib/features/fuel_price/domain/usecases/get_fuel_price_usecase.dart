import 'package:fuel_finder/features/fuel_price/domain/repositories/fuel_price_repository.dart';

class GetFuelPriceUsecase {
  final FuelPriceRepository fuelPriceRepository;

  GetFuelPriceUsecase({required this.fuelPriceRepository});

  Future<Map<String, dynamic>> call() async {
    return fuelPriceRepository.getFuelPrice();
  }
}

