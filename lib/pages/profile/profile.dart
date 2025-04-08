import 'package:flutter/material.dart';
import 'package:diabetes_meal_management_application_project/apis/Api_auth.dart';
import 'package:diabetes_meal_management_application_project/apis/Api_profile.dart';
import 'package:diabetes_meal_management_application_project/components/auth/textfield.dart';
import 'package:diabetes_meal_management_application_project/components/confirmpopup.dart';

import 'package:diabetes_meal_management_application_project/components/profile/profilebutton.dart';
import 'package:diabetes_meal_management_application_project/pages/profile/changepassword.dart';
import 'package:diabetes_meal_management_application_project/pages/profile/showform.dart';
import 'package:diabetes_meal_management_application_project/pages/profile/connecttodexcom.dart'; // Adjust the path based on your project structure
import 'package:get/get.dart';
import 'package:diabetes_meal_management_application_project/controllers/connection_controller.dart';

class ProfilePage extends StatefulWidget {
  final Function(int) onNavigate;
  const ProfilePage({Key? key, required this.onNavigate}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = "";
  String gender = "";
  final connectionController = Get.find<ConnectionController>();
  final TextEditingController _nameController = TextEditingController();
  Future<void> _loadUserProfile() async {
    var profile = await Profile.getUserProfile();

    if (profile != null && mounted) {
      setState(() {
        name = profile["message"]['name'] ?? "-";
        gender = profile["message"]['gender'] ?? "-";
      });
    }
  }

  void _saveUserProfile() async {
    Map<String, dynamic> updatedData = {
      "name": _nameController.text.isNotEmpty ? _nameController.text : name
    };
    print("update:${updatedData}");
    bool success = await Profile.updateUserProfile(updatedData);

    print("success:${success}");
    if (success) {
      setState(() {});
      print("อัปเดตข้อมูลสำเร็จ!");
    } else {
      print("อัปเดตข้อมูลล้มเหลว!");
    }
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Confirmpopup(
          textHeader: "คุณต้องการออกจากระบบใช่หรือไม่",
          textAction: "ออกจากระบบ",
          onPressed: () async {
            if (connectionController.isConnected.value) {
              await connectionController
                  .disconnectDexcom(); // Disconnect Dexcom
            }
            await AuthService.logout(context); // Proceed with logout
          },
        ); // เรียกใช้ dialog ยืนยัน
      },
    );
  }

  void _Editname(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          contentPadding: EdgeInsets.zero,
          content: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 16, left: 24, right: 24, bottom: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'แก้ไขชื่อ',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 16),
                    Textfield(text: "ชื่อ", controller: _nameController),
                    SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromRGBO(74, 178, 132, 1),
                            Color.fromRGBO(101, 169, 200, 1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextButton(
                        child: const Text(
                          'บันทึก',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          _saveUserProfile();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    ).then((_) => _loadUserProfile()); // โหลดข้อมูลหลังจากปิด Dialog
  }

  @override
  void initState() {
    _loadUserProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "โปรไฟล์",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'NotoSansThai',
            ),
          ),
          centerTitle: true),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(101, 169, 200, 1), // End color
              Color.fromRGBO(74, 178, 132, 1), // Start color
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 20),
              // Profile Avatar and Name
              Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    backgroundImage: gender == "ชาย"
                        ? AssetImage('asset/im/men.png')
                        : gender == "หญิง"
                            ? AssetImage("asset/im/women2.png")
                            : null,
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${name}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        _Editname(context);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(width: 4),
                          Text(
                            'แก้ไขโปรไฟล์',
                            style: TextStyle(
                              color: Color.fromRGBO(255, 139, 89, 1),
                              fontSize: 14,
                            ),
                          ),
                          Image.asset('asset/im/edit.png')
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Menu Items
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(230, 230, 230, 1),
                    // borderRadius: BorderRadius.only(
                    //   topLeft: Radius.circular(30),
                    //   topRight: Radius.circular(30),
                    // ),
                  ),
                  child: Column(
                    children: [
                      Profilebutton(
                        // icon: Icons.person_outline,
                        url: 'asset/im/people.png',
                        title: 'ข้อมูลส่วนตัว',
                        onPressed: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ShowformPage()),
                          )
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Profilebutton(
                          url: 'asset/im/blood.png',
                          title: 'เชื่อมต่อกับอุปกรณ์',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ConnectToDexcom()),
                            );
                          }),
                      SizedBox(
                        height: 15,
                      ),
                      // Profilebutton(
                      //   url: 'asset/im/clock.png',
                      //   title: 'ประวัติการบริโภค',
                      //   onPressed: () {
                      //     widget.onNavigate(1);
                      //   },
                      // ),
                      // SizedBox(
                      //   height: 15,
                      // ),
                      Profilebutton(
                        url: 'asset/im/lock.png',
                        title: 'เปลี่ยนรหัสผ่าน',
                        onPressed: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChangePasswordPage()),
                          )
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      _buildLogoutButton(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Material(
      color: Color.fromRGBO(101, 169, 200, 1),
      borderRadius: BorderRadius.circular(8),
      elevation: 3,
      shadowColor: Colors.black,
      child: ListTile(
        leading: Image.asset('asset/im/out.png'),
        title: Text(
          "ออกจากระบบ",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            // fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: Colors.white,
        ),
        onTap: () async {
          _showConfirmationDialog(context);
        },
      ),
    );
  }
}
