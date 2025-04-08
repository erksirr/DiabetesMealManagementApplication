import 'package:flutter/material.dart';
import 'package:diabetes_meal_management_application_project/components/noti/notiBox.dart';
import 'package:diabetes_meal_management_application_project/controllers/blood_sugar_check_controller.dart';
import 'package:get/get.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final BloodSugarCheckController bloodSugarCheckController =
      Get.find<BloodSugarCheckController>();

  void checkNotiBloodsugar() {
    bloodSugarCheckController.checkBloodSugarLevel();
  }

  String timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    print("difference:${difference}");
    if (difference.inMinutes < 1) {
      return 'ตอนนี้';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} นาทีที่แล้ว';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ชั่วโมงที่แล้ว';
    } else {
      final days = difference.inDays;
      return '$days วันที่แล้ว';
    }
  }

  @override
  void initState() {
    super.initState();
    // รอให้ context ถูกสร้างก่อน
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   checkNotiBloodsugar();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        elevation: 5,
        shadowColor: const Color.fromRGBO(0, 0, 0, 0.25),
        surfaceTintColor: Colors.transparent,
        title: const Text(
          "การแจ้งเตือน",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'NotoSansThai',
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Color.fromRGBO(241, 241, 241, 1),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Obx(() {
                return Expanded(
                  // ใช้ Expanded เพื่อให้ ListView.builder ขยายเต็มพื้นที่
                  child: ListView.builder(
                    shrinkWrap: true, // ไม่ให้ ListView ขยายเต็มที่
                    itemCount: bloodSugarCheckController.bloodSugarList.length,
                    itemBuilder: (context, index) {
                      final bloodSugarData = bloodSugarCheckController
                          .bloodSugarList.reversed
                          .toList()[index];
                      final bloodSugar = bloodSugarData['level'];
                      final time = bloodSugarData['timestamp'];
                      return Column(
                        children: [
                          Notibox(bloodSugar: bloodSugar, time: timeAgo(time)),
                          SizedBox(height: 16), // ระยะห่างระหว่าง NotiBox
                        ],
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
