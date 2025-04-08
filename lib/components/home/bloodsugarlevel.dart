import 'package:flutter/material.dart';

class BloodSugarLevel extends StatefulWidget {
  final String bloodSugarLevel; // Still a string, allows "--" to be passed
  final String timestamp; // Still a string, allows "--" to be passed

  const BloodSugarLevel({
    Key? key,
    required this.bloodSugarLevel,
    this.timestamp = '',
  }) : super(key: key);

  @override
  State<BloodSugarLevel> createState() => _BloodSugarLevelState();
}

class _BloodSugarLevelState extends State<BloodSugarLevel> {
  @override
  Widget build(BuildContext context) {
    final double? bloodSugar = double.tryParse(widget.bloodSugarLevel);

    return Container(
      width: 357,
      height: 85,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        gradient: (bloodSugar != null && (bloodSugar > 180 || bloodSugar < 70))
            ? LinearGradient(
                colors: [
                  Color.fromRGBO(255, 116, 56, 1),
                  Color.fromRGBO(218, 22, 22, 1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [
                  Color(0xFF4AB284),
                  Color(0xFF65A9C8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 51.33,
            height: 60.61,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('asset/im/bloodsugarplus.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('ค่าระดับน้ำตาลที่วัดได้',
                  style: TextStyle(fontSize: 17, color: Colors.white)),
              Text('ณ เวลา ${widget.timestamp}',
                  style: TextStyle(fontSize: 17, color: Colors.white)),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.bloodSugarLevel,
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                'มิลลิกรัม/เดซิลิตร',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
