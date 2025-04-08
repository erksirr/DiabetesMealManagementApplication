import 'package:shared_preferences/shared_preferences.dart';

class MiddlewareService {
  static const String _tokenKey = 'auth_token';

  /// ดึง Token จาก SharedPreferences
  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// บันทึก Token ลงใน SharedPreferences
  static Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    print('Saved Token: $token');
  }

  /// ลบ Token ออกจาก SharedPreferences
  static Future<void> removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    print('Token removed');
  }
}
