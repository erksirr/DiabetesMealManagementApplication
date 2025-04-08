import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:diabetes_meal_management_application_project/apis/Api_daymeal.dart';
import 'package:diabetes_meal_management_application_project/apis/Api_profile.dart';
import 'package:diabetes_meal_management_application_project/components/auth/bmi_category_box.dart';
import 'package:diabetes_meal_management_application_project/components/home/bloodsugarlevel.dart';
import 'package:diabetes_meal_management_application_project/components/home/planmealbutton.dart';
import 'package:diabetes_meal_management_application_project/controllers/connection_controller.dart';
import 'package:diabetes_meal_management_application_project/pages/home/allmeal.dart';
import 'package:diabetes_meal_management_application_project/components/home/bmi_card.dart';
import 'package:diabetes_meal_management_application_project/components/nutritioncard.dart';
import 'package:get/get.dart';
import 'package:diabetes_meal_management_application_project/controllers/blood_sugar_controller.dart';

class PlanPage extends StatefulWidget {
  const PlanPage({super.key});

  @override
  State<PlanPage> createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {
  DateTime selectedDate = DateTime.now();
  DateTime effectiveDate = DateTime.now().hour > 19 
      ? DateTime.now().add(Duration(days: 1))
      : DateTime.now();
  Map<String, dynamic>? nutritionData;
  String selectedText = "";
  Map<String, dynamic>? userData;
  Map<int, List<Map<String, dynamic>>> mealData = {};
  List<Map<String, dynamic>> mealPlans = [];
  List<dynamic> mealDataList = [];
  String isPlanedBreakfast = "b";
  String isPlanedLunch = "b";
  String isPlanedDinner = "b";
  bool isEatenBreakfast = false;
  bool isEatenLunch = false;
  bool isEatenDinner = false;
  double calories = 0;
  double weight = 0;
  double height = 0;
  double bmi = 0; // Changed to double for accuracy
  double maxEnergy = 0; // Add a state variable for maxEnergy

  double carbohydrate = 0;
  double sugar = 0;
  double fat = 0;
  double sodium = 0;
  double protein = 0;
  int selectedIndex = 0;
  @override
  void initState() {
    fetchData();

    super.initState();
  }

  void fetchData() {
    // for (int id = 1; id <= 3; id++) {
    initializeDateFormatting('th').then((_) {
      setState(() {
        selectedText = DateFormat("d MMMM", "th").format(selectedDate) +
            " ${selectedDate.year + 543}"; // บวก 543 ให้ปี
      });
    });
    _getCheckisPlannedToday();
    _getNutritionData(); // Fetch the nutrition summary as well
    loadUserProfile();
    fetchMaxEnergy(); // Fetch maxEnergy (TDEE) value
    _getCheckisPlanned7Date();

    // }
  }

  Future<void> _getCheckisPlannedToday() async {
    String date = DateFormat('yyyy-MM-dd').format(selectedDate);
    var data = await DaymealService.getDayMeal(date: date);

    // Print the full data to check the response structure
    // print("plan data: $data");

    // Extract breakfast, lunch, and dinner data
    var breakfastData = data?["data"]?["breakfast"];
    var lunchData = data?["data"]?["lunch"];
    var dinnerData = data?["data"]?["dinner"];

    isEatenBreakfast = data?["data"]?["breakfast"]?["check_eat"] ?? false;
    isEatenLunch = data?["data"]?["lunch"]?["check_eat"] ?? false;
    isEatenDinner = data?["data"]?["dinner"]?["check_eat"] ?? false;

    if (mounted) {
      setState(() {
        isPlanedBreakfast = (breakfastData != null &&
                breakfastData["menu_id"] != null &&
                breakfastData["menu_id"].isNotEmpty)
            ? "a"
            : "b";
        isPlanedLunch = (lunchData != null &&
                lunchData["menu_id"] != null &&
                lunchData["menu_id"].isNotEmpty)
            ? "a"
            : "b";
        isPlanedDinner = (dinnerData != null &&
                dinnerData["menu_id"] != null &&
                dinnerData["menu_id"].isNotEmpty)
            ? "a"
            : "b";
        if (isEatenBreakfast) {
          isPlanedBreakfast = "c";
        }
        if (isEatenLunch) {
          isPlanedLunch = "c";
        }
        if (isEatenDinner) {
          isPlanedDinner = "c";
        }
        print("selectedDate.day:${selectedDate.day}");
        print("effectiveDate.day:${effectiveDate.day}");
        if (DateTime.now().day == selectedDate.day) {
          if (selectedDate.day != effectiveDate.day) {
            isPlanedBreakfast = "d";
            isPlanedLunch = 'd';
            isPlanedDinner = 'd';
          }
        }

        // print("isPlanedBreakfast:${isPlanedBreakfast}");
        // print("isPlanedLunch:${isPlanedLunch}");
        // print("isPlanedDinner:${isPlanedDinner}");
      });
    }
  }

  Future<void> _getCheckisPlanned7Date() async {
    List<Map<String, dynamic>> tempMealPlans = [];

    List<Future<Map<String, dynamic>>> fetchRequests =
        List.generate(7, (i) async {
      DateTime targetDate = DateTime.now().add(Duration(days: i));
      String date = DateFormat('yyyy-MM-dd').format(targetDate);

      var data = await DaymealService.getDayMeal(date: date);

      return {
        "date": date, // เก็บวันที่ไว้ด้วย
        "isPlanedBreakfast": (data != null &&
                data["data"]?["breakfast"]?["menu_id"] != null &&
                data["data"]["breakfast"]["menu_id"].isNotEmpty)
            ? "a"
            : "b",
        "isPlanedLunch": (data != null &&
                data["data"]?["lunch"]?["menu_id"] != null &&
                data["data"]["lunch"]["menu_id"].isNotEmpty)
            ? "a"
            : "b",
        "isPlanedDinner": (data != null &&
                data["data"]?["dinner"]?["menu_id"] != null &&
                data["data"]["dinner"]["menu_id"].isNotEmpty)
            ? "a"
            : "b",
      };
    });

    tempMealPlans = await Future.wait(fetchRequests);

    // เรียงลำดับตามวันที่ (จากวันนี้ไปอนาคต)
    tempMealPlans.sort((a, b) => a["date"].compareTo(b["date"]));

    if (mounted) {
      setState(() {
        mealPlans = tempMealPlans;
      });
    }
  }

  Future<void> _getNutritionData() async {
    String date = DateFormat('yyyy-MM-dd').format(selectedDate);
    var data = await DaymealService.getNutritionPlan(date: date);

    if (mounted) {
      setState(() {
        nutritionData =
            data?["menu"]["nutrition"]; // Store nutrition data when fetched

        if (nutritionData != null) {
          calories = double.parse(
              (nutritionData?['calories']?['amount'] ?? 0).toStringAsFixed(2));
          carbohydrate = double.parse(
              (nutritionData?['carbohydrate']?['amount'] ?? 0)
                  .toStringAsFixed(2));
          sugar = double.parse(
              (nutritionData?['sugar']?['amount'] ?? 0).toStringAsFixed(2));
          fat = double.parse(
              (nutritionData?['fat']?['amount'] ?? 0).toStringAsFixed(2));
          sodium = double.parse(
              (nutritionData?['sodium']?['amount'] ?? 0).toStringAsFixed(2));
          protein = double.parse(
              (nutritionData?['protein']?['amount'] ?? 0).toStringAsFixed(2));
        } else {
          calories = 0;
          carbohydrate = 0;
          sugar = 0;
          fat = 0;
          sodium = 0;
          protein = 0;
        }
        // สามารถใช้ calories ในการแสดงผลได้ตามต้องการ
        // print("Total Calories: $calories");
        // BMI Calculation - Check if userData is not null
      });
    }
  }

  Future<void> loadUserProfile() async {
    var profile = await Profile.getUserProfile();
if (mounted){
setState(() {
      userData = profile?['message'];
      if (userData != null) {
        weight = double.tryParse(userData!['weight'].toString()) ?? 0;
        height = double.tryParse(userData!['height'].toString()) ?? 0;
      }
    });
}
    
  }

  Future<void> fetchMaxEnergy() async {
    var tdeeData = await Profile.calculateCalories();
    if (tdeeData != null && mounted) {
      setState(() {
        maxEnergy = double.tryParse(tdeeData['tdee'].toString()) ?? 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(241, 241, 241, 1),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                // พื้นหลังรูปภาพ
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 45),
                  height: 115,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('asset/im/bg.png'),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: PopupMenuButton<String>(
                      onSelected: (String newValue) {
                        setState(() {
                          selectedIndex =
                              int.parse(newValue); // เก็บค่า index ที่เลือก
                          selectedDate = DateTime.now()
                              .add(Duration(days: int.parse(newValue)));
                          selectedText = DateFormat('d MMMM yyyy', 'th')
                              .format(selectedDate);
                        });

                        fetchData(); // ดึงข้อมูลใหม่หลังจากอัปเดตค่า
                      },
                      itemBuilder: (BuildContext context) =>
                          List.generate(7, (index) {
                        DateTime date =
                            DateTime.now().add(Duration(days: index));
                        String formattedDate =
                            DateFormat('d MMMM yyyy', 'th').format(date);

                        // ตรวจสอบว่า mealPlans มีขนาดอย่างน้อย 7 หรือไม่
                        if (mealPlans.length == 7) {
                          // เช็คสถานะของมื้ออาหารทั้งสามมื้อในวันนั้นๆ
                          bool allMealsPlanned =
                              mealPlans[index]["isPlanedBreakfast"] == 'a' &&
                                  mealPlans[index]["isPlanedLunch"] == 'a' &&
                                  mealPlans[index]["isPlanedDinner"] == 'a';

                          return PopupMenuItem(
                            value: index.toString(),
                            child: Container(
                              // width: double
                              //     .infinity*2, // ทำให้เต็มพื้นที่ของ PopupMenuItem
                              height: 45,
                              decoration: BoxDecoration(
                                color: selectedIndex == index
                                    ? Colors.grey[
                                        300] // เปลี่ยนเป็นสีเทาถ้าเป็นวันเลือก
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                children: [
                                  // แสดงไอคอนแค่เมื่อทั้งสามมื้อเป็น 'a'

                                  Container(
                                    width: 19,
                                    height: 19,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Color.fromRGBO(74, 178, 132, 1),
                                        width: 1,
                                      ),
                                      color: allMealsPlanned
                                          ? Color.fromRGBO(74, 178, 132, 1)
                                          : Colors.transparent,
                                    ),
                                    child: Icon(
                                      Icons.check,
                                      size: 16,
                                      color: selectedIndex == index
                                          ? Colors.grey[300]
                                          : Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "${date.day} ${DateFormat('MMMM', 'th').format(date)} ${date.year + 543}", // แก้ไขการบวก 543
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          // คืนค่า Container แทน SizedBox เพื่อหลีกเลี่ยงข้อผิดพลาด
                          return PopupMenuItem(
                            value: index.toString(),
                            child: Container(
                              height: 30, // กำหนดความสูงให้กับ Container
                              width: 100, // กำหนดความกว้างให้กับ Container
                              child: Center(
                                child: Text(
                                    "Data not ready"), // หรือข้อความที่คุณต้องการแสดง
                              ),
                            ),
                          );
                        }
                      }),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 4)
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              selectedText,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(width: 8),
                            Image.asset(
                              'asset/im/icon_dropdown.png',
                              width: 20,
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 10,
                  child: Obx(() {
                    var blood = Get.find<BloodSugarController>();
                    var controller = Get.find<ConnectionController>();
                    return BloodSugarLevel(
                        bloodSugarLevel: (controller.isConnected.value == false)
                            ? "--"
                            : blood.bloodSugar.value.toString(),
                        timestamp: (controller.isConnected.value == false)
                            ? "--"
                            : blood.bloodSugarTimestamp.value);
                  }),
                ),
              ],
            ),
            Planmealbutton(
              title: "วางแผนอาหารเช้าของคุณ",
              time: "07:00-10:00น.",
              leadingImagePath: 'asset/im/morningsun.png',
              trailingImagePath: 'asset/im/Vector.png',
              isplaned: isPlanedBreakfast,
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllmealPage(
                      selectedDate: selectedDate,
                      args: {},
                      mealType: "breakfast",
                    ),
                  ),
                );
                // print("result:${result}");
                // ตรวจสอบว่ามีการเปลี่ยนแปลงหรือไม่
                if (result == "Default_toPlanPage") {
                  print("success fetchData");
                  fetchData(); // รีเฟรชข้อมูลใหม่
                }
              },
            ),
            Planmealbutton(
              title: "วางแผนอาหารกลางวันของคุณ",
              time: "11:30-14:30น.",
              leadingImagePath: 'asset/im/lunchsun.png',
              trailingImagePath: 'asset/im/Vector.png',
              isplaned: isPlanedLunch,
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllmealPage(
                      selectedDate: selectedDate,
                      args: {},
                      mealType: "lunch",
                    ),
                  ),
                );
                // print("result:${result}");
                // ตรวจสอบว่ามีการเปลี่ยนแปลงหรือไม่
                if (result == "Default_toPlanPage") {
                  fetchData(); // รีเฟรชข้อมูลใหม่
                }
              },
            ),
            Planmealbutton(
              title: "วางแผนอาหารเย็นของคุณ",
              time: "16:00-19:00น.",
              leadingImagePath: 'asset/im/eveningsun.png',
              trailingImagePath: 'asset/im/Vector.png',
              isplaned: isPlanedDinner,
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllmealPage(
                      selectedDate: selectedDate,
                      args: {},
                      mealType: "dinner",
                    ),
                  ),
                );

                // ตรวจสอบว่ามีการเปลี่ยนแปลงหรือไม่
                if (result == "Default_toPlanPage") {
                  fetchData(); // รีเฟรชข้อมูลใหม่
                }
              },
            ),
            SizedBox(height: 16),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 18, vertical: 0),
              child: Text(
                "คำแนะนำในการบริโภค",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.start, // จัดให้อยู่กึ่งกลาง
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: BMIWidget(
                weight: weight,
                height: height,
                accumulatedEnergy: calories,
                maxEnergy: maxEnergy,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Nutritioncard(
                name: "ข้อมูลโภชนาการ",
                carbohydrate: carbohydrate,
                sugar: sugar,
                fat: fat,
                sodium: sodium,
                protein: protein,
                calories: calories,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
