import 'package:flutter/material.dart';

class BMIWidget extends StatefulWidget {
  final double weight;
  final double height;
  final double maxEnergy;
  final double accumulatedEnergy;

  const BMIWidget({
    super.key,
    required this.weight,
    required this.height,
    required this.maxEnergy,
    required this.accumulatedEnergy,
  });

  @override
  State<BMIWidget> createState() => _BMIWidgetState();
}

class _BMIWidgetState extends State<BMIWidget> {
  double bmi = 0;

  String getBMIStatus(double bmi) {

      if (bmi < 18.5) {
      return "น้ำหนักต่ำกว่าเกณฑ์"; // Underweight
    } else if (bmi < 24.9) {
      return "น้ำหนักปกติ"; // Normal weight
    } else if (bmi < 29.9) {
      return "น้ำหนักเกิน"; // Overweight
    } else if (bmi < 34.9) {
      return "โรคอ้วนระดับ 1"; // Obesity level 1
    } else {
      return "โรคอ้วนระดับ 2"; // Obesity level 2
    }
  }

  List<Color> _getBMIGradientColors(double bmi) {

    if (bmi < 18.5) {
      return [
        Color(0xFF01A6AA),
        Color(0xFF7CD6FF)
      ]; // Light Blue gradient for Underweight
    } else if (bmi < 24.9) {
      return [
        Color(0xFF2EA933),
        Color(0xFFA2EEA5)
      ]; // Green gradient for Normal weight
    } else if (bmi < 29.9) {
      return [
        Color.fromARGB(255, 252, 185, 0),
        Color.fromARGB(255, 253, 219, 23)
      ]; // Orange gradient for Overweight
    } else if (bmi < 34.9) {
      return [
        Color(0xFFFF8B59),
        Color(0xFFFF9C2C)
      ]; // Red gradient for Obesity 1
    } else {
      return [
        Color(0xFFD32F2F),
        Color(0xFFF44336)
      ]; // Dark Purple gradient for Obesity 2
    }
  }
  double _calculateBMI() {
    double heightInMeters = widget.height / 100; // Convert height to meters
    return widget.weight / (heightInMeters * heightInMeters); // BMI Formula
  }
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    
  double bmi = _calculateBMI(); // Calculate BMI
  late List<Color> gradientColors = _getBMIGradientColors(bmi);
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(241, 241, 241, 1),
        borderRadius: BorderRadius.circular(12),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.1),
        //     blurRadius: 5,
        //     spreadRadius: 2,
        //   ),
        // ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 🔹 กล่องแสดง BMI
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                children: [
                  Text(
                    "BMI ${bmi.toStringAsFixed(1)} | ${getBMIStatus(bmi)}",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          // 🔹 SizedBox เว้นระยะ
          SizedBox(height: 14),

          // 🔹 พลังงานที่ใช้ / พลังงานสูงสุด
          Container(
            decoration: BoxDecoration(
              color: Colors.white, // พื้นหลังสีฟ้าอ่อน
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "พลังงานที่เหมาะสมต่อวัน ",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    " ${widget.accumulatedEnergy} /",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(74, 178, 132, 1),
                    ),
                  ),
                  Text(
                    " ${widget.maxEnergy.toStringAsFixed(1)}", // Show maxEnergy with 1 decimal place
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFFF7E47),
                    ),
                  ),
                  Text(
                    " กิโลแคลอรี่",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
