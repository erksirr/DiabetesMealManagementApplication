import 'package:get/get.dart';
import 'package:diabetes_meal_management_application_project/APIs/Api_middleware.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:diabetes_meal_management_application_project/main.dart';
import 'package:diabetes_meal_management_application_project/components/auth/showerrordialog.dart';

class AuthService {
  // static String pathUrl = 'ce67-37.cloud.ce.kmitl.ac.th';
  static String pathUrl = 'https://diabetes-project-454722.as.r.appspot.com';
  static Future<void> login(
      BuildContext context, String email, String password) async {
    final url = Uri.parse('$pathUrl/api/user/auth/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      print('Status Code: \${response.statusCode}');
      print('Response Body: \${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        final String token = data['token'];
        await MiddlewareService.saveToken(token);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
          (route) => false, // ลบทุก Route ก่อนหน้า
        );
      } else {
        ShowErrorDialog.show(context, 'Login Failed', 'ข้อมูลไม่ถูกต้อง');
      }
    } catch (e) {
      print(e);
      ShowErrorDialog.show(context, 'Login Failed', 'เกิดข้อผิดพลาด');
    }
  }

  static Future<void> registerUser(
      BuildContext context, Map<String, dynamic> userData) async {
    final url = Uri.parse('$pathUrl/api/user/auth/register');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // ดึง email และ password ที่ผู้ใช้สมัครเพื่อเข้าสู่ระบบอัตโนมัติ
        final String email = userData['email'];
        final String password = userData['password'];

        // เรียกฟังก์ชัน login ทันทีหลังจากสมัครเสร็จ
        await login(context, email, password);
      } else {
        ShowErrorDialog.show(context, 'Registration Failed', response.body);
      }
    } catch (e) {
      print(e);
      ShowErrorDialog.show(
          context, 'Error', 'An error occurred. Please try again.');
    }
  }

  static Future<void> logout(BuildContext context) async {
    await MiddlewareService.removeToken(); // ลบ Token ออกจาก SharedPreferences
    Get.offAllNamed('/login'); // ใช้ GetX แทน Navigator
  }
}
