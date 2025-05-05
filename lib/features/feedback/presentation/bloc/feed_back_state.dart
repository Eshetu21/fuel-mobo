abstract class FeedBackState {}

class FeedBackInitial extends FeedBackState {}

class FeedBackLoading extends FeedBackState {}

class FeedBackSucess extends FeedBackState {
  final String message;
  final Map<String, dynamic>? feedback;

  FeedBackSucess({required this.message, this.feedback});

  @override
  List<Object?> get props => [message, feedback];
}

class FeedBackFetchSucess extends FeedBackState {
  final Map<String, dynamic> feedback;
  final String message;

  FeedBackFetchSucess({required this.feedback, required this.message});
}

class FeedBackFailure extends FeedBackState {
  final String error;

  FeedBackFailure({required this.error});
}
