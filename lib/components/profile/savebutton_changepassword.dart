import 'package:flutter/material.dart';

class Savebuttonchangepassword extends StatefulWidget {
  final Function() onPressed; // เพิ่ม onPressed เป็นตัวเลือก

  Savebuttonchangepassword({
    Key? key,
    required this.onPressed,
  }) // เอา required ออก
  : super(key: key);

  @override
  State<Savebuttonchangepassword> createState() =>
      _SavebuttonchangepasswordState();
}

class _SavebuttonchangepasswordState extends State<Savebuttonchangepassword> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 9,
            vertical: 7,
          ),
          decoration: BoxDecoration(
              color: Color.fromRGBO(74, 178, 132, 1),
              borderRadius: BorderRadius.circular(8)),
          child: Text(
            "บันทึก",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
