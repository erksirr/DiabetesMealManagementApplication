import 'package:flutter/material.dart';

class BMICategoryBox extends StatelessWidget {
  final int height; // Height in cm
  final int weight; // Weight in kg

  const BMICategoryBox({
    Key? key,
    required this.height,
    required this.weight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double bmi = _calculateBMI(); // Calculate BMI
    String bmiCategory = _getBMICategory(bmi); // Get BMI category
    String bmiImage = _getBMIImage(bmi); // Select image based on BMI
    List<Color> gradientColors = _getBMIGradientColors(bmi); // Gradient colors

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// ✅ **BMI Image (Left)**
        Image.asset(
          'asset/im/$bmiImage', // Dynamic BMI image
          height: 150,
          width: 120,
        ),
        SizedBox(width: 12), // Spacing between image and text content

        /// ✅ **BMI Info (Right)**
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// **Bold BMI Text**
              Text(
                "BMI ${bmi.toStringAsFixed(2)}", // Format BMI to 2 decimal places
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),

              /// **BMI Category Box**
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradientColors,
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  bmiCategory,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 8),

              /// **Additional Health Information**
              _buildDetailRow("ส่วนสูง", "$height ซม."),
              _buildDetailRow("น้ำหนัก", "$weight กก."),
              // _buildDetailRow("น้ำตาลในเลือด", "$bloodSugar มก.ดล."),
            ],
          ),
        ),
      ],
    );
  }

  /// ✅ **Calculate BMI**
  double _calculateBMI() {
    double heightInMeters = height / 100; // Convert height to meters
    return weight / (heightInMeters * heightInMeters); // BMI Formula
  }

  /// ✅ **Determine BMI Category**
  String _getBMICategory(double bmi) {

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

  /// ✅ **Select BMI Image based on BMI value**
  String _getBMIImage(double bmi) {
    if (bmi < 18.5) {
      return "bmi1.png"; // Underweight
    } else if (bmi < 24.9) {
      return "bmi2.png"; // Normal weight
    } else if (bmi < 29.9) {
      return "bmi3.png"; // Overweight
    } else if (bmi < 34.9) {
      return "bmi4.png"; // Obesity 1
    } else {
      return "bmi5.png"; // Obesity 2
    }
  }

  /// ✅ **Change Gradient Colors based on BMI**
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

  /// ✅ **Helper function to align text properly**
  Widget _buildDetailRow(String title, String value) {
    return Row(
      children: [
        SizedBox(
          width: 120, // Ensuring alignment of labels
          child: Text(
            title,
            style: TextStyle(fontSize: 16),
          ),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
