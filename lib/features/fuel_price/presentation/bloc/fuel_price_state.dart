class FuelPriceState {}

class FuelPriceInitial extends FuelPriceState {}

class FuelPriceLoading extends FuelPriceState {}

class FuelPriceSucess extends FuelPriceState {
  final Map<String, dynamic> fuelPrices;

  FuelPriceSucess({required this.fuelPrices, required String message});
}

class FuelPriceFailure extends FuelPriceState {
  final String error;

  FuelPriceFailure({required this.error});
}

