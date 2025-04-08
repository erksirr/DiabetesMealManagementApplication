import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:diabetes_meal_management_application_project/APIs/Api_middleware.dart';

class DaymealService {
  // static String pathUrl = 'ce67-37.cloud.ce.kmitl.ac.th';
  static String pathUrl = 'https://diabetes-project-454722.as.r.appspot.com';
  static Future<Map<String, dynamic>?> upsertMeal({
    required String date,
    required String mealType,
    required List<String> menuIds,
  }) async {
    try {
      // ดึง token จาก MiddlewareService
      String? token = await MiddlewareService.getToken();
      if (token == null) throw Exception("Token ไม่พบ กรุณาเข้าสู่ระบบใหม่");
      final response = await http.put(

        Uri.parse("$pathUrl/api/daymeal/plan"),

        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // ใช้ token ใน header
        },
        body: json.encode({
          "date": date,
          "mealType": mealType,
          "menuIds": menuIds,
        }),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print("Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error upserting meal: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> checkEatMeal({
    required String mealType,
    required String mealId,
  }) async {
    try {
      // ดึง token จาก MiddlewareService
      String? token = await MiddlewareService.getToken();
      if (token == null) throw Exception("Token ไม่พบ กรุณาเข้าสู่ระบบใหม่");
      final response = await http.put(
        Uri.parse("$pathUrl/api/daymeal/meal/checkeat"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // ใช้ token ใน header
        },
        body: json.encode({"mealType": mealType, "mealId": mealId}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print("Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error upserting meal: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getDayMeal({
    required String date,
  }) async {
    try {
      String? token = await MiddlewareService.getToken();
      if (token == null) throw Exception("Token ไม่พบ กรุณาเข้าสู่ระบบใหม่");

      final response = await http.get(

        Uri.parse("$pathUrl/api/daymeal/info?date=$date"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body); // Return the meal data
      } else {
        print("Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error fetching day meal: $e");
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>?> getHistoryMenu({
    required num categoryId,
    required String date,
  }) async {
    try {
      // ดึง token จาก MiddlewareService
      String? token = await MiddlewareService.getToken();
      if (token == null) throw Exception("Token ไม่พบ กรุณาเข้าสู่ระบบใหม่");

      final response = await http.get(
        Uri.parse(

            "$pathUrl/api/daymeal/history/menu?category_id=$categoryId&date=$date"),

        headers: {
          "Authorization": "Bearer $token", // ใช้ token ใน header
        },
      );

      if (response.statusCode == 200) {
        // Decode JSON
        Map<String, dynamic> decodedResponse = json.decode(response.body);
        if (decodedResponse.containsKey("menu") &&
            decodedResponse["menu"] is List) {
          return List<Map<String, dynamic>>.from(decodedResponse["menu"]);
        } else {
          print("Error: Response does not contain a valid 'menu' list.");
          return null;
        }
      } else {
        print("Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error fetching history menu: $e");
      return null;
    }
  }

  // ฟังก์ชันสำหรับดึงข้อมูลมื้ออาหารเช้า
  static Future<dynamic> getBreakfast(String date) async {
    try {
      String? token = await MiddlewareService.getToken();
      if (token == null) throw Exception("Token ไม่พบ กรุณาเข้าสู่ระบบใหม่");
      final response = await http.get(

        Uri.parse("$pathUrl/api/daymeal/plan/breakfast?date=$date"),

        headers: {
          "Authorization": "Bearer $token", // ใช้ token
        },
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print("Error Fetch Breakfast: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error fetching breakfast: $e");
      return null;
    }
  }

  static Future<dynamic> getLunch(String date) async {
    try {
      String? token = await MiddlewareService.getToken();
      if (token == null) throw Exception("Token ไม่พบ กรุณาเข้าสู่ระบบใหม่");
      final response = await http.get(

        Uri.parse("$pathUrl/api/daymeal/plan/lunch?date=$date"),
        
        headers: {
          "Authorization": "Bearer $token", // ใช้ token
        },
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print("Error Fetch Lunch: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error fetching breakfast: $e");
      return null;
    }
  }

  static Future<dynamic> getDinner(String date) async {
    try {
      String? token = await MiddlewareService.getToken();
      if (token == null) throw Exception("Token ไม่พบ กรุณาเข้าสู่ระบบใหม่");
      final response = await http.get(

        Uri.parse("$pathUrl/api/daymeal/plan/dinner?date=$date"),

        headers: {
          "Authorization": "Bearer $token", // ใช้ token
        },
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print("Error Fetch Dinner: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error fetching breakfast: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getNutritionPlan({
    required String date,
  }) async {
    try {
      // ดึง token จาก MiddlewareService
      String? token = await MiddlewareService.getToken();
      if (token == null) throw Exception("Token ไม่พบ กรุณาเข้าสู่ระบบใหม่");

      final response = await http.get(
        Uri.parse(

            "$pathUrl/api/daymeal/plan/nutrition?date=$date"),

        headers: {
          "Authorization": "Bearer $token", // ใช้ token ใน header
        },
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print("Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error fetching nutrition summary: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getNutritionHistory({
    required String date,
  }) async {
    try {
      // ดึง token จาก MiddlewareService
      String? token = await MiddlewareService.getToken();
      if (token == null) throw Exception("Token ไม่พบ กรุณาเข้าสู่ระบบใหม่");

      final response = await http.get(
        Uri.parse(

            "$pathUrl/api/daymeal/history/nutrition?date=$date"),

        headers: {
          "Authorization": "Bearer $token", // ใช้ token ใน header
        },
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print("Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error fetching nutrition summary: $e");
      return null;
    }
  }
}
