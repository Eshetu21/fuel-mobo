import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuel_finder/features/feedback/domain/usecases/create_feed_back_usecase.dart';
import 'package:fuel_finder/features/feedback/domain/usecases/get_feed_back_usecase.dart';
import 'package:fuel_finder/features/feedback/presentation/bloc/feed_back_event.dart';
import 'package:fuel_finder/features/feedback/presentation/bloc/feed_back_state.dart';

class FeedBackBloc extends Bloc<FeedBackEvent, FeedBackState> {
  final CreateFeedBackUsecase createFeedBackUsecase;
  final GetFeedBackUsecase getFeedBackUsecase;

  String _cleanErrorMessage(dynamic error) {
    String message = error.toString();
    if (message.startsWith('Exception: ')) {
      message = message.substring('Exception: '.length);
    }
    return message;
  }

  FeedBackBloc({
    required this.createFeedBackUsecase,
    required this.getFeedBackUsecase,
  }) : super(FeedBackInitial()) {
    on<CreateFeedBackEvent>(_onCreateFeedback);
    on<GetFeedBackByStationAndUserEvent>(_onGetFeedback);
  }
  Future<void> _onCreateFeedback(
    CreateFeedBackEvent event,
    Emitter<FeedBackState> emit,
  ) async {
    emit(FeedBackLoading());
    try {
      if (event.rating < 1 && event.comment.isEmpty) {
        emit(FeedBackFailure(error: "Please provide a rating or comment"));
        return;
      }

      await createFeedBackUsecase(
        event.stationId,
        event.rating,
        event.comment.trim().isEmpty ? "" : event.comment.trim(),
      );
      final updatedFeedback = await getFeedBackUsecase(event.stationId);
      emit(
        FeedBackSucess(
          message: "Feedback submitted successfully!",
          feedback: updatedFeedback,
        ),
      );
    } on SocketException {
      emit(FeedBackFailure(error: "No Internet connection"));
    } on FormatException {
      emit(FeedBackFailure(error: "Invalid data format"));
    } catch (e) {
      emit(FeedBackFailure(error: _cleanErrorMessage(e)));
    }
  }

  Future<void> _onGetFeedback(
    GetFeedBackByStationAndUserEvent event,
    Emitter<FeedBackState> emit,
  ) async {
    emit(FeedBackLoading());
    try {
      final response = await getFeedBackUsecase(event.stationId);
      if (response['data'] == null) {
        emit(
          FeedBackFetchSucess(feedback: response, message: "No feedback found"),
        );
      } else {
        emit(
          FeedBackFetchSucess(
            feedback: response,
            message: "Successfully fetched",
          ),
        );
      }
    } on SocketException {
      emit(FeedBackFailure(error: "No Internet connection"));
    } on FormatException {
      emit(FeedBackFailure(error: "Invalid"));
    } catch (e) {
      if (e.toString().contains("404") || e.toString().contains("not found")) {
        emit(
          FeedBackFetchSucess(
            feedback: {'data': null},
            message: "No feedback found",
          ),
        );
      } else {
        emit(FeedBackFailure(error: _cleanErrorMessage(e)));
      }
    }
  }
}
