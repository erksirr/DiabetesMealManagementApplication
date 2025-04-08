import 'package:flutter/material.dart';
import 'package:diabetes_meal_management_application_project/components/auth/button_press_next.dart';
import 'package:diabetes_meal_management_application_project/components/auth/showerrordialog.dart';
import 'package:diabetes_meal_management_application_project/pages/auth/filldetails.dart';
import 'package:diabetes_meal_management_application_project/components/backbutton.dart';
import 'package:diabetes_meal_management_application_project/pages/auth/fillexercise.dart';

class FillDiseasePage extends StatefulWidget {
  final String email;
  final String username;
  final String password;
  final String birthdate;
  final String height;
  final String weight;
  final String gender;
  final Map<String, bool> allergies;

  FillDiseasePage({
    required this.email,
    required this.username,
    required this.password,
    required this.birthdate,
    required this.height,
    required this.weight,
    required this.allergies,
    required this.gender,
  });

  @override
  _FillDiseasePageState createState() => _FillDiseasePageState();
}

class _FillDiseasePageState extends State<FillDiseasePage> {
  void initState() {
    super.initState();
    print(widget.email);
    print(widget.username);
    print(widget.password);
    print(widget.birthdate);
    print(widget.height);
    print(widget.weight);
    print(widget.allergies);
    print(widget.gender);
  }

  Map<String, bool> disease = {
    "ไม่มีโรคประจำตัว": false,
    "ความดันโลหิตสูง": false,
    "โรคหัวใจและหลอดเลือด": false,
    "ภาวะไขมันในเลือดสูง": false,
    "โรคไตเรื้อรัง": false,
    "เบาหวานขึ้นตา": false,
    "แผลที่เท้า": false,
    "อื่น ๆ": false,
  };

  bool _validateAndProceed() {
    if (!disease.containsValue(true)) {
      ShowErrorDialog.show(
          context, 'ข้อผิดพลาด', 'กรุณาเลือกโรคประจำตัว\n อย่างน้อย 1 รายการ');
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
            // Navigator.pushReplacementNamed(context, '/filldetails');
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
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),

              /// **Row with Image & Text**
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'asset/im/disease.png',
                    height: 100,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(236, 255, 247, 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'คุณมีโรคประจำตัวหรือไม่?',
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

              /// **Checkbox List**
              Column(
                children: disease.keys.map((String key) {
                  return Column(
                    children: [
                      CheckboxListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                        title: Text(key, style: TextStyle(fontSize: 16)),
                        value: disease[key],
                        activeColor: Color.fromRGBO(74, 178, 132, 1),
                        checkColor: Colors.white,
                        shape: CircleBorder(),
                        side: BorderSide(
                          color: Color.fromRGBO(74, 178, 132, 1),
                          width: 2,
                        ),
                        onChanged: (bool? value) {
                          setState(() {
                            if (key == "ไม่มีโรคประจำตัว") {
                              // If selecting "ไม่มีโรคประจำตัว", unselect others
                              disease.updateAll((k, v) =>
                                  k == "ไม่มีโรคประจำตัว" ? value! : false);
                            } else {
                              // If selecting other options, unselect "ไม่มีโรคประจำตัว"
                              disease["ไม่มีโรคประจำตัว"] = false;
                              disease[key] = value!;
                            }
                          });
                        },
                      ),

                      /// Divider line
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

              /// **Next Button with Validation**
              ButtonPressNext(
                text: 'ถัดไป',
                onPressed: () {
                  if (_validateAndProceed()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FillExercisePage(
                            email: widget.email,
                            username: widget.username,
                            password: widget.password,
                            birthdate: widget.birthdate,
                            weight: widget.weight,
                            height: widget.height,
                            gender: widget.gender,
                            allergies: widget.allergies,
                            disease: disease),
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
