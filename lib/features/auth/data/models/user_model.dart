import 'package:fuel_finder/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.firstName,
    required super.lastName,
    required super.userName,
    required super.password,
    required super.email,
    required super.role,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      firstName: json["firstName"],
      lastName: json["lastName"],
      userName: json["userName"],
      password: json["password"],
      email: json["email"],
      role: json["role"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "first_name": firstName,
      "last_name": lastName,
      "username": userName,
      "password": password,
      "email": email,
      "role": "DRIVER",
    };
  }
}

