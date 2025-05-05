import 'package:fuel_finder/features/auth/domain/repositories/auth_repository.dart';

class VerifyEmailUsecase {
  final AuthRepository authRepository;

  VerifyEmailUsecase({required this.authRepository});
  Future<void> call(String userId, String token) {
    return authRepository.verifyEmail(userId, token);
  }
}

