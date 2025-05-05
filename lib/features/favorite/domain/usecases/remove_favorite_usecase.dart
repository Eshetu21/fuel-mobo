import 'package:fuel_finder/features/favorite/domain/repositories/favorite_repository.dart';

class RemoveFavoriteUsecase {
  final FavoriteRepository favoriteRepository;

  RemoveFavoriteUsecase({required this.favoriteRepository});

  Future<void> call(String stationId) {
    return favoriteRepository.removeFavorite(stationId);
  }
}

