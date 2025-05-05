abstract class AuthRepository {
  Future<Map<String, dynamic>> signUp(
    String firstName,
    String lastName,
    String userName,
    String email,
    String password,
    String role,
  );
  Future<Map<String, dynamic>> signIn(String userName, String password);
  Future<void> logOut();
  Future<void> verifyEmail(String userId, String token);
}
