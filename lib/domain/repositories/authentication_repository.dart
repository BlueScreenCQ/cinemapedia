abstract class AuthenticationRepository {
  Future<bool> loginUser(Map<String, dynamic> params);
  Future<void> logoutUser();
}
