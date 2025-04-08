import 'package:flutter/material.dart';
import 'package:diabetes_meal_management_application_project/components/auth/button_press_next.dart';
import 'package:diabetes_meal_management_application_project/components/auth/textfield.dart';
import 'package:diabetes_meal_management_application_project/pages/auth/filldisease.dart';
import 'package:diabetes_meal_management_application_project/components/backbutton.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:diabetes_meal_management_application_project/components/auth/showerrordialog.dart';
import 'package:diabetes_meal_management_application_project/main.dart';

class FilldetailsPage extends StatefulWidget {
  final String email;
  final String username;
  final String password;
  FilldetailsPage({
    required this.email,
    required this.username,
    required this.password,
  });

  @override
  _FilldetailsPageState createState() => _FilldetailsPageState();
}

class _FilldetailsPageState extends State<FilldetailsPage> {
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  List<String> selectedAllergies = ['ถั่ว', 'งา'];

  String? selectedGender; // ✅ Default is null to show "เพศสภาพ"
  Map<String, bool> allergies = {
    "ไม่มี": false,
    "อาหารทะเล": false,
    "ถั่วและเมล็ดพืช": false,
    "ผลิตภัณฑ์จากนม": false,
    "ไข่": false,
    "อื่น ๆ": false,
  };

  bool _validateAndProceed() {
    print("Birthdate: ${_birthdateController.text}");
    print("Weight: ${_weightController.text}");
    print("Height: ${_heightController.text}");
    print("Selected Gender: $selectedGender");
    print("Allergies: $allergies");

    // Check if all fields are empty
    if (_birthdateController.text.isEmpty &&
        _weightController.text.isEmpty &&
        _heightController.text.isEmpty &&
        selectedGender == null &&
        !allergies.containsValue(true)) {
      ShowErrorDialog.show(
          context, 'ข้อผิดพลาด', 'กรุณากรอกข้อมูลทุกช่องให้ครบถ้วน');
      return false;
    }

    // Validate birth year (must be a 4-digit number)
    if (_birthdateController.text.isEmpty ||
        !RegExp(r'^24[3-9][0-9]|25[0-9]{2,}$')
            .hasMatch(_birthdateController.text)) {
      ShowErrorDialog.show(context, 'ข้อผิดพลาด', 'กรุณากรอกปีเกิดให้ถูกต้อง');
      return false;
    }

    // Validate weight (must be a number between 20 and 300)
    if (_weightController.text.isEmpty ||
        !RegExp(r'^[2-9][0-9]$|^1[0-9]{2}$|^2[0-9]{2}$|^300$')
            .hasMatch(_weightController.text)) {
      ShowErrorDialog.show(
          context, 'ข้อผิดพลาด', 'กรุณากรอกน้ำหนักที่ถูกต้อง (20-300 กก.)');
      return false;
    }

    // Validate height (must be a number between 50 and 300)
    if (_heightController.text.isEmpty ||
        !RegExp(r'^(50|[5-9][0-9]|1[0-9]{2}|2[0-9]{2}|300)$')
            .hasMatch(_heightController.text)) {
      ShowErrorDialog.show(
          context, 'ข้อผิดพลาด', 'กรุณากรอกส่วนสูงที่ถูกต้อง (50-300 ซม.)');
      return false;
    }

    // Validate gender selection
    if (selectedGender == null) {
      ShowErrorDialog.show(context, 'ข้อผิดพลาด', 'กรุณาเลือกเพศสภาพ');
      return false;
    }

    // Validate at least one allergy selection
    if (!allergies.containsValue(true)) {
      ShowErrorDialog.show(
          context, 'ข้อผิดพลาด', 'กรุณาเลือกอาหารที่แพ้อย่างน้อย 1 รายการ');
      return false;
    }
    // ✅ If all validations pass, proceed to next page
    // Navigator.pushReplacementNamed(context, '/filldisease');
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Backbutton(
          onPressed: () {
            // Navigator.pushReplacementNamed(context, '/signup');
            Navigator.pop(context);
          },
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'ยินดีต้อนรับสู่ Sugar Plan!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'กรุณาบอกเราเกี่ยวกับตัวคุณสักนิด',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.grey[600]),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Textfield(
                          controller: _birthdateController,
                          text: 'ปีเกิด (พ.ศ.)',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),

                        /// ✅ Gender Dropdown with default "เพศสภาพ"
                        DropdownButtonFormField<String>(
                          value: selectedGender,
                          hint: Text(
                            'เพศสภาพ', // ✅ Show hint if no selection
                            style: TextStyle(
                              color: Color.fromRGBO(74, 178, 132, 1),
                              fontSize: 16,
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                          onChanged: (newValue) {
                            setState(() {
                              selectedGender = newValue!;
                            });
                          },
                          items: [
                            DropdownMenuItem(
                              value: 'ชาย',
                              child: Text(
                                'ชาย',
                                style: TextStyle(
                                  color: Color.fromRGBO(74, 178, 132, 1),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w100,
                                ),
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'หญิง',
                              child: Text(
                                'หญิง',
                                style: TextStyle(
                                  color: Color.fromRGBO(74, 178, 132, 1),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w100,
                                ),
                              ),
                            ),
                          ],
                          decoration: InputDecoration(
                            fillColor: Color.fromRGBO(236, 255, 247, 1),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 12.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Textfield(
                          controller: _weightController,
                          text: 'น้ำหนัก (กก.)',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Textfield(
                          controller: _heightController,
                          text: 'ส่วนสูง (ซม.)',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(width: 16),

              /// **Allergy Selection**
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'asset/im/allergy.png',
                    height: 100,
                  ),
                  SizedBox(width: 10),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(236, 255, 247, 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '     คุณแพ้อาหารอะไรบ้าง?     ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(74, 178, 132, 1),
                      ),
                    ),
                  ),
                ],
              ),

              /// **Checkbox List**
              Column(
                children: allergies.keys.map((String key) {
                  return Column(
                    children: [
                      CheckboxListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                        title: Text(key, style: TextStyle(fontSize: 16)),
                        value: allergies[key],
                        activeColor: Color.fromRGBO(74, 178, 132, 1),
                        checkColor: Colors.white,
                        shape: CircleBorder(),
                        side: BorderSide(
                          color: Color.fromRGBO(74, 178, 132, 1),
                          width: 2,
                        ),
                        onChanged: (bool? value) {
                          setState(() {
                            if (key == "ไม่มี") {
                              // If selecting "ไม่มี", uncheck all others
                              allergies.updateAll(
                                  (k, v) => k == "ไม่มี" ? value! : false);
                            } else {
                              // If selecting other options, uncheck "ไม่มี"
                              allergies["ไม่มี"] = false;
                              allergies[key] = value!;
                            }
                          });
                        },
                      ),
                      Divider(
                        thickness: 1,
                        color: Colors.grey.shade300,
                        indent: 16,
                        endIndent: 16,
                        height: 1,
                      ),
                    ],
                  );
                }).toList(),
              ),

              SizedBox(height: 30),

              /// **Next Button**
              ButtonPressNext(
                text: 'ถัดไป',
                onPressed: () {
                  if (_validateAndProceed()) {
                    // ✅ ตรวจสอบก่อนเปลี่ยนหน้า
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FillDiseasePage(
                          email: widget.email,
                          username: widget.username,
                          password: widget.password,
                          birthdate: _birthdateController.text,
                          weight: _weightController.text,
                          height: _heightController.text,
                          gender: selectedGender!,
                          allergies: allergies,
                        ),
                      ),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
