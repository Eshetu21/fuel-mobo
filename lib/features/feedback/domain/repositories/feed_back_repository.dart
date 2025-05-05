abstract class FeedBackRepository {
  Future<void> createFeedback(String stationId, int rating, String comment);
  Future<Map<String, dynamic>> getFeedBackByStationAndUser(String stationId);
}
