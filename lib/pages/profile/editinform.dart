import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:diabetes_meal_management_application_project/apis/Api_profile.dart';
import 'package:diabetes_meal_management_application_project/components/auth/textfield.dart';
import 'package:diabetes_meal_management_application_project/components/backbutton.dart';
import 'package:diabetes_meal_management_application_project/components/home/savebutton.dart';
import 'package:diabetes_meal_management_application_project/components/profile/areusure.dart';

class EditinformPage extends StatefulWidget {
  EditinformPage({super.key});

  @override
  State<EditinformPage> createState() => _EditinformPageState();
}

class _EditinformPageState extends State<EditinformPage> {
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _congenitaldiseaseController =
      TextEditingController();
  final TextEditingController _foodallergyController = TextEditingController();
  String initialselectedCongenitalDisease = '';
  String initialselectedFoodAllergy = '';
  String initialselectedGender = '';
  String initialselectedExerciseFrequency = '';
  List<String> selectedCongenitalDisease = []; // เปลี่ยนเป็น List<String>
  List<String> selectedFoodAllergy = [];
  String selectedGender = 'ชาย';
  String selectedExerciseFrequency = '';
  String birthdateText = "";
  String weightText = "";
  String heightText = "";
  int save = 0;
  bool hasChanges = false; // สถานะการแก้ไขข้อมูล
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
  Map<String, bool> allergies = {
    "ไม่มี": false,
    "อาหารทะเล": false,
    "ถั่วและเมล็ดพืช": false,
    "ผลิตภัณฑ์จากนม": false,
    "ไข่": false,
    "อื่น ๆ": false,
  };
  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    void addListeners() {
      _birthdateController.addListener(() => _onDataChanged());
      _weightController.addListener(() => _onDataChanged());
      _heightController.addListener(() => _onDataChanged());
    }

    addListeners();
    // ฟังชันเพื่อตรวจจับการแก้ไข
  }

  Future<void> _loadUserProfile() async {
    var profile = await Profile.getUserProfile();

    print(profile);
    if (profile != null) {
      setState(() {
        // ตั้งค่า default ค่าจากข้อมูลที่ได้รับจาก backend
        birthdateText = profile["message"]["birth_date"];
        weightText = profile["message"]["weight"];
        heightText = profile["message"]["height"];
        initialselectedGender = profile["message"]['gender'] ?? 'ชาย';
        initialselectedFoodAllergy =
            (profile["message"]['food_allergies'] as List?)?.join(', ') ?? '';
        initialselectedCongenitalDisease =
            (profile["message"]['congenital_disease'] as List?)?.join(', ') ??
                '';
        initialselectedExerciseFrequency =
            profile["message"]['exercise'] ?? '-';
        selectedGender = initialselectedGender;
        selectedFoodAllergy = initialselectedFoodAllergy.split(', ');
        selectedCongenitalDisease = initialselectedCongenitalDisease
            .split(', '); // แปลงเป็น List<String>
        selectedExerciseFrequency = initialselectedExerciseFrequency;

        print("selectedCongenitalDisease: $selectedCongenitalDisease");
        print(
            "initialselectedCongenitalDisease: $initialselectedCongenitalDisease");

        // Set initial values for disease map
        List<String> congenitalDiseases =
            initialselectedCongenitalDisease.split(', ');
        for (String diseaseName in congenitalDiseases) {
          if (disease.containsKey(diseaseName)) {
            disease[diseaseName] = true;
          }
        }
        List<String> food_allergies = initialselectedFoodAllergy.split(', ');
        for (String foodName in food_allergies) {
          if (allergies.containsKey(foodName)) {
            allergies[foodName] = true;
          }
        }
        print("congenitalDiseases: $congenitalDiseases");
      });
    }
  }

  void _saveUserProfile() async {
    Map<String, dynamic> updatedData = {
      "birth_date": _birthdateController.text.isNotEmpty
          ? _birthdateController.text
          : birthdateText,
      "weight": _weightController.text.isNotEmpty
          ? _weightController.text
          : weightText,
      "height": _heightController.text.isNotEmpty
          ? _heightController.text
          : heightText,
      "gender": selectedGender,
      "food_allergies": selectedFoodAllergy,
      "congenital_disease": selectedCongenitalDisease, // ใช้ List<String>
      "exercise": selectedExerciseFrequency,
    };
    print("update:${updatedData}");
    bool success = await Profile.updateUserProfile(updatedData);

    print("success:${success}");
    if (success) {
      setState(() {
        save = 0;
        hasChanges = false;
        // อัปเดตค่าเริ่มต้นใหม่หลังจากบันทึกข้อมูล
        birthdateText = updatedData["birth_date"];
        weightText = updatedData["weight"];
        heightText = updatedData["height"];
        initialselectedGender = selectedGender;
        initialselectedExerciseFrequency = selectedExerciseFrequency;
        initialselectedFoodAllergy = selectedFoodAllergy.join(', ');
        initialselectedCongenitalDisease =
            selectedCongenitalDisease.join(', '); // แปลงกลับเป็น String
      });
      print("อัปเดตข้อมูลสำเร็จ!");
    } else {
      print("อัปเดตข้อมูลล้มเหลว!");
    }
  }

  void _resetEditform() {
    setState(() {
      save = 0;
      hasChanges = false; // รีเซ็ตสถานะของปุ่ม Save
    });
  }

  void _onDataChanged() {
    setState(() {
      bool birthdateChanged = (_birthdateController.text.isNotEmpty &&
          _birthdateController.text != birthdateText);
      print(
          "Birthdate changed: $birthdateChanged | Current: '${_birthdateController.text}', Initial: '$birthdateText'");

      bool weightChanged = (_weightController.text.isNotEmpty &&
          _weightController.text != weightText);
      print(
          "Weight changed: $weightChanged | Current: '${_weightController.text}', Initial: '$weightText'");

      bool heightChanged = (_heightController.text.isNotEmpty &&
          _heightController.text != heightText);
      print(
          "Height changed: $heightChanged | Current: '${_heightController.text}', Initial: '$heightText'");

      bool congenitalDiseaseChanged = !listEquals(selectedCongenitalDisease,
          initialselectedCongenitalDisease.split(', '));
      print(
          "Congenital Disease changed: $congenitalDiseaseChanged | Current: $selectedCongenitalDisease, Initial: ${initialselectedCongenitalDisease.split(', ')}");

      bool foodAllergyChanged = !listEquals(
          selectedFoodAllergy, initialselectedFoodAllergy.split(', '));
      print(
          "Food Allergy changed: $foodAllergyChanged | Current: $selectedFoodAllergy, Initial: ${initialselectedFoodAllergy.split(', ')}");

      bool genderChanged = (selectedGender != initialselectedGender);
      print(
          "Gender changed: $genderChanged | Current: '$selectedGender', Initial: '$initialselectedGender'");

      bool exerciseChanged =
          (selectedExerciseFrequency != initialselectedExerciseFrequency);
      print(
          "Exercise Frequency changed: $exerciseChanged | Current: '$selectedExerciseFrequency', Initial: '$initialselectedExerciseFrequency'");

      hasChanges = birthdateChanged ||
          weightChanged ||
          heightChanged ||
          congenitalDiseaseChanged ||
          foodAllergyChanged ||
          genderChanged ||
          exerciseChanged;

      print("Final hasChanges: $hasChanges");

      save = hasChanges ? 1 : 0;
      print("Save value: $save");
    });
  }

  void _updateSelectedCongenitalDisease() {
    print("selectedCongenitalDisease: $selectedCongenitalDisease");
    selectedCongenitalDisease = disease.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
    print(
        "initialselectedCongenitalDisease: $initialselectedCongenitalDisease");
    print("selectedCongenitalDisease: $selectedCongenitalDisease");
    _onDataChanged();
  }

  void _updateSelectedFoodAllergies() {
    print("selectedFoodAllergy: $selectedFoodAllergy");
    selectedFoodAllergy = allergies.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
    _onDataChanged();
  }

  @override
  Widget build(BuildContext context) {
    void _showConfirmationDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) {
          return Areusure(); // เรียกใช้ dialog ยืนยัน
        },
      ).then((value) {
        if (value == "Don't stay") {
          Navigator.pop(context); // ส่งค่า 3 กลับไปที่ ProfilePage
        }
      });
    }

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
            hasChanges
                ? _showConfirmationDialog(context)
                : Navigator.pop(context);
          },
        ),
        actions: [
          Savebutton(
            check: 2,
            save: save,
            onReset: () {
              setState(() {
                _saveUserProfile();
                _resetEditform();
              });
            }, // ส่ง callback สำหรับรีเซ็ต
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  // Date of birth input
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ปีเกิด (พ.ศ)'),
                        SizedBox(height: 5),
                        Textfield(
                          controller: _birthdateController,
                          text: '${birthdateText}',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16), // Spacer between columns
                  // Gender dropdown
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('เพศสภาพ'),
                        SizedBox(height: 5),
                        DropdownButtonFormField<String>(
                          value:
                              selectedGender.isNotEmpty ? selectedGender : null,
                          onChanged: (newValue) {
                            if (newValue != selectedGender) {
                              // ตรวจสอบการเปลี่ยนแปลง
                              setState(() {
                                selectedGender = newValue!;
                                hasChanges = true; // อัปเดตสถานะการเปลี่ยนแปลง
                                _onDataChanged(); // เรียกใช้ฟังก์ชันที่คอยติดตามการเปลี่ยนแปลง
                              });
                            }
                          },
                          items: ['ชาย', 'หญิง']
                              .map((gender) => DropdownMenuItem(
                                    value: gender,
                                    child: Text(
                                      gender,
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(74, 178, 132, 1),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ))
                              .toList(),
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
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Weight input
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('น้ำหนัก (กก.)'),
                        SizedBox(height: 5),
                        Textfield(
                          controller: _weightController,
                          text: '${weightText}',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16), // Spacer between columns
                  // Height input
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ส่วนสูง (ซม.)'),
                        SizedBox(height: 5),
                        Textfield(
                          controller: _heightController,
                          text: '${heightText}',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('การออกกำลังกาย'),
                        SizedBox(height: 5),
                        DropdownButtonFormField<String>(
                          value: selectedExerciseFrequency.isNotEmpty
                              ? selectedExerciseFrequency
                              : null,
                          onChanged: (newValue) {
                            setState(() {
                              selectedExerciseFrequency = newValue!;
                              hasChanges = true; // อัปเดตสถานะการเปลี่ยนแปลง
                              _onDataChanged();
                            });
                          },
                          items: [
                            "ไม่ออกกำลังกายหรือกิจกรรมทางกายที่ต่ำมาก",
                            "ออกกำลังกายเล็กน้อย: 1-3 วัน/สัปดาห์",
                            "ออกกำลังกายปานกลาง: 3-5 วัน/สัปดาห์",
                            "ออกกำลังกายหนัก: 6-7 วัน/สัปดาห์",
                            "ออกกำลังกายอย่างหนักหรือมีงานที่ใช้แรงมาก",
                          ]
                              .map(
                                (exercise) => DropdownMenuItem(
                                  value: exercise,
                                  child: Text(
                                    exercise,
                                    style: TextStyle(
                                        color: Color.fromRGBO(74, 178, 132, 1),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              )
                              .toList(),
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
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('โรคประจำตัว'),
                        SizedBox(height: 5),
                        Column(
                          children: disease.keys.map((String key) {
                            return Column(
                              children: [
                                CheckboxListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 0),
                                  title:
                                      Text(key, style: TextStyle(fontSize: 14)),
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
                                            k == "ไม่มีโรคประจำตัว"
                                                ? value!
                                                : false);
                                      } else {
                                        // If selecting other options, unselect "ไม่มีโรคประจำตัว"
                                        disease["ไม่มีโรคประจำตัว"] = false;
                                        disease[key] = value!;
                                      }
                                      _updateSelectedCongenitalDisease();
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
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('การแพ้อาหารหรือข้อจำกัดด้านอาหาร'),
                        SizedBox(height: 5),
                        Column(
                          children: allergies.keys.map((String key) {
                            return Column(
                              children: [
                                CheckboxListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 0),
                                  title:
                                      Text(key, style: TextStyle(fontSize: 14)),
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
                                        allergies.updateAll((k, v) =>
                                            k == "ไม่มี" ? value! : false);
                                      } else {
                                        // If selecting other options, uncheck "ไม่มี"
                                        allergies["ไม่มี"] = false;
                                        allergies[key] = value!;
                                      }
                                      _updateSelectedFoodAllergies();
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
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
