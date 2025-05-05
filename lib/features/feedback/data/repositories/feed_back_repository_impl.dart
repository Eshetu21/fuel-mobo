import 'package:fuel_finder/features/feedback/data/datasources/feed_back_remote_datasource.dart';
import 'package:fuel_finder/features/feedback/domain/repositories/feed_back_repository.dart';

class FeedBackRepositoryImpl extends FeedBackRepository {
  final FeedBackRemoteDatasource feedBackRemoteDatasource;

  FeedBackRepositoryImpl({required this.feedBackRemoteDatasource});
  @override
  Future<void> createFeedback(String stationId, int rating, String comment) {
    return feedBackRemoteDatasource.createFeedback(stationId, rating, comment);
  }

  @override
  Future<Map<String, dynamic>> getFeedBackByStationAndUser(
    String stationId,
  ) {
    return feedBackRemoteDatasource.getFeedBackByStationAndUser(
      stationId
    );
  }
}

