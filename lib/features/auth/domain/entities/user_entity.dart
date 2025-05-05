abstract class UserEntity {
  final String firstName;
  final String lastName;
  final String userName;
  final String password;
  final String email;
  final String role;

  UserEntity({
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.password,
    required this.email,
    required this.role,
  });
}

