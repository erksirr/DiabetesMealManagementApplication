import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:diabetes_meal_management_application_project/components/backbutton.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uni_links/uni_links.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:diabetes_meal_management_application_project/components/profile/dexcombutton.dart';
import 'package:diabetes_meal_management_application_project/controllers/connection_controller.dart';

class ConnectToDexcom extends StatefulWidget {
  const ConnectToDexcom({super.key});

  @override
  State<ConnectToDexcom> createState() => _ConnectToDexcomState();
}

class _ConnectToDexcomState extends State<ConnectToDexcom> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final ConnectionController connectionController =
      Get.find<ConnectionController>();
  String? latestBloodSugar;
  bool isConnected = false;
  StreamSubscription<String?>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    checkDexcomConnection();

    if (kIsWeb) {
      _handleIncomingLinks(); // Handle web deep linking
    } else {
      _handleIncomingLinks(); // Set up linkStream for mobile
    }
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  // ใช้เพื่อรับข้อมูลจากลิงค์ที่ส่งมา
  void _handleIncomingLinks() {
    if (kIsWeb) {
      // Handle deep linking for web
      final Uri uri = Uri.base; // Get the current URL
      if (uri.queryParameters.containsKey("code")) {
        String authCode = uri.queryParameters["code"]!;
        exchangeCodeForToken(authCode);
      }
    } else {
      // Handle deep linking for mobile
      _linkSubscription = linkStream.listen((String? link) {
        if (link != null && link.contains("code=")) {
          String authCode = Uri.parse(link).queryParameters["code"]!;
          exchangeCodeForToken(authCode);
        }
      }, onError: (err) {
        print("❌ Error handling deep link: $err");
      });
    }
  }

  // ใช้เพื่อแลกเปลี่ยน code ให้เป็น token
  Future<void> exchangeCodeForToken(String authCode) async {
    const String clientId = "NRa7mw9Pr1zRN5774LCg5QO78pYTIxZC";
    const String clientSecret = "D9Xos0uceEDFv873";

    // Use proper redirect URIs for web and mobile
    final String redirectUri = kIsWeb
        ? "http://www.sugarplan.online" // Replace with your actual web redirect URI
        : "online.sugarplan.diabetes://callback"; // Replace with your actual mobile redirect URI

    final Uri tokenUri =
        Uri.parse("https://sandbox-api.dexcom.com/v2/oauth2/token");

    final response = await http.post(
      tokenUri,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {
        "client_id": clientId,
        "client_secret": clientSecret,
        "code": authCode,
        "grant_type": "authorization_code",
        "redirect_uri": redirectUri, // Ensure this matches your Dexcom API settings
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      await storage.write(key: "access_token", value: data["access_token"]);
      await storage.write(key: "refresh_token", value: data["refresh_token"]);

      if (mounted) {
        setState(() {
          isConnected = true;
        });
      }
      connectionController.setConnectionStatus(true);
      print("🦷 access token : $isConnected");
      print("access token : $data");
    } else {
      print("❌ Error exchanging code: ${response.body}");
    }
  }

  // ใช้เพื่อตรวจสอบการเชื่อมต่อกับ Dexcom
  Future<void> checkDexcomConnection() async {
    final accessToken = await storage.read(key: "access_token");
    if (accessToken != null) {
      if (mounted) {
        setState(() {
          isConnected = true;
        });
      }
      print("checking connection!!");
    }
  }

  Future<void> loginWithDexcom() async {
    const String clientId = "NRa7mw9Pr1zRN5774LCg5QO78pYTIxZC";

    // Use proper redirect URIs for web and mobile
    final String redirectUri = kIsWeb
        ? "http://www.sugarplan.online" // Replace with your actual web redirect URI
        : "online.sugarplan.diabetes://callback"; // Replace with your actual mobile redirect URI

    final String authUrl =
        "https://sandbox-api.dexcom.com/v2/oauth2/login?client_id=$clientId&redirect_uri=$redirectUri&response_type=code&scope=offline_access%20egvs";

    if (await canLaunchUrl(Uri.parse(authUrl))) {
      await launchUrl(Uri.parse(authUrl), mode: LaunchMode.externalApplication);
    } else {
      print("❌ Could not launch Dexcom Login URL");
    }
  }

  // Future<void> fetchLatestBloodSugar(String token) async {
  //   final DateTime now = DateTime.now().toUtc();
  //   final DateTime startTime = now.subtract(const Duration(hours: 24));

  //   final String formattedStartTime =
  //       DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(startTime);
  //   final String formattedEndTime =
  //       DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(now);

  //   final Uri glucoseUri = Uri.parse(
  //     "https://sandbox-api.dexcom.com/v3/users/self/egvs?startDate=$formattedStartTime&endDate=$formattedEndTime",
  //   );

  //   final response = await http.get(
  //     glucoseUri,
  //     headers: {
  //       "Authorization": "Bearer $token",
  //       "Content-Type": "application/json",
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //     if (data["records"].isNotEmpty) {
  //       final bloodSugarValue =
  //           double.tryParse("${data["records"].first["value"]}");
  //       if (mounted) {
  //         setState(() {
  //           latestBloodSugar = "$bloodSugarValue mg/dL";
  //         });
  //       }

  //       if (bloodSugarValue != null) {
  //         Get.find<BloodSugarController>().bloodSugar.value = bloodSugarValue;
  //       }
  //       connectionController.setConnectionStatus(true);
  //       print("🦷 Latest blood sugar fetched: $latestBloodSugar mg/dL");
  //     }
  //   } else {
  //     print("❌ Error fetching glucose data: ${response.body}");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "เชื่อมต่อกับอุปกรณ์",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        leading: Backbutton(onPressed: () => Navigator.pop(context)),
      ),
      body: Container(
        color: Color.fromRGBO(241, 241, 241, 1),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ConnectToDexcomButton(
                title: "เชื่อมต่อกับ Dexcom",
                buttonColor: Colors.white,
                icon: isConnected
                    ? Icons.toggle_on_outlined
                    : Icons.toggle_off_outlined, // เปลี่ยน icon ตามสถานะ
                onPressed: () async {
                  if (isConnected) {
                    await connectionController.disconnectDexcom();
                    if (mounted) {
                      setState(() {
                        isConnected = false;
                        latestBloodSugar = null;
                      });
                    }
                  } else {
                    loginWithDexcom();
                  }
                },
                isConnected: isConnected,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
