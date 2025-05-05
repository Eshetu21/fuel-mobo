import 'package:fuel_finder/features/auth/domain/repositories/auth_repository.dart';

class LogoutUsecase {
  final AuthRepository authRepository;

  LogoutUsecase({required this.authRepository});
  Future<void> call() {
    return authRepository.logOut();
  }
}

