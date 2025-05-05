import 'package:fuel_finder/features/feedback/domain/repositories/feed_back_repository.dart';

class GetFeedBackUsecase {
  final FeedBackRepository feedBackRepository;

  GetFeedBackUsecase({required this.feedBackRepository});

  Future<Map<String, dynamic>> call(String stationId) async {
    return feedBackRepository.getFeedBackByStationAndUser(stationId);
  }
}

