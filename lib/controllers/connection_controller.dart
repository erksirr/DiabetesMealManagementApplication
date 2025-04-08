import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:diabetes_meal_management_application_project/controllers/dexcom_controller.dart';
import 'package:diabetes_meal_management_application_project/controllers/blood_sugar_controller.dart';

class ConnectionController extends GetxController {
  var isConnected = false.obs;
  var accessToken = ''.obs; // Reactive variable for access token
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  void onInit() {
    super.onInit();
    clearSession();
  }

  Future<void> checkDexcomConnection() async {
    final token = await storage.read(key: "access_token");

    if (token != null) {
      print("🔋 Dexcom is connected at app start.");
      isConnected.value = true;
      accessToken.value = token; // Update reactive access token
      Get.find<DexcomController>().checkDexcomStatusAndStartTimer();
      Get.find<BloodSugarController>().checkDexcomStatusAndStartFetch();
    } else {
      print("🪫 Dexcom not connected at app start.");
      isConnected.value = false;
      accessToken.value = ""; // Clear the access token
    }
  }

  Future<void> clearSession() async {
    final token = await storage.read(key: "access_token");
    final active = token != null ? true : false;
    print("📡 Session is active: ${active}");

    if (active) {
      print("🧹 Clearing Dexcom session...");
      disconnectDexcom();
      print("✅ Dexcom session cleared.");
    } else {
      print("🚫 No session to clear.");
    }

    // checkDexcomConnection();
  }

  void setConnectionStatus(bool status) {
  print("🔄 Dexcom connection status updated: $status");

    if (!status) {
      print("🚨 Stopping all timers BEFORE updating state...");
      Get.find<DexcomController>().stopPeriodicFetch();
      Get.find<BloodSugarController>().stopPeriodicFetch();
      checkDexcomConnection();
      print("");
    }

    isConnected.value = status;

    if (status) {
      print("▶ Starting Dexcom services...");
      Get.find<DexcomController>().checkDexcomStatusAndStartTimer();
      Get.find<BloodSugarController>().checkDexcomStatusAndStartFetch();
    }
  }

  void updateAccessToken(String token) {
    accessToken.value = token; // Notify listeners when the token is updated
    print("🔑 Access token updated: $token");
  }

  Future<void> disconnectDexcom() async {
    await storage.delete(key: "access_token");
    await storage.delete(key: "refresh_token");
    setConnectionStatus(false); // Directly update the connection state
    print("🔌 Dexcom disconnected.");
  }
}
