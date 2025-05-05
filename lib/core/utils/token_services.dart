import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  static const _tokenKey = 'auth_token';
  static const _userIdKey = 'user_id';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final SharedPreferences? _prefs;

  TokenService(this._prefs);

  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  Future<String> getAuthToken() async {
    final token = await getToken();
    if (token == null) {
      throw 'No authentication token found';
    }
    return token;
  }

  Future<void> saveUserId(String userId) async {
    await _prefs?.setString(_userIdKey, userId);
  }

  String? getUserId() {
    return _prefs?.getString(_userIdKey);
  }

  Future<void> clearAll() async {
    await _secureStorage.delete(key: _tokenKey);
    await _prefs?.remove(_userIdKey);
  }

  static const _seenOnboardingKey = 'seen_onboarding';

  bool? getSeenOnboarding() {
    return _prefs?.getBool(_seenOnboardingKey);
  }

  Future<void> setSeenOnboarding(bool value) async {
    await _prefs?.setBool(_seenOnboardingKey, value);
  }
}
