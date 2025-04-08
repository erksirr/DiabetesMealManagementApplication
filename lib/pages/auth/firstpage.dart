import 'package:flutter/material.dart';
import 'package:diabetes_meal_management_application_project/components/auth/button_press_next.dart';
import 'package:diabetes_meal_management_application_project/pages/auth/login.dart';
import 'package:diabetes_meal_management_application_project/pages/auth/signup.dart';

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 100.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title and Subtitle
              Text(
                'Sugar Plan',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'วางแผนและแนะนำอาหาร\nสำหรับผู้ป่วยเบาหวาน',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 20),

              // Illustration Image
              Image.asset(
                'asset/im/firstpage.png', // Place the image asset in the 'assets' folder.
                height: 200,
              ),

              SizedBox(height: 30),

              // Google Sign-In Button

              SizedBox(height: 14),

              // Email Registration Button
              ButtonPressNext(
                text: 'ลงทะเบียน',
                onPressed: () {
                  // Navigate to login page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupPage()),
                  );
                },
              ),

              SizedBox(height: 20),

              // Already have an account? Sign in
              Text(
                'มีบัญชีอยู่แล้วใช่ไหม',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text(
                  'เข้าสู่ระบบที่นี่',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(101, 169, 200, 1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
