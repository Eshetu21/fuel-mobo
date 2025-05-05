import 'package:fuel_finder/features/favorite/data/datasources/favorite_remote_data_source.dart';
import 'package:fuel_finder/features/favorite/domain/repositories/favorite_repository.dart';

class FavoriteRepositoryImpl extends FavoriteRepository {
  final FavoriteRemoteDataSource favoriteRemoteDataSource;

  FavoriteRepositoryImpl({required this.favoriteRemoteDataSource});
  @override
  Future<Map<String, dynamic>> getFavorite() {
    return favoriteRemoteDataSource.getFavorites();
  }

  @override
  Future<void> removeFavorite(String stationId) {
    return favoriteRemoteDataSource.removeFavorite(stationId);
  }

  @override
  Future<void> setFavorite(String stationId) {
    return favoriteRemoteDataSource.setFavorite(stationId);
  }
}

