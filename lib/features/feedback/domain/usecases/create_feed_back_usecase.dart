import 'package:fuel_finder/features/feedback/domain/repositories/feed_back_repository.dart';

class CreateFeedBackUsecase {
  final FeedBackRepository feedBackRepository;

  CreateFeedBackUsecase({required this.feedBackRepository});

  Future<void> call(String stationId, int rating, String comment) async {
    return feedBackRepository.createFeedback(stationId, rating, comment);
  }
}

