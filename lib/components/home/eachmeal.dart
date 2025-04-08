import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:diabetes_meal_management_application_project/apis/Api_daymeal.dart';
import 'package:diabetes_meal_management_application_project/components/home/boxshowmeal.dart';

class Eachmeal extends StatefulWidget {
  const Eachmeal({super.key});

  @override
  State<Eachmeal> createState() => _EachmealState();
}

class _EachmealState extends State<Eachmeal> {
  DateTime effectiveDate = DateTime.now().hour > 19
      ? DateTime.now().add(Duration(days: 1))
      : DateTime.now().add(Duration(days: 0));
  String mainmealBreakfastname = '-';
  String mainmealLunchname = '-';
  String mainmealDinnername = '-';
  String fruitBreakfastname = '-';
  String fruitLunchname = '-';
  String fruitDinnername = '-';
  String beverageBreakfastname = '-';
  String beverageLunchname = '-';
  String beverageDinnername = '-';
  // bool isCheckedBreakfast = false;
  // bool isCheckedLunch = false;
  // bool isCheckedDinner = false; // State for checkbox
  bool breakfast_check = false;
  bool lunch_check = false;
  bool dinner_check = false;
  bool empty_breakfast_check = false;
  bool empty_lunch_check = false;
  bool empty_dinner_check = false;
  bool isLoading = true; // แสดงสถานะโหลดข้อมูล
  String breakfast_id = '';
  String lunch_id = '';
  String dinner_id = '';
  String mealPlan = '';
  @override
  void initState() {
    super.initState();
    initializeDateFormatting('th').then((_) {
      fetchData();
    });
  }

  void fetchData() {
    getBreakfast();
    getLunch();
    getDinner();
  }

  Future<void> refreshData() async {
    setState(() {
      fetchData();
    });
  }

  void getBreakfast() async {
    String today = DateFormat('yyyy-MM-dd').format(effectiveDate);
    var menus = await DaymealService.getBreakfast(today);
    if (menus == null) {
      empty_breakfast_check = true;
    }
    if (menus != null) {
      if (mounted) {
        setState(() {
          if (menus['data']['mainmeal'].isNotEmpty) {
            mainmealBreakfastname = menus['data']['mainmeal'][0]['name'];
          }
          if (menus['data']['fruit'].isNotEmpty) {
            fruitBreakfastname =
                menus['data']['fruit'].map((e) => e['name']).join(', ');
          }
          if (menus['data']['beverage'].isNotEmpty) {
            beverageBreakfastname = menus['data']['beverage'][0]['name'];
          }
          if (menus['data']['mainmeal'].isEmpty &&
              menus['data']['fruit'].isEmpty &&
              menus['data']['beverage'].isEmpty) {
            empty_breakfast_check = true;
          }
          breakfast_id = menus['data']['breakfast_id'];
          breakfast_check = menus['data']['breakfast_check_eat'] ?? false;
          // print("breakfast_ideachmeal:${breakfast_id}");
          // print("breakfast_checkeachmeal:${breakfast_check}");
          isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void getLunch() async {
    String today = DateFormat('yyyy-MM-dd').format(effectiveDate);
    var menus = await DaymealService.getLunch(today);
    if (menus == null) {
      empty_lunch_check = true;
    }
    if (menus != null) {
      if (mounted) {
        setState(() {
          if (menus['data']['mainmeal'].isNotEmpty) {
            mainmealLunchname = menus['data']['mainmeal'][0]['name'];
          }
          if (menus['data']['fruit'].isNotEmpty) {
            fruitLunchname =
                menus['data']['fruit'].map((e) => e['name']).join(', ');
          }
          if (menus['data']['beverage'].isNotEmpty) {
            beverageLunchname = menus['data']['beverage'][0]['name'];
          }
          if (menus['data']['mainmeal'].isEmpty &&
              menus['data']['fruit'].isEmpty &&
              menus['data']['beverage'].isEmpty) {
            empty_lunch_check = true;
          }
          // print("empty_check:${empty_lunch_check}");
          lunch_id = menus['data']['lunch_id'];
          lunch_check = menus['data']['lunch_check_eat'] ?? false;
          print("lunch_check:${lunch_check}");
          // print("lunch_id:${lunch_id}");
          isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void getDinner() async {
    String today = DateFormat('yyyy-MM-dd').format(effectiveDate);
    var menus = await DaymealService.getDinner(today);

    if (menus == null) {
      empty_dinner_check = true;
    }
    if (menus != null) {
      if (mounted) {
        setState(() {
          if (menus['data']['mainmeal'].isNotEmpty) {
            mainmealDinnername = menus['data']['mainmeal'][0]['name'];
          }
          if (menus['data']['fruit'].isNotEmpty) {
            fruitDinnername =
                menus['data']['fruit'].map((e) => e['name']).join(', ');
          }
          if (menus['data']['beverage'].isNotEmpty) {
            beverageDinnername = menus['data']['beverage'][0]['name'];
          }
          if (menus['data']['mainmeal'].isEmpty &&
              menus['data']['fruit'].isEmpty &&
              menus['data']['beverage'].isEmpty) {
            empty_dinner_check = true;
          }
          dinner_id = menus['data']['dinner_id'];
          dinner_check = menus['data']['dinner_check_eat'] ?? false;
          // print("dinner_id:${dinner_id}");
          isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.only(left: 10, right: 10),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 81,
                  child: Column(
                    children: [
                      Text(
                        DateFormat('EEEE', 'th').format(effectiveDate),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(74, 178, 132, 1),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Text(
                          DateFormat('dd').format(effectiveDate),
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Boxshowmeal(
                      breakfast_check: breakfast_check,
                      lunch_check: lunch_check,
                      dinner_check: dinner_check,
                      empty_breakfast_check: empty_breakfast_check,
                      effectiveDate: effectiveDate,
                      mealPlan: "แผนอาหารมื้อเช้าของคุณ",
                      fruitBreakfastname: fruitBreakfastname,
                      beverageBreakfastname: beverageBreakfastname,
                      mainmealBreakfastname: mainmealBreakfastname,
                      fruitLunchname: fruitLunchname,
                      beverageLunchname: beverageLunchname,
                      mainmealLunchname: mainmealLunchname,
                      fruitDinnername: fruitDinnername,
                      beverageDinnername: beverageDinnername,
                      mainmealDinnername: mainmealDinnername,
                      breakfast_id: breakfast_id,
                      lunch_id: lunch_id,
                      dinner_id: dinner_id,
                      empty_lunch_check: empty_lunch_check,
                      empty_dinner_check: empty_dinner_check,
                      onMealConfirmed: () async {
                        await refreshData(); // Wait for the data to refresh
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      width: 230,
                      child: Divider(
                        color: Color.fromRGBO(231, 230, 230, 1),
                        thickness: 2,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Boxshowmeal(
                      breakfast_check: breakfast_check,
                      lunch_check: lunch_check,
                      dinner_check: dinner_check,
                      empty_breakfast_check: empty_breakfast_check,
                      effectiveDate: effectiveDate,
                      mealPlan: "แผนอาหารมื้อกลางวันของคุณ",
                      fruitBreakfastname: fruitBreakfastname,
                      beverageBreakfastname: beverageBreakfastname,
                      mainmealBreakfastname: mainmealBreakfastname,
                      fruitLunchname: fruitLunchname,
                      beverageLunchname: beverageLunchname,
                      mainmealLunchname: mainmealLunchname,
                      fruitDinnername: fruitDinnername,
                      beverageDinnername: beverageDinnername,
                      mainmealDinnername: mainmealDinnername,
                      breakfast_id: breakfast_id,
                      lunch_id: lunch_id,
                      dinner_id: dinner_id,
                      empty_lunch_check: empty_lunch_check,
                      empty_dinner_check: empty_dinner_check,
                      onMealConfirmed: () async {
                        await refreshData(); // Wait for the data to refresh
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      width: 230,
                      child: Divider(
                        color: Color.fromRGBO(231, 230, 230, 1),
                        thickness: 2,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Boxshowmeal(
                      breakfast_check: breakfast_check,
                      lunch_check: lunch_check,
                      dinner_check: dinner_check,
                      empty_breakfast_check: empty_breakfast_check,
                      effectiveDate: effectiveDate,
                      mealPlan: "แผนอาหารมื้อเย็นของคุณ",
                      fruitBreakfastname: fruitBreakfastname,
                      beverageBreakfastname: beverageBreakfastname,
                      mainmealBreakfastname: mainmealBreakfastname,
                      fruitLunchname: fruitLunchname,
                      beverageLunchname: beverageLunchname,
                      mainmealLunchname: mainmealLunchname,
                      fruitDinnername: fruitDinnername,
                      beverageDinnername: beverageDinnername,
                      mainmealDinnername: mainmealDinnername,
                      breakfast_id: breakfast_id,
                      lunch_id: lunch_id,
                      dinner_id: dinner_id,
                      empty_lunch_check: empty_lunch_check,
                      empty_dinner_check: empty_dinner_check,
                      onMealConfirmed: () async {
                        await refreshData(); // Wait for the data to refresh
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
