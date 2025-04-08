import 'package:flutter/material.dart';
import 'package:diabetes_meal_management_application_project/components/auth/button_press_next.dart';
import 'package:diabetes_meal_management_application_project/components/auth/showerrordialog.dart';
import 'package:diabetes_meal_management_application_project/pages/auth/healthsumary.dart';
import 'package:diabetes_meal_management_application_project/components/backbutton.dart';

class FillExercisePage extends StatefulWidget {
  final String email;
  final String username;
  final String password;
  final String birthdate;
  final String height;
  final String weight;
  final String gender;
  final Map<String, bool> disease;
  final Map<String, bool> allergies;

  FillExercisePage({
    required this.email,
    required this.username,
    required this.password,
    required this.birthdate,
    required this.height,
    required this.weight,
    required this.allergies,
    required this.disease,
    required this.gender,
  });

  @override
  _FillExercisePageState createState() => _FillExercisePageState();
}

class _FillExercisePageState extends State<FillExercisePage> {
  String? selectedExercise; // ✅ เก็บค่าที่เลือก
  @override
  void initState() {
    super.initState();
    // print(widget.email);
    // print(widget.username);
    // print(widget.password);
    // print(widget.birthdate);
    // print(widget.height);
    // print(widget.weight);
    // print(widget.allergies);
    // print(widget.disease);
    // print(widget.gender);
  }

  final Map<String, String> exerciseLevels = {
    "ไม่ออกกำลังกายหรือกิจกรรมทางกายที่ต่ำมาก": "level1",
    "ออกกำลังกายเล็กน้อย: 1-3 วัน/สัปดาห์": "level2",
    "ออกกำลังกายปานกลาง: 3-5 วัน/สัปดาห์": "level3",
    "ออกกำลังกายหนัก: 6-7 วัน/สัปดาห์": "level4",
    "ออกกำลังกายอย่างหนักหรือมีงานที่ใช้แรงมาก":"level5"
  };
  bool _validateAndProceed() {
    if (selectedExercise == null) {
      ShowErrorDialog.show(
          context, 'ข้อผิดพลาด', 'กรุณาเลือกความถี่ของการออกกำลังกาย');
      return false;
    }
    return true;

    // Navigator.pushReplacementNamed(context, '/fillexercise');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Backbutton(
          onPressed: () {
            // Navigator.pushReplacementNamed(
            //     context, '/filldisease'); // ✅ กลับไปหน้า filldisease
            Navigator.pop(context);
          },
        ),
        title: Text(
          'ยินดีต้อนรับสู่ Sugar Plan!',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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

              /// **แถวที่มีรูปภาพและข้อความ "คุณออกกำลังกายบ่อยแค่ไหน?"**
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// รูปภาพ
                  Image.asset(
                    'asset/im/exercise.png', // ✅ ตรวจสอบให้แน่ใจว่าไฟล์มีอยู่จริง
                    height: 100,
                  ),
                  SizedBox(width: 10),

                  /// ข้อความ "คุณออกกำลังกายบ่อยแค่ไหน?" พร้อมพื้นหลัง
                  Expanded(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(236, 255, 247, 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'คุณออกกำลังกายบ่อยแค่ไหน?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(74, 178, 132, 1),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),

              /// **Radio Button สำหรับเลือกตัวเลือกเดียว**
              Column(
                children: exerciseLevels.keys.map((String key) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text(key, style: TextStyle(fontSize: 16)),
                        trailing: Radio<String>(
                          value: exerciseLevels[key] ?? '',
                          groupValue: selectedExercise,
                          activeColor: Color.fromRGBO(74, 178, 132, 1),
                          onChanged: (String? value) {
                            setState(() {
                              selectedExercise = value!;
                            });
                          },
                        ),
                        onTap: () {
                          setState(() {
                            selectedExercise = exerciseLevels[key];
                          });
                        },
                      ),

                      /// เส้นข้างล่างของแต่ละตัวเลือก
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

              /// **ปุ่มถัดไป**
              ButtonPressNext(
                text: 'ถัดไป',
                onPressed: () {
                  print(widget.email);
                  print(widget.username);
                  print(widget.password);
                  print(widget.birthdate);
                  print(widget.height);
                  print(widget.weight);
                  print(widget.gender);
                  print(selectedExercise);

                  // แปลงค่า allergies และ disease ให้เหลือเฉพาะค่าที่เป็น true

                  // ✅ พิมพ์ค่าที่ถูกต้องออกมา

                  if (_validateAndProceed()) {
                    List<String> selectedAllergies = widget.allergies.entries
                        .where((e) => e.value)
                        .map((e) => e.key)
                        .toList();
                    List<String> selectedDiseases = widget.disease.entries
                        .where((e) => e.value)
                        .map((e) => e.key)
                        .toList();
                    String selectedExerciseText = exerciseLevels.entries
                        .firstWhere((e) => e.value == selectedExercise)
                        .key;
                    print("Allergies: $selectedAllergies");
                    print("Diseases: $selectedDiseases");
                    print("Exercise: $selectedExerciseText");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HealthSummaryPage(
                          email: widget.email,
                          username: widget.username,
                          password: widget.password,
                          birthdate: widget.birthdate,
                          weight: int.tryParse(widget.weight) ?? 0,
                          height: int.tryParse(widget.height) ?? 0,
                          gender: widget.gender,
                          allergies: selectedAllergies, // ✅ ส่งค่าเฉพาะที่เลือก
                          disease: selectedDiseases, // ✅ ส่งค่าเฉพาะที่เลือก
                          exercise:
                              selectedExerciseText, // ✅ ส่งข้อความที่เลือกแทนค่า level
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
