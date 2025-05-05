abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserSuccess extends UserState {
  final String message;
  final Map<String, dynamic> responseData;

  UserSuccess(this.responseData, {required this.message});
}

class UserNotFound extends UserState {
  final String message;

  UserNotFound({required this.message});
}

class UserFailure extends UserState {
  final String error;

  UserFailure({required this.error});
}

