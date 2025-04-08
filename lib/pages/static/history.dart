import 'package:flutter/material.dart';
import 'package:diabetes_meal_management_application_project/apis/Api_daymeal.dart';
import 'package:diabetes_meal_management_application_project/components/nutritioncard.dart';
import 'package:diabetes_meal_management_application_project/components/static/foodcategorycard.dart';
import 'package:intl/intl.dart';
import 'package:diabetes_meal_management_application_project/pages/static/beverages.dart';
import 'package:diabetes_meal_management_application_project/pages/static/fruit.dart';
import 'package:diabetes_meal_management_application_project/pages/static/mainmeal.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  DateTime selectedDate = DateTime.now();
  Map<int, List<Map<String, dynamic>>> mealData = {};
  Map<String, dynamic>? nutritionData;
  int count = 0;
  double calories = 0;
  double carbohydrate = 0;
  double sugar = 0;
  double fat = 0;
  double sodium = 0;
  double protein = 0;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() {
    for (int id = 1; id <= 3; id++) {
      _getMealData(id);
    }
    _getNutritionData(); // Fetch the nutrition summary as well
  }

  Future<void> _getMealData(int categoryId) async {
    String date = DateFormat('yyyy-MM-dd').format(selectedDate);
    var data =
        await DaymealService.getHistoryMenu(categoryId: categoryId, date: date);
    if (mounted) {
      setState(() {
        mealData[categoryId] = _parseMenuData(data);
      });
    }
  }

  Future<void> _getNutritionData() async {
    String date = DateFormat('yyyy-MM-dd').format(selectedDate);
    var data = await DaymealService.getNutritionHistory(date: date);
    // print("data:$data");
    // print("datamenu:${data?["menu"]}");
    if (mounted) {
      setState(() {
        nutritionData =
            data?["menu"]["nutrition"]; // Store nutrition data when fetched
        if (nutritionData != null) {
          calories = double.parse(
              (nutritionData?['calories']?['amount'] ?? 0).toStringAsFixed(2));
          carbohydrate = double.parse(
              (nutritionData?['carbohydrate']?['amount'] ?? 0)
                  .toStringAsFixed(2));
          sugar = double.parse(
              (nutritionData?['sugar']?['amount'] ?? 0).toStringAsFixed(2));
          fat = double.parse(
              (nutritionData?['fat']?['amount'] ?? 0).toStringAsFixed(2));
          sodium = double.parse(
              (nutritionData?['sodium']?['amount'] ?? 0).toStringAsFixed(2));
          protein = double.parse(
              (nutritionData?['protein']?['amount'] ?? 0).toStringAsFixed(2));
        } else {
          calories = 0;
          carbohydrate = 0;
          sugar = 0;
          fat = 0;
          sodium = 0;
          protein = 0;
        }
      });
    }
  }

  List<Map<String, dynamic>> _parseMenuData(dynamic menuData) {
    if (menuData is! List) return [];
    return menuData
        .map((item) => {
              'name': item['name'] ?? 'ไม่มีชื่อเมนู',
              'Url': item['menu_img'] ?? 'asset/im/bmi1.png',
              'menu_id': item['menu_id'],
              'time': item['date'],
              'meal': item['meal'],
              'color': item['color']
            })
        .toList();
  }

  void _changeDate(int days) {
    setState(() => selectedDate = selectedDate.add(Duration(days: days)));
    fetchData();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.orange, // Header background color
            colorScheme: ColorScheme.light(
              primary: Colors.orange, // Selected date color
              onPrimary: Colors.white, // Text color for selected date
              onSurface: Colors.black, // Default text color
            ),
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary, // Button text color
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
      fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        "${selectedDate.day} ${DateFormat('MMMM', 'th').format(selectedDate)} ${selectedDate.year + 543}";

    return Scaffold(
      body: Container(
        color: Color.fromRGBO(241, 241, 241, 1),
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey.withOpacity(0.3),
                //     spreadRadius: 2,
                //     blurRadius: 5,
                //     offset: Offset(0, 2),
                //   ),
                // ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 2.0, color: Colors.black),
                          ),
                          padding: EdgeInsets.only(left: 5),
                          child: Icon(Icons.arrow_back_ios,
                              color: Colors.black, size: 10),
                        ),
                        onPressed: () => _changeDate(-1),
                      ),
                      Text(
                        formattedDate,
                        style: TextStyle(color: Colors.black),
                      ),
                      RotatedBox(
                        quarterTurns: 2,
                        child: IconButton(
                          icon: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(width: 2.0, color: Colors.black),
                            ),
                            padding: EdgeInsets.only(left: 5),
                            child: Icon(Icons.arrow_back_ios,
                                color: Colors.black, size: 10),
                          ),
                          onPressed: () => _changeDate(1),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.calendar_month, color: Colors.black),
                        onPressed: () => _selectDate(context),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Foodcategorycard(
                          label: "อาหาร",
                          imageUrl: 'asset/im/mainmeal.png',
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainmealPage(),
                              settings: RouteSettings(
                                arguments: {'menuList': mealData[1] ?? []},
                              ),
                            ),
                          ),
                          number: mealData[1]?.length ?? 0,
                        ),
                        SizedBox(height: 15),
                        Foodcategorycard(
                          label: "เครื่องดื่ม",
                          imageUrl: 'asset/im/beverage.png',
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BeveragesPage(),
                              settings: RouteSettings(
                                arguments: {'menuList': mealData[3] ?? []},
                              ),
                            ),
                          ),
                          number: mealData[3]?.length ?? 0,
                        ),
                        SizedBox(height: 15),
                        Foodcategorycard(
                          label: "ผลไม้",
                          imageUrl: 'asset/im/snack.png',
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FruitPage(),
                              settings: RouteSettings(
                                arguments: {'menuList': mealData[2] ?? []},
                              ),
                            ),
                          ),
                          number: mealData[2]?.length ?? 0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Display NutritionCard if nutrition data is available

            Nutritioncard(
                path: 'history',
                name: "ข้อมูลโภชนาการ",
                carbohydrate: carbohydrate,
                sugar: sugar,
                fat: fat,
                sodium: sodium,
                protein: protein,
                calories: calories),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.white, // พื้นหลังสีฟ้าอ่อน
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "พลังงานที่รับประทานวันนี้ ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      " ${calories}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(74, 178, 132, 1),
                      ),
                    ),
                    Text(
                      " กิโลแคลอรี่",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            // Show loading if data is not available yet
          ],
        ),
      ),
    );
  }
}
