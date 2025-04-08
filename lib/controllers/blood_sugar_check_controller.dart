import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diabetes_meal_management_application_project/controllers/blood_sugar_controller.dart';

class BloodSugarCheckController extends GetxController {
  final BloodSugarController bloodSugarController =
      Get.find<BloodSugarController>();

  // รายการ bloodSugar ที่อัปเดต
  var bloodSugarList = <Map<String, dynamic>>[].obs;

  // ฟังก์ชันตรวจสอบระดับน้ำตาลในเลือด
void checkBloodSugarLevel() {
  final bloodSugarLevel = bloodSugarController.bloodSugar.value;
  final timestamp = DateTime.now(); // Capture the current time
  print("😈 Checking blood sugar level: $bloodSugarLevel mg/dL");

  if ((bloodSugarLevel < 70 || bloodSugarLevel > 180)) {
    triggerOutOfRangeNotification(bloodSugarLevel, timestamp);
    logNotification(bloodSugarLevel);
    // เพิ่มค่าที่ตรวจพบเข้าไปในรายการ
    bloodSugarList.add({
      'level': bloodSugarLevel,
      'timestamp': timestamp, // เก็บ timestamp สำหรับแต่ละการตรวจ
    });
  }
}

  // Getter สำหรับ timestamp
  DateTime get timestamp {
    return DateTime.now();
  }

  // ฟังก์ชันแจ้งเตือนเมื่อระดับน้ำตาลผิดปกติ
  void triggerOutOfRangeNotification(double bloodSugarLevel, DateTime timestamp) {
    String fontFamily = 'NotoSansThai';
    List<String> recommend = [];

    String checkBloodSugarLeveltoString() {
      // เริ่มต้นคำแนะนำเป็นค่าว่าง
      recommend.clear();

      if (bloodSugarLevel < 50) {
        recommend
            .add("รีบทานของว่างที่มีคาร์โบไฮเดรต เช่น น้ำผลไม้ หรือขนมปัง");
        return 'ระดับน้ำตาลของคุณอยู่ในระดับอันตราย!';
      } else if (bloodSugarLevel < 70) {
        recommend
            .add("รีบทานของว่างที่มีคาร์โบไฮเดรต เช่น น้ำผลไม้ หรือขนมปัง");
        return 'ระดับน้ำตาลในเลือดของคุณต่ำกว่าปกติ!';
      } else if (bloodSugarLevel >= 70 && bloodSugarLevel <= 100) {
        return 'ระดับน้ำตาลในเลือดของคุณปกติ';
      } else if (bloodSugarLevel > 100 && bloodSugarLevel <= 180) {
        return 'ระดับน้ำตาลในเลือดของคุณปกติ';
      } else if (bloodSugarLevel > 180 && bloodSugarLevel <= 300) {
        recommend.add("ดื่มน้ำเปล่ามากขึ้น");
        recommend.add("ออกกำลังกายเบา ๆ");
        recommend.add("ตรวจเช็คอาหารที่ทานเข้าไป");
        return 'ระดับน้ำตาลของคุณสูงเกินไป!';
      } else {
        recommend.add("โปรดติดต่อแพทย์ทันที");
        recommend.add("ไปโรงพยาบาลหากมีอาการผิดปกติ");
        return 'ระดับน้ำตาลของคุณอยู่ในระดับอันตราย!';
      }
    }

    print("❗ น้ำตาลในเลือดเกินขีดจำกัด: $bloodSugarLevel mg/dL");
    Get.snackbar(
      "",
      "",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.white,
      colorText: Colors.red,
      borderRadius: 10,
      margin: EdgeInsets.all(10),
      duration: Duration(seconds: 10), // เวลาที่แสดง snackbar
      isDismissible: true, // ปิดได้ด้วยการ swipe
      forwardAnimationCurve: Curves.easeOutBack, // Animation ตอนแสดง
      reverseAnimationCurve: Curves.easeInBack,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3), // สีเงา
          spreadRadius: 2, // ขนาดการกระจายของเงา
          blurRadius: 10, // ความเบลอของเงา
          offset: Offset(4, 4), // การเลื่อนตำแหน่งเงา (X, Y)
        ),
      ],
      titleText: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            checkBloodSugarLeveltoString(), // ข้อความ Title
            style: TextStyle(
              fontSize: 18, // กำหนดขนาดใหญ่ขึ้น
              fontWeight: FontWeight.bold, // ตัวหนา
              fontFamily: 'NotoSansThai',
              color: Colors.black, // สีของ Title
            ),
          ),
          Divider(
            color: Color.fromRGBO(255, 51, 0, 1),
            indent: 2,
            endIndent: 2,
          ),
        ],
      ),
      messageText: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset("asset/im/blood_red.png"),
              SizedBox(
                width: 14,
              ),
              Text(
                "ค่าระดับน้ำตาลคือ", // ข้อความรายละเอียด
                style: TextStyle(
                  fontSize: 14, // ขนาดเล็กกว่า Title
                  fontFamily: 'NotoSansThai',
                  color: Colors.black, // สีข้อความปกติ
                ),
              ),
              SizedBox(
                width: 6,
              ),
              Text(
                "$bloodSugarLevel", // ข้อความรายละเอียด
                style: TextStyle(
                  fontSize: 16, // ขนาดเล็กกว่า Title
                  fontFamily: 'NotoSansThai',
                  color: Colors.red, // สีข้อความปกติ
                ),
              ),
              SizedBox(
                width: 6,
              ),
              Text("มิลลิกรัม/เดซิลิตร", // ข้อความรายละเอียด
                  style: TextStyle(
                    fontSize: 14, // ขนาดเล็กกว่า Title
                    fontFamily: 'NotoSansThai',
                    color: Colors.black, // สีข้อความปกติ
                  ))
            ],
          ),
          checkBloodSugarLeveltoString() != 'ระดับน้ำตาลในเลือดของคุณปกติ'
              ? SizedBox(
                  height: 16,
                )
              : SizedBox.shrink(),
          checkBloodSugarLeveltoString() != 'ระดับน้ำตาลในเลือดของคุณปกติ'
              ? Row(
                  children: [
                    Text("คำแนะนำ",
                        style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600,
                          fontFamily: 'NotoSansThai',
                          decoration:
                              TextDecoration.underline, // ✅ เพิ่มเส้นใต้
                          decorationColor: Colors.black, // 🔴 สีของเส้นใต้
                          decorationThickness: 1,
                        )) // 📏 ความหนาของเส้นใต้),)
                  ],
                )
              : SizedBox.shrink(),
          checkBloodSugarLeveltoString() != 'ระดับน้ำตาลในเลือดของคุณปกติ'
              ? SizedBox(
                  height: 10,
                )
              : SizedBox.shrink(),
          checkBloodSugarLeveltoString() != 'ระดับน้ำตาลในเลือดของคุณปกติ'
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: recommend.map((item) {
                    return Text(
                      "   \u2022 $item", // \u2022 คือ Unicode สำหรับจุดหัวข้อ
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'NotoSansThai',
                      ),
                    );
                  }).toList(),
                )
              : SizedBox.shrink()
        ],
      ), // ความหนาของขอบ // Animation ตอนซ่อน
    );
  }

  // ฟังก์ชันบันทึกการแจ้งเตือน
  void logNotification(double bloodSugarLevel) {
    print(
        "📝 บันทึกการแจ้งเตือนสำหรับระดับน้ำตาลเกินขีดจำกัด: $bloodSugarLevel mg/dL");
  }
}
