import 'dart:math';

import 'package:flutter/material.dart';
import 'package:diabetes_meal_management_application_project/apis/Api_profile.dart';

class Nutritioncard extends StatefulWidget {
  final String name;
  final double carbohydrate;
  final double sugar;
  final double fat;
  final double sodium;
  final double calories;
  final double protein;
  final String path;

  const Nutritioncard(
      {Key? key,
      required this.name,
      required this.carbohydrate,
      required this.protein,
      required this.sugar,
      required this.fat,
      required this.sodium,
      required this.calories,
      this.path = ''})
      : super(key: key);

  @override
  State<Nutritioncard> createState() => _NutritioncardState();
}

class _NutritioncardState extends State<Nutritioncard> {
  double maxCarb = 0;
  double maxProtein = 0;
  double maxFat = 0;
  double maxEnergy = 0; // ค่า TDEE

  @override
  void initState() {
    super.initState();
    fetchMaxValues();
  }

  Future<void> fetchMaxValues() async {
    var tdeeData = await Profile.calculateCalories();
    if (tdeeData != null && mounted) {
      double tdee = double.tryParse(tdeeData['tdee'].toString()) ?? 0;
      setState(() {
        maxEnergy = tdee;
        maxCarb = double.parse(((50 / 100) * tdee / 4).toStringAsFixed(1));
        maxProtein = double.parse(((20 / 100) * tdee / 4).toStringAsFixed(1));
        maxFat = double.parse(((30 / 100) * tdee / 9).toStringAsFixed(1));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: EdgeInsets.only(left: 2, right: 2, top: 10, bottom: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                widget.name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  nutritioncolumn(widget.carbohydrate, "คาร์โบไฮเดรต", "กรัม",
                      maxCarb, true),
                  nutritioncolumn(widget.sugar, "น้ำตาล", "กรัม", 30, true),
                  nutritioncolumn(
                      widget.sodium, "โซเดียม", "มิลลิกรัม", 2200, true),
                  nutritioncolumn(
                      widget.protein, "โปรตีน", "กรัม", maxProtein, false),
                  nutritioncolumn(widget.fat, "ไขมัน", "กรัม", maxFat, true),
                ],
              ),
              widget.path != 'history'
                  ? SizedBox(height: 10)
                  : SizedBox.shrink(),
              widget.path != 'history'
                  ? Column(
                      children: [
                        nutritiontier(maxCarb, "คาร์โบไฮเดรต"),
                        nutritiontier(30, "น้ำตาล"),
                        nutritiontier(2200, "โซเดียม"),
                        nutritiontier(maxProtein, "โปรตีน"),
                        nutritiontier(maxFat, "ไขมัน"),
                      ],
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget nutritioncolumn(double value, String title, String unit,
      double threshold, bool isHigherBad) {
    bool isOutOfRange = isHigherBad ? value > threshold : value < threshold;
    bool isZero = value == 0; // ถ้าค่าเป็น 0 ให้แดงแน่นอน

    return Container(
      width: 65,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Color.fromRGBO(230, 230, 230, 1), width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 10,
                  color: Colors.black,
                  fontWeight: FontWeight.w600)),
          SizedBox(height: 4),
          Text(
            "$value",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: (title == "โปรตีน") && (isZero || isOutOfRange)
                  ? Color.fromRGBO(255, 116, 56, 1) // สีส้มสำหรับโปรตีน
                  : (isZero || isOutOfRange ? Colors.red : Color(0xFF4AB284)),
            ),
          ),
          SizedBox(height: 4),
          Text(unit,
              style: TextStyle(
                  fontSize: 10,
                  color: Colors.black,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget nutritiontier(double maxParam, String textParam) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${textParam}ที่เหมาะสมต่อวันไม่ควร",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          textParam != 'โปรตีน'
              ? Text(
                  "เกิน",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.red
                  ),
                )
              : Text(
                  "*น้อยกว่า",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.red
                  ),
                ),
          Text(
            " ${maxParam}", // Show maxEnergy with 1 decimal place
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              // color: Color(0xFFFF7E47),
            ),
          ),
          Text(
            " กิโลแคลอรี่",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
