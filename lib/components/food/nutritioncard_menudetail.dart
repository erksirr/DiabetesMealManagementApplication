
import 'package:flutter/material.dart';

class NutritioncardMenudetail extends StatefulWidget {
  final String name;
  final double carbohydrate;
  final double sugar;
  final double fat;
  final double sodium;
  final double calories;
  final double protein;

  const NutritioncardMenudetail({
    Key? key,
    required this.name,
    required this.carbohydrate,
    required this.protein,
    required this.sugar,
    required this.fat,
    required this.sodium,
    required this.calories,
  }) : super(key: key);

  @override
  State<NutritioncardMenudetail> createState() => _NutritioncardMenudatailState();
}

class _NutritioncardMenudatailState extends State<NutritioncardMenudetail> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.3),
        //     spreadRadius: 2,
        //     blurRadius: 5,
        //     offset: Offset(0, 1),
        //   ),
        // ],
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
                  // nutritioncolumn(carbohydrate, "คาร์โบไฮเดรต", "กรัม"),

                  nutritioncolumn(widget.carbohydrate, "คาร์โบไฮเดรต", "กรัม"),

                  nutritioncolumn(widget.sugar, "น้ำตาล", "กรัม"),
                  nutritioncolumn(widget.sodium, "โซเดียม", "มิลลิกรัม"),
                  nutritioncolumn(widget.protein, "โปรตีน", "กรัม"),
                  nutritioncolumn(widget.fat, "ไขมัน", "มิลลิกรัม"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget nutritioncolumn(double value, String title, String unit) {
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
                color: Color(0xFF4AB284)),
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
}
