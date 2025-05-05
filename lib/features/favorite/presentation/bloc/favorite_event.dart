class FavoriteEvent {}

class SetFavoriteEvent extends FavoriteEvent {
  final String stationId;

  SetFavoriteEvent({required this.stationId});
}

class RemoveFavoriteEvent extends FavoriteEvent {
  final String stationId;

  RemoveFavoriteEvent({required this.stationId});
}

class GetFavoritesEvent extends FavoriteEvent {}

