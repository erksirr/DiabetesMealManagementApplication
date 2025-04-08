import 'package:flutter/material.dart';
import 'package:diabetes_meal_management_application_project/components/successalert.dart';

class Savebutton extends StatefulWidget {
  final int save;
  final int check;
  final int changepassword;
  final void Function()? onReset; // เพิ่ม '?' เพื่อให้รองรับค่า null
  final void Function()? onPressed; // เพิ่ม onPressed เป็นตัวเลือก

  Savebutton({
    Key? key,
    required this.save,
    required this.check,
    this.changepassword = 0,
    this.onReset,
    this.onPressed,
  }) // เอา required ออก
  : super(key: key);

  @override
  State<Savebutton> createState() => _SavebuttonState();
}

class _SavebuttonState extends State<Savebutton> {
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Successalert(); // เรียกใช้ dialog ยืนยัน
      },
    ).then((_) {
      if (widget.onReset != null) {
        // ตรวจสอบว่า onReset มีค่าอยู่หรือไม่
        widget.onReset!(); // รีเซ็ตเมนูทั้งหมดหลังจากแสดง Dialog เสร็จ
      }
    });
  }

  @override
  void initState() {
    print("save");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: GestureDetector(
        onTap: widget.save == 1
            ? () {
                if (widget.onPressed != null) {
                  widget.onPressed!(); // เรียกฟังก์ชัน onPressed

                  _showSuccessDialog(context); // แสดง dialog ยืนยัน
                } else if (widget.check == 2) {
                  _showSuccessDialog(context); // แสดง dialog ยืนยัน
                }
              }
            : null,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 9,
            vertical: 7,
          ),
          decoration: widget.save == 1
              ? BoxDecoration(
                  color: Color.fromRGBO(74, 178, 132, 1),
                  borderRadius: BorderRadius.circular(8))
              : null,
          child: Text(
            "บันทึก",
            style: TextStyle(
              color: widget.save == 1
                  ? Colors.white
                  : Color.fromRGBO(184, 184, 184, 1),
              fontWeight: FontWeight.w700,
              fontSize: widget.save == 1 ? 16 : 18,
            ),
          ),
        ),
      ),
    );
  }
}
