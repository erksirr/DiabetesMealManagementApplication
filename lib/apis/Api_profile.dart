import 'package:diabetes_meal_management_application_project/APIs/Api_middleware.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Profile {
  // ✅ ดึงข้อมูลผู้ใช้จาก Token
  static String pathUrl = 'https://diabetes-project-454722.as.r.appspot.com';
  static Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      String? token = await MiddlewareService.getToken();
      if (token == null) throw Exception("Token ไม่พบ กรุณาเข้าสู่ระบบใหม่");
      // print("token:${token}");

      var url = Uri.parse('$pathUrl/api/user/info');

      var response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );
      // print("responce:${response.body}");
      // print("status:${response.statusCode}");
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Error: ${response.body}");
      }
    } catch (e) {
      print("getUserProfile Error: $e");
      return null;
    }
  }

  // ✅ อัปเดตข้อมูลผู้ใช้
  static Future<bool> updateUserProfile(
      Map<String, dynamic> updatedData) async {
    try {
      String? token = await MiddlewareService.getToken();
      if (token == null) throw Exception("Token ไม่พบ กรุณาเข้าสู่ระบบใหม่");


      var url = Uri.parse('$pathUrl/api/user/info/update');

      var response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception("Error: ${response.body}");
      }
    } catch (e) {
      print("updateUserProfile Error: $e");
      return false;
    }
  }

  static Future<bool> changePassword(
      String newPassword, String oldPassword) async {
    try {
      String? token = await MiddlewareService.getToken();
      if (token == null) throw Exception("Token ไม่พบ กรุณาเข้าสู่ระบบใหม่");

      var url = Uri.parse(
          '$pathUrl/api/user/change-password'); // แก้ไข endpoint ตาม API จริง
      var response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
            {"newPassword": newPassword, "oldPassword": oldPassword}),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception("Error: ${response.body}");
      }
    } catch (e) {
      print("changePassword Error: $e");
      return false;
    }
  }

  static Future<bool> verifyCurrentPassword(String enteredPassword) async {
    try {
      String? token = await MiddlewareService.getToken();
      if (token == null) throw Exception("Token ไม่พบ กรุณาเข้าสู่ระบบใหม่");

      var url = Uri.parse('$pathUrl/api/user/verify-password');
      var response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"password": enteredPassword}),
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data['verifyUser'][
            'valid']; // assuming the backend sends 'valid: true' if the password matches
      } else {
        throw Exception("Error: ${response.body}");
      }
    } catch (e) {
      print("verifyCurrentPassword Error: $e");
      return false;
    }
  }

  static Future<Map<String, dynamic>?> calculateCalories() async {
    try {
      String? token = await MiddlewareService.getToken();
      if (token == null) throw Exception("Token ไม่พบ กรุณาเข้าสู่ระบบใหม่");

      var url = Uri.parse('$pathUrl/api/user/info/calculate_calories');
      var response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Error: ${response.body}");
      }
    } catch (e) {
      print("calculateCalories Error: $e");
      return null;
    }
  }
}
