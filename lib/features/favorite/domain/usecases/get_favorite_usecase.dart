import 'package:fuel_finder/features/favorite/domain/repositories/favorite_repository.dart';

class GetFavoriteUsecase {
  final FavoriteRepository favoriteRepository;

  GetFavoriteUsecase({required this.favoriteRepository});
  Future<Map<String, dynamic>> call() {
    return favoriteRepository.getFavorite();
  }
}

