import 'package:fuel_finder/features/user/domain/repositories/user_repository.dart';

class GetUserByIdUsecase {
  final UserRepository userRepository;

  GetUserByIdUsecase({required this.userRepository});

  Future<Map<String, dynamic>> call(String userId) {
    return userRepository.getUserById(userId);
  }
}

