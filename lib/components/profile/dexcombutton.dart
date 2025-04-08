import 'package:flutter/material.dart';

class ConnectToDexcomButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  final Color? buttonColor;
  final IconData? icon;
  final bool isConnected;
  const ConnectToDexcomButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.buttonColor,
    this.icon,
    this.isConnected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // ขอบมน
      ),
      elevation: 2, // เพิ่มเงา
      color:
          buttonColor ?? Colors.white, // ใช้สีที่กำหนด หรือ default เป็นสีขาว
      child: ListTile(
        leading:Image.asset("asset/im/dexcom.png", width: 40, height: 40,),
        title: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                color: buttonColor == Colors.red ? Colors.white : Colors.grey[800],
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
        trailing: icon != null
            ? Icon(
                icon,
                color: isConnected
                    ? Color.fromRGBO(74, 178, 132, 1)
                    : Colors.grey[700],
                size: 40,
              )
            : null, // ไอคอนลูกศร
        onTap: () {
          onPressed();
        },
      ),
    );
  }
}
