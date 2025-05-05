import 'package:fuel_finder/features/favorite/domain/repositories/favorite_repository.dart';

class SetFavoriteUsecase {
  final FavoriteRepository favoriteRepository;

  SetFavoriteUsecase({required this.favoriteRepository});
  Future<void> call(String stationId) {
    return favoriteRepository.setFavorite(stationId);
  }
}

