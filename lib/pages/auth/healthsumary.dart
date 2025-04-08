import 'package:diabetes_meal_management_application_project/apis/Api_auth.dart';
import 'package:flutter/material.dart';
import 'package:diabetes_meal_management_application_project/components/auth/health_sumary_box.dart';
import 'package:diabetes_meal_management_application_project/main.dart';
import 'package:diabetes_meal_management_application_project/pages/auth/fillexercise.dart';
import 'package:diabetes_meal_management_application_project/components/auth/button_press_next.dart';
import 'package:diabetes_meal_management_application_project/components/auth/bmi_category_box.dart';
import 'package:diabetes_meal_management_application_project/components/auth/health_sumary_box.dart';
import 'package:diabetes_meal_management_application_project/components/backbutton.dart';

class HealthSummaryPage extends StatefulWidget {
  final String email;
  final String username;
  final String password;
  final String birthdate;
  final String gender;
  final int height;
  final int weight;
  final List<String> disease;
  final List<String> allergies;
  final String exercise;

  HealthSummaryPage({
    required this.email,
    required this.username,
    required this.password,
    required this.birthdate,
    required this.gender,
    required this.height,
    required this.weight,
    required this.disease,
    required this.allergies,
    required this.exercise,
  });

  @override
  State<HealthSummaryPage> createState() => _HealthSummaryPageState();
}

class _HealthSummaryPageState extends State<HealthSummaryPage> {
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

    // print(widget.exercise);
  }

  Future<void> _register(BuildContext context) async {
    final userData = {
      'email': widget.email,
      'name': widget.username,
      'password': widget.password,
      'birth_date': widget.birthdate,
      'gender': widget.gender,
      'weight': widget.weight,
      'height': widget.height,
      'congenital_disease': widget.disease,
      'food_allergies': widget.allergies,
      'exercise': widget.exercise,
    };

    await AuthService.registerUser(context, userData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Backbutton(
          onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => FillExercisePage()),
            Navigator.pop(context);
            // );
          },
        ),
        title: Text(
          'ผลสรุปข้อมูลสุขภาพ',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
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
                          height: widget.height,
                          weight: widget.weight,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),

              // ✅ **Using HealthSummaryBox Component**
              HealthSummaryBox(
                diseases: widget.disease,
                allergies: widget.allergies,
                exercise: widget.exercise,
              ),

              SizedBox(height: 160),

              /// ✅ **Button for Next Page**
              ButtonPressNext(
                text: 'ถัดไป',
                onPressed: () {
                  _register(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildDetailRow(String title, String value) {
  //   return Row(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       SizedBox(
  //         width: 120,
  //         child: Text(
  //           title,
  //           style: TextStyle(fontSize: 16),
  //         ),
  //       ),
  //       Text(
  //         value,
  //         style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
  //       ),
  //     ],
  //   );
  // }
}
