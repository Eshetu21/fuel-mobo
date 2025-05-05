import 'package:fuel_finder/features/user/data/datasources/user_remote_data_source.dart';
import 'package:fuel_finder/features/user/domain/repositories/user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  final UserRemoteDataSource userRemoteDataSource;

  UserRepositoryImpl({required this.userRemoteDataSource});
  @override
  Future<Map<String, dynamic>> getUserById(String userId) {
    return userRemoteDataSource.getUserById(userId);
  }
}

