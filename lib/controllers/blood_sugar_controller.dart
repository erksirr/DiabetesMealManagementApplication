import 'package:get/get.dart';
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:diabetes_meal_management_application_project/controllers/connection_controller.dart';
import 'package:diabetes_meal_management_application_project/apis/Api_bloodsugar.dart';
import 'package:diabetes_meal_management_application_project/controllers/blood_sugar_check_controller.dart';

class BloodSugarController extends GetxController {
  var bloodSugar = 0.0.obs;
  var bloodSugarTimestamp = "".obs; // เก็บ timestamp ของค่าที่ fetch มา
  Timer? _timer;
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final ConnectionController connectionController =
      Get.find<ConnectionController>();
  String? _currentToken;

  @override
  void onInit() {
    super.onInit();
    // checkDexcomStatusAndStartFetch();

    connectionController.accessToken.listen((newToken) {
      if (newToken.isNotEmpty) {
        _currentToken = newToken;
      }
    });
  }

  void checkDexcomStatusAndStartFetch() {
    if (connectionController.isConnected.value) {
      print("‣ Start count Fetching BloodSugar");
      _startPeriodicFetch();
    } else {
      print("⏸ Dexcom not connected, will not start blood sugar fetching.");
    }
  }

  void setBloodSugar(double value) {
    if (bloodSugar.value != value) {
      // Only update and trigger check if the value has changed
      bloodSugar.value = value;
      print("🩸 Blood Sugar Updated: $value mg/dL");

      Get.find<BloodSugarCheckController>().checkBloodSugarLevel();
    } else {
      print("⏹️ Blood Sugar value unchanged: $value mg/dL");
    }
  }

  Future<void> _startPeriodicFetch() async {
    _timer?.cancel();
    _currentToken = await storage.read(key: "access_token");
    if (_currentToken != null) {
      fetchLatestBloodSugar();
      _timer = Timer.periodic(Duration(minutes: 5), (_) {
        fetchLatestBloodSugar();
      });
    }
  }

  Future<void> fetchLatestBloodSugar() async {
    if (_currentToken == null) {
      print("❌ No access token available to fetch blood sugar data.");
      return;
    }

    final DateTime now = DateTime.now().toUtc();
    final DateTime startTime = now.subtract(const Duration(hours: 24));

    final String formattedStartTime =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(startTime);
    final String formattedEndTime =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(now);

    final Uri glucoseUri = Uri.parse(
      "https://sandbox-api.dexcom.com/v3/users/self/egvs?startDate=$formattedStartTime&endDate=$formattedEndTime",
    );

    try {
      final response = await http.get(
        glucoseUri,
        headers: {
          "Authorization": "Bearer $_currentToken",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["records"].isNotEmpty) {
          final bloodSugarValue =
              double.tryParse("${data["records"].first["value"]}") ?? 0.0;
          final String rawTimestamp = data["records"].first["systemTime"];
          print(
              "🔍 Raw systemTime from API: $rawTimestamp"); // ตรวจสอบค่าจริงก่อน

          final DateTime timestampUtc = DateTime.parse(rawTimestamp);
          final DateTime timestampLocal =
              timestampUtc.toLocal(); // ใช้เวลาเครื่อง

// เพิ่ม 1 ชั่วโมง
          final DateTime adjustedTime = timestampLocal.add(Duration(hours: 1));

          final String formattedTime = DateFormat("HH:mm").format(adjustedTime);

          bloodSugarTimestamp.value = formattedTime; // อัปเดต timestamp
          setBloodSugar(bloodSugarValue); // trigger the check

          print("🕒 Blood Sugar Time (Local): ${bloodSugarTimestamp.value}");
          await saveBloodSugarToDatabase(bloodSugarValue);
        }
      } else {
        print("❌ Error fetching glucose data: ${response.body}");
      }
    } catch (e) {
      print("❌ Exception during fetch: $e");
    }
  }

  Future<void> saveBloodSugarToDatabase(double value) async {
    try {
      print("📩 Sending Blood Sugar Data: { 'blood_sugar_level': $value }");

      final response = await BloodsugarService.createBloodsugar(value.toInt());

      print("📝 API Response: ${response}");
      print("✅ Blood sugar record successfully saved");
    } catch (e) {
      print("❌ Failed to save blood sugar record: $e");
    }
  }

  void stopPeriodicFetch() {
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
      print("⏹️ Stopped Blood Sugar fetching.");
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
