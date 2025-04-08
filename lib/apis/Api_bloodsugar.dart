import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:diabetes_meal_management_application_project/APIs/Api_middleware.dart';

class BloodsugarService {
  // static String pathUrl = 'ce67-37.cloud.ce.kmitl.ac.th';
  static String pathUrl = 'https://diabetes-project-454722.as.r.appspot.com';
  static Future<List<dynamic>> getAllBloodsugar() async {
    final response =
        await http.get(Uri.parse("$pathUrl/api/bloodsugar/all"));

    if (response.statusCode == 200) {
      return json.decode(response.body)["data"];
    } else {
      throw Exception("Failed to load blood sugar data");
    }
  }

  static Future<List<dynamic>> getBloodsugarByUserId() async {
    String? token = await MiddlewareService.getToken();
    if (token == null) throw Exception("Token ไม่พบ กรุณาเข้าสู่ระบบใหม่");
    final response = await http.get(
      Uri.parse("$pathUrl/api/bloodsugar/now"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body)["data"];
    } else {
      throw Exception("Failed to load user's blood sugar data");
    }
  }

  static Future<List<dynamic>> getDailyBloodsugarStats(String date) async {
    try {
      String? token = await MiddlewareService.getToken();
      if (token == null) throw Exception("Token ไม่พบ กรุณาเข้าสู่ระบบใหม่");

      final response = await http.get(
        Uri.parse("$pathUrl/api/bloodsugar/stats?date=$date"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      // print("po:${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Ensure "data" exists and is a list
        if (responseData.containsKey("data") && responseData["data"] is List) {
          return responseData["data"];
        } else {
          return []; // Return empty list if "data" is not available
        }
      } else {
        print("Error: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error fetching breakfast: $e");
      return [];
    }
  }

  static Future<List<dynamic>> getDailyBloodsugarGraph(String date) async {
    String? token = await MiddlewareService.getToken();
    if (token == null) throw Exception("Token ไม่พบ กรุณาเข้าสู่ระบบใหม่");
    final response = await http.get(
      Uri.parse("$pathUrl/api/bloodsugar/graph?date=$date"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body)["data"];
    } else {
      return [];
    }
  }

  static Future<List<dynamic>> getDailyBloodsugarPeriod(String date) async {
    String? token = await MiddlewareService.getToken();
    if (token == null) throw Exception("Token ไม่พบ กรุณาเข้าสู่ระบบใหม่");

    final response = await http.get(
      Uri.parse("$pathUrl/api/bloodsugar/period?date=$date"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      if (responseData.containsKey("data") && responseData["data"] is List) {
        return responseData["data"]; // ✅ Returns properly formatted list
      } else {
        return []; // Return empty list if "data" key is missing
      }
    } else {
      print("Error: ${response.statusCode}");
      return [];
    }
  }

  static Future<Map<String, dynamic>> createBloodsugar(
      int bloodSugarLevel) async {
    String? token = await MiddlewareService.getToken();
    if (token == null) throw Exception("Token ไม่พบ กรุณาเข้าสู่ระบบใหม่");
    final response = await http.post(
      Uri.parse("$pathUrl/api/bloodsugar/create"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", // ใช้ token ใน header
      },
      body: json.encode({
        "blood_sugar_level": bloodSugarLevel,
      }),
    );
    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to create blood sugar record");
    }
  }
}
