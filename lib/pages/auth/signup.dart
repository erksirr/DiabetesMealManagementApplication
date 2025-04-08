import 'package:flutter/material.dart';
import 'package:diabetes_meal_management_application_project/components/auth/button_press_next.dart';
import 'package:diabetes_meal_management_application_project/components/auth/showerrordialog.dart';
import 'package:diabetes_meal_management_application_project/components/auth/textfield.dart';
import 'package:diabetes_meal_management_application_project/components/backbutton.dart';
import 'package:diabetes_meal_management_application_project/pages/auth/filldetails.dart';
import 'package:diabetes_meal_management_application_project/pages/auth/login.dart';

class SignupPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _comfirmpasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Backbutton(
          onPressed: () {
           Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
          },
        ),
        title: Text(
          'ลงทะเบียน',
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
            children: [
              Textfield(
                controller: _emailController,
                text: 'อีเมล',
              ),
              SizedBox(height: 14),
              Textfield(
                controller: _usernameController,
                text: 'ชื่อผู้ใช้',
              ),
              SizedBox(height: 14),
              Textfield(
                controller: _passwordController,
                text: 'รหัสผ่าน',
                obscureText: true, // Hide password
              ),
              SizedBox(height: 14),
              Textfield(
                controller: _comfirmpasswordController,
                text: 'ยืนยันรหัสผ่าน',
                obscureText: true, // Hide confirm password
              ),
              SizedBox(height: 20),
              ButtonPressNext(
                  text: 'ลงทะเบียน',
                  onPressed: () {
                    String email = _emailController.text.trim();
                    String username = _usernameController.text.trim();
                    String password = _passwordController.text;
                    String confirmPassword = _comfirmpasswordController.text;

                    if (!_isValidEmail(email)) {
                      ShowErrorDialog.show(context, 'อีเมลไม่ถูกต้อง',
                          'กรุณากรอกอีเมลที่ถูกต้อง เช่น example@mail.com');
                      return;
                    }
                    if (username.length > 30) {
                      ShowErrorDialog.show(context, 'ชื่อผู้ใช้ยาวเกินไป',
                          'กรุณากรอกชื่อผู้ใช้ไม่เกิน 30 ตัวอักษร');
                      return;
                    }
                    if (password.length < 8) {
                      ShowErrorDialog.show(context, 'รหัสผ่านไม่ถูกต้อง',
                          'รหัสผ่านต้องมีความยาวมากกว่า 7 ตัวอักษรและไม่เป็นช่องว่าง');
                      return;
                    }
                    if (password != confirmPassword) {
                      ShowErrorDialog.show(context, 'รหัสผ่านไม่ตรงกัน',
                          'กรุณากรอกรหัสผ่านให้ตรงกัน');
                      return;
                    }

                    if (email.isNotEmpty &&
                        username.isNotEmpty &&
                        password.isNotEmpty) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FilldetailsPage(
                                  email: email,
                                  username: username,
                                  password: password)));
                    } else {
                      ShowErrorDialog.show(context, 'ลงทะเบียนไม่สำเร็จ',
                          'กรุณากรอกข้อมูลให้ครบทุกช่อง');
                    }
                  }),
              SizedBox(height: 20),
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
                  Navigator.pop(context);
                },
                child: Text(
                  'เข้าสู่ระบบที่นี่',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(101, 169, 200, 1),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// ✅ **Function to validate email format**
  bool _isValidEmail(String email) {
    final RegExp emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }
}
