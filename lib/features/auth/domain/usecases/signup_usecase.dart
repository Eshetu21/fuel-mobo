import 'package:fuel_finder/features/auth/domain/repositories/auth_repository.dart';

class SignupUsecase {
  final AuthRepository authRepository;

  SignupUsecase({required this.authRepository});
  Future<Map<String,dynamic>> call(
    String firstName,
    String lastName,
    String userName,
    String email,
    String password,
    String role,
  ) {
    return authRepository.signUp(
      firstName,
      lastName,
      userName,
      email,
      password,
      role,
    );
  }
}

