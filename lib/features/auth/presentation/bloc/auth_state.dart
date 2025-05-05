abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String message;

  AuthSuccess({required this.message});
}

class AuthVerifyEmail extends AuthState {
  final String message;
  final String userId;

  AuthVerifyEmail({required this.message, required this.userId});
}

class AuthLogInSucess extends AuthState{
  final String message;
  final String userId;

  AuthLogInSucess({required this.message, required this.userId});
}

class AuthFailure extends AuthState {
  final String error;

  AuthFailure({required this.error});
}

