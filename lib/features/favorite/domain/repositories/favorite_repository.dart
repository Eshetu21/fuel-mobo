abstract class FavoriteRepository {
  Future<void> setFavorite(String stationId);
  Future<void> removeFavorite(String stationId);
  Future<Map<String, dynamic>> getFavorite();
}

