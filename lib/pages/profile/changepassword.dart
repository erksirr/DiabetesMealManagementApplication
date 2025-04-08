import 'package:flutter/material.dart';
import 'package:diabetes_meal_management_application_project/apis/Api_profile.dart';
import 'package:diabetes_meal_management_application_project/components/auth/showerrordialog.dart';
import 'package:diabetes_meal_management_application_project/components/auth/textfield.dart';
import 'package:diabetes_meal_management_application_project/components/backbutton.dart';
import 'package:diabetes_meal_management_application_project/components/profile/savebutton_changepassword.dart';
import 'package:diabetes_meal_management_application_project/components/successalert.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool checkValue = false;

  @override
  void initState() {
    super.initState();
    _oldPasswordController.addListener(_validateInputs);
    _newPasswordController.addListener(_validateInputs);
    _confirmPasswordController.addListener(_validateInputs);
  }

  Future<bool> _verifyPassword() async {
    if (!_formKey.currentState!.validate()) return false;

    if (_oldPasswordController.text.isEmpty) {
      ShowErrorDialog.show(context, 'ข้อผิดพลาด', 'กรุณากรอกรหัสผ่านเก่า');
      return false;
    }

    bool isValid =
        await Profile.verifyCurrentPassword(_oldPasswordController.text);
    if (!isValid) {
      ShowErrorDialog.show(context, 'ข้อผิดพลาด', 'รหัสผ่านเก่าผิด');
      return false;
    }

    if (_newPasswordController.text.isEmpty) {
      ShowErrorDialog.show(context, 'ข้อผิดพลาด', 'กรุณากรอกรหัสผ่านอันใหม่');
      return false;
    }

    if (_newPasswordController.text.length < 7) {
      ShowErrorDialog.show(
          context, 'ข้อผิดพลาด', 'รหัสผ่านใหม่ต้องมีอย่างน้อย 7 ตัวอักษร');
      return false;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      ShowErrorDialog.show(
          context, 'ข้อผิดพลาด', 'รหัสผ่านใหม่และยืนยันรหัสผ่านใหม่ไม่ตรงกัน');
      return false;
    }

    return true;
  }

  Future<void> _changePassword() async {
    bool isVerified = await _verifyPassword();
    if (!isVerified) return;

    bool response = await Profile.changePassword(
        _newPasswordController.text, _oldPasswordController.text);
    if (response) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('เปลี่ยนรหัสผ่านสำเร็จ!')));

      _oldPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();

      setState(() {
        checkValue = false;
      });

      _showSuccessDialog(context);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('เปลี่ยนรหัสผ่านไม่สำเร็จ')));
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Successalert(),
    );
  }

  void _validateInputs() {
    setState(() {
      checkValue = _oldPasswordController.text.isNotEmpty &&
          _newPasswordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty &&
          _newPasswordController.text == _confirmPasswordController.text;
    });
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'แก้ไขรหัสผ่าน',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        leading: Backbutton(onPressed: () => Navigator.pop(context)),
        centerTitle: true,
        actions: [Savebuttonchangepassword(onPressed: _changePassword)],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Textfield(
                  controller: _oldPasswordController,
                  text: 'รหัสผ่านเดิม',
                  obscureText: true),
              SizedBox(height: 20),
              Textfield(
                  controller: _newPasswordController,
                  text: 'รหัสผ่านใหม่',
                  obscureText: true),
              SizedBox(height: 20),
              Textfield(
                  controller: _confirmPasswordController,
                  text: 'ยืนยันรหัสผ่านใหม่',
                  obscureText: true),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
