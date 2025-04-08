import 'package:flutter/material.dart';
import 'package:diabetes_meal_management_application_project/apis/Api_profile.dart';
import 'package:diabetes_meal_management_application_project/components/auth/bmi_category_box.dart';
import 'package:diabetes_meal_management_application_project/components/auth/health_sumary_box.dart';
import 'package:diabetes_meal_management_application_project/components/backbutton.dart';
import 'package:diabetes_meal_management_application_project/pages/profile/editinform.dart';

class ShowformPage extends StatefulWidget {
  const ShowformPage({super.key});

  @override
  State<ShowformPage> createState() => _ShowformPageState();
}

class _ShowformPageState extends State<ShowformPage> {
  int weight = 0;
  int height = 0;
  List<String> food_allergies = [];
  List<String> congenital_disease = [];
  String exercise = "";
 Future<void> _loadUserProfile() async {
  var profile = await Profile.getUserProfile();

  print(profile);
  if (profile != null) {
    if (mounted) { // ตรวจสอบว่า widget ยังอยู่ในต้นไม้ของ widget หรือไม่
      setState(() {
        // ตั้งค่า default ค่าจากข้อมูลที่ได้รับจาก backend
        weight = int.tryParse(profile["message"]['weight']) ?? 0;
        height = int.tryParse(profile["message"]['height']) ?? 0;
        food_allergies =
            List<String>.from(profile["message"]['food_allergies'] ?? []);
        congenital_disease =
            List<String>.from(profile["message"]['congenital_disease'] ?? []);
        exercise = profile["message"]['exercise'] ?? "-";
        // ตั้งค่าอื่นๆ ตามที่ต้องการ
      });
    }
  }
}

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisSize:
              MainAxisSize.min, // Ensures content fits inside the height
          children: [
            Text(
              'ข้อมูลส่วนตัว',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true,
        leading: Backbutton(
          onPressed: () {
            Navigator.pop(context);
            // _showConfirmationDialog(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 9,
                vertical: 7,
              ),
              decoration: BoxDecoration(
                color: Color.fromRGBO(74, 178, 132, 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditinformPage(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Image.asset(
                      'asset/im/edit.png',
                      color: Colors.white,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "แก้ไข",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4),
                        BMICategoryBox(
                          height: height,
                          weight: weight,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),

              // ✅ **Using HealthSummaryBox Component**
              HealthSummaryBox(
                diseases: congenital_disease,
                allergies: food_allergies,
                exercise: exercise,
              ),

              SizedBox(height: 160),

              /// ✅ **Button for Next Page**
            ],
          ),
        ),
      ),
    );
  }
}
