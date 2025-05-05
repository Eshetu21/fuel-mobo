import 'package:fuel_finder/features/auth/domain/repositories/auth_repository.dart';

class SigninUsecase {
  final AuthRepository authRepository;

  SigninUsecase({required this.authRepository});
  Future<Map<String,dynamic>> call(String userName, String password) {
    return authRepository.signIn(userName, password);
  }
}

