abstract class FeedBackEvent {}

class CreateFeedBackEvent extends FeedBackEvent {
  final String stationId;
  final int rating;
  final String comment;

  CreateFeedBackEvent({
    required this.stationId,
    required this.rating,
    required this.comment,
  });
}

class GetFeedBackByStationAndUserEvent extends FeedBackEvent {
  final String stationId;

  GetFeedBackByStationAndUserEvent({required this.stationId});
}
