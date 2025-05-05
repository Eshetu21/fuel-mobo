import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuel_finder/core/utils/token_services.dart';
import 'package:fuel_finder/features/auth/domain/usecases/logout_usecase.dart';
import 'package:fuel_finder/features/auth/domain/usecases/signin_usecase.dart';
import 'package:fuel_finder/features/auth/domain/usecases/signup_usecase.dart';
import 'package:fuel_finder/features/auth/domain/usecases/verify_email_usecase.dart';
import 'package:fuel_finder/features/auth/presentation/bloc/auth_event.dart';
import 'package:fuel_finder/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignupUsecase signupUsecase;
  final SigninUsecase signinUsecase;
  final VerifyEmailUsecase verifyEmailUsecase;
  final LogoutUsecase logoutUsecase;
  final TokenService tokenService;

  static const int _minimumLoadingTime = 1500;

  String _cleanErrorMessage(dynamic error) {
    String message = error.toString();
    if (message.startsWith('Exception: ')) {
      message = message.substring('Exception: '.length);
    }
    return message;
  }

  AuthBloc({
    required this.signupUsecase,
    required this.signinUsecase,
    required this.verifyEmailUsecase,
    required this.logoutUsecase,
    required this.tokenService,
  }) : super(AuthInitial()) {
    on<AuthSignUpEvent>(_onSignUp);
    on<AuthSignInEvent>(_onSignIn);
    on<AuthVerifyEmailEvent>(_onVerifyEmail);
    on<AuthLogOutEvent>(_onLogOut);
  }

  Future<void> _onSignUp(AuthSignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await signupUsecase(
        event.firstName,
        event.lastName,
        event.userName,
        event.email,
        event.password,
        event.role,
      );

      emit(
        AuthVerifyEmail(
          message: "Registration successful",
          userId: user["data"]["id"],
        ),
      );
    } on SocketException {
      emit(AuthFailure(error: "No Internet connection"));
    } on FormatException {
      emit(AuthFailure(error: "Invalid data format"));
    } catch (e) {
      emit(AuthFailure(error: _cleanErrorMessage(e)));
    }
  }

  Future<void> _onSignIn(AuthSignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final stopwatch = Stopwatch()..start();

    try {
      final response = await signinUsecase(event.userName, event.password);
      final userId = response["user"]["id"];
      final token = response["token"];

      await tokenService.saveToken(token);
      await tokenService.saveUserId(userId);

      final elapsed = stopwatch.elapsedMilliseconds;
      if (elapsed < _minimumLoadingTime) {
        await Future.delayed(
          Duration(milliseconds: _minimumLoadingTime - elapsed),
        );
      }

      emit(AuthLogInSucess(message: "Login successful", userId: userId));
    } on SocketException {
      emit(AuthFailure(error: "No Internet connection"));
    } on FormatException {
      emit(AuthFailure(error: "Invalid data format"));
    } catch (e) {
      emit(AuthFailure(error: _cleanErrorMessage(e)));
    } finally {
      stopwatch.stop();
    }
  }

  Future<void> _onVerifyEmail(
    AuthVerifyEmailEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await verifyEmailUsecase(event.userId, event.token);
      emit(AuthSuccess(message: "Email verification successful"));
    } on SocketException {
      emit(AuthFailure(error: "No Internet connection"));
    } on FormatException {
      emit(AuthFailure(error: "Invalid verification code"));
    } catch (e) {
      emit(AuthFailure(error: _cleanErrorMessage(e)));
    }
  }

  Future<void> _onLogOut(AuthLogOutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await tokenService.clearAll();
      emit(AuthSuccess(message: "Logout successful"));
    } catch (e) {
      emit(AuthFailure(error: _cleanErrorMessage(e)));
    }
  }
}

