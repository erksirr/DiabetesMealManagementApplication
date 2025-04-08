import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:diabetes_meal_management_application_project/controllers/connection_controller.dart';

class DexcomController extends GetxController {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final ConnectionController connectionController = Get.find<ConnectionController>();
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    // checkDexcomStatusAndStartTimer();
  }

  void checkDexcomStatusAndStartTimer() {
    if (connectionController.isConnected.value) {
      print("‣ Start counting Dexcom token refresh.");
      _startPeriodicFetch();
    } else {
      print("⏸ Dexcom not connected, will not start token refresh.");
    }
  }

  Future<void> refreshAccessToken() async {
    const String clientId = "NRa7mw9Pr1zRN5774LCg5QO78pYTIxZC";
    const String clientSecret = "D9Xos0uceEDFv873";

    final String? refreshToken = await storage.read(key: "refresh_token");

    if (refreshToken == null) {
      print("❌ No refresh token available.");
      return;
    }

    final Uri tokenUri = Uri.parse("https://sandbox-api.dexcom.com/v2/oauth2/token");

    final response = await http.post(
      tokenUri,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {
        "client_id": clientId,
        "client_secret": clientSecret,
        "refresh_token": refreshToken,
        "grant_type": "refresh_token",
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      await storage.write(key: "access_token", value: data["access_token"]);
      await storage.write(key: "refresh_token", value: data["refresh_token"]);

      print("🔑 Token refreshed successfully!");

      connectionController.updateAccessToken(data["access_token"]); // Notify token update
    } else {
      print("❌ Error refreshing token: ${response.body}");
    }
  }

  void _startPeriodicFetch() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(minutes: 50), (_) async {
      print("🔄 Refreshing Dexcom Token...");
      await refreshAccessToken();
    });
  }

  void stopPeriodicFetch() {
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
      print("⏹️ Stopped Dexcom token refresh.");
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
