import 'package:flutter/material.dart';
import 'package:diabetes_meal_management_application_project/apis/Api_auth.dart';
import 'package:diabetes_meal_management_application_project/components/auth/button_press_next.dart';
import 'package:diabetes_meal_management_application_project/components/auth/textfield.dart';
import 'package:diabetes_meal_management_application_project/components/backbutton.dart';
import 'package:diabetes_meal_management_application_project/pages/auth/signup.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  // final _storage = FlutterSecureStorage();
  Future<void> _login(BuildContext context) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    await AuthService.login(context, email, password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Backbutton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
        title: Text(
          'เข้าสู่ระบบ',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true, // Center the title
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Email Text Field
              //Textfeild
              Textfield(
                text: "อีเมล",
                controller: _emailController,
              ),
              SizedBox(height: 14),

              // Password Text Field
              Textfield(
                text: "รหัสผ่าน",
                controller: _passwordController,
                obscureText: true,
              ),
              SizedBox(height: 14),

              ButtonPressNext(
                  text: 'เข้าสู่ระบบ',
                  onPressed: () {
                    // Dummy authentication for now
                    _login(context);
                  }),

              // Google Sign-In Button

              SizedBox(height: 20),

              // Registration prompt
              Text(
                'ยังไม่มีบัญชีใช่ไหม',
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
                    MaterialPageRoute(builder: (context) => SignupPage()),
                  );
                },
                child: Text(
                  'ลงทะเบียนที่นี่',
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
