class FavoriteState {}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteSucess extends FavoriteState {
  final String message;

  FavoriteSucess({required this.message});
}

class FetchFavoriteSucess extends FavoriteState {
  final Map<String, dynamic> favorites;
  final String message;

  FetchFavoriteSucess({required this.favorites, required this.message});
}

class FavoriteFailure extends FavoriteState {
  final String error;

  FavoriteFailure({required this.error});
}

