import 'dart:convert';
import 'package:http/http.dart' as http;

class MenuService {
  static String pathUrl = 'https://diabetes-project-454722.as.r.appspot.com';
  static Future<Map<String, dynamic>?> getMenuRecommend() async {
    try {
      final response =
          await http.get(Uri.parse("$pathUrl/api/menus/recommend"));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print("Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error fetching menu: $e");
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>?> getSearchMenu(
      {required int categoryId,
      required String search,
      required List<int> cooking_type_Id,
      required int? color}) async {
    try {
      // แปลง cooking_type_Id เป็นสตริงที่คั่นด้วยเครื่องหมายคอมมา
      String cookingTypeIds = cooking_type_Id.join(',');
      // print(categoryId);
      // print(search);
      // print(cooking_type_Id);
      // print(color);
      // ส่ง request ไปยัง API พร้อมค่าต่างๆ
      final response = await http.get(
        Uri.parse(
            "$pathUrl/api/menus/search?category_id=$categoryId&search=$search&cooking_type_id=$cookingTypeIds&color=$color"), // ส่ง category_id, search และ cooking_type_id
      );
      // print(response.body);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data["menu"]);
      } else {
        // print("Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      // print("Error fetching menu: $e");
      return null;
    }
  }
 static Future<Map<String, dynamic>?> getDetailMenu({
  required String menu_id,
}) async {
  try {
    final response = await http.get(
      Uri.parse("$pathUrl/api/menus/detail/$menu_id"),
    );
    // print("response.body:${response.body}");
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      print("Error: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Error fetching menu: $e");
    return null;
  }
}
}
