import 'dart:math';

import 'package:flutter/material.dart';
import 'package:diabetes_meal_management_application_project/apis/Api_daymeal.dart';
import 'package:diabetes_meal_management_application_project/apis/Api_menu.dart';
import 'package:diabetes_meal_management_application_project/components/confirmpopup.dart';
import 'package:diabetes_meal_management_application_project/components/home/bloodsugarlevel.dart';
import 'package:diabetes_meal_management_application_project/components/home/boxshowmeal.dart';
import 'package:diabetes_meal_management_application_project/components/home/eachmeal.dart';
import 'package:diabetes_meal_management_application_project/components/home/header.dart';
import 'package:diabetes_meal_management_application_project/components/home/menuListview.dart';
import 'package:get/get.dart';
import 'package:diabetes_meal_management_application_project/controllers/blood_sugar_controller.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:diabetes_meal_management_application_project/controllers/connection_controller.dart';

class RecommendMenuPage extends StatefulWidget {
  const RecommendMenuPage({super.key});

  @override
  State<RecommendMenuPage> createState() => _RecommendMenuPageState();
}

class _RecommendMenuPageState extends State<RecommendMenuPage> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  bool isConnected = false;
  DateTime selectedDate = DateTime.now().add(Duration(days: 0));

  DateTime effectiveDate = DateTime.now().hour > 19
      ? DateTime.now().add(Duration(days: 1))
      : DateTime.now();
  List<Map<String, dynamic>> recommendmenuList = [];
  List<Map<String, dynamic>> fruitmenuList = [];
  List<Map<String, dynamic>> beveragesmenuList = [];
  bool isLoading = true; // แสดงสถานะโหลดข้อมูล
  var controller = Get.find<ConnectionController>();

  String mainmealBreakfastname = '-';
  String mainmealLunchname = '-';
  String mainmealDinnername = '-';
  String fruitBreakfastname = '-';
  String fruitLunchname = '-';
  String fruitDinnername = '-';
  String beverageBreakfastname = '-';
  String beverageLunchname = '-';
  String beverageDinnername = '-';
  String breakfast_id = '';
  String lunch_id = '';
  String dinner_id = '';
  String mealPlan = '';
  bool breakfast_check = false;
  bool lunch_check = false;
  bool dinner_check = false;
  bool empty_breakfast_check = false;
  bool empty_lunch_check = false;
  bool empty_dinner_check = false;
  @override
  void initState() {
    super.initState();
    initializeDateFormatting('th').then((_) {
      fetchData();
      fetchRecommendedMenus();
    });
  }

  void fetchData() {
    print("fetch");
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
          // print("breakfast_id:${breakfast_id}");
          // print("breakfast_check:${breakfast_check}");
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

          lunch_id = menus['data']['lunch_id'];
          lunch_check = menus['data']['lunch_check_eat'] ?? false;
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

  void fetchRecommendedMenus() async {
    var menus = await MenuService.getMenuRecommend();
    if (menus != null) {
      if (mounted) {
        setState(() {
          recommendmenuList = _parseMenuData(menus['menu']['mainmeal']);
          fruitmenuList = _parseMenuData(menus['menu']['fruit']);
          beveragesmenuList = _parseMenuData(menus['menu']['beverages']);
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
    // print(recommendmenuList);
    // print(fruitmenuList);
    // print(beveragesmenuList);
  }

  List<Map<String, dynamic>> _parseMenuData(List<dynamic>? menuData) {
    if (menuData == null) return [];
    return menuData
        .map((item) => {
              'name': item['name'] ?? 'ไม่มีชื่อเมนู',
              'Url': item['menu_img'] ?? 'asset/im/bmi1.png',
              'menu_id': item['menu_id'],
              'category_id': item['category_id'],
              'nutrition': item['nutrition'],
              'color': item['color'],
            })
        .toList();
  }

  String getMealPlan(int hour) {
    if (hour >= 7 && hour < 11) {
      return "แผนอาหารมื้อเช้าของคุณ";
    } else if (hour >= 11 && hour < 15) {
      return "แผนอาหารมื้อกลางวันของคุณ";
    } else if (hour >= 15 && hour <= 19) {
      return "แผนอาหารมื้อเย็นของคุณ";
    } else if (hour >= 0 && hour < 7) {
      return "แผนอาหารมื้อเช้าของวันนี้";
    } else {
      return "แผนอาหารมื้อเช้าของวันถัดไป";
    }
  }

  @override
  Widget build(BuildContext context) {
    void _showEachmeal(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) {
          return Eachmeal(); // เรียกใช้ dialog ยืนยัน
        },
      ).then((_) {
        print("Dialog closed, calling fetchData()"); // Debugging
        fetchData();
      });
    }

    int currentHour = DateTime.now().hour;
    // print("currentHour:${currentHour}");
    // print("effectDate:${effectiveDate}");
    // print("selectedDate:${selectedDate}");
    // String mealPlan = getMealPlan(currentHour);
    mealPlan = getMealPlan(currentHour);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // BloodSugarLevel(bloodSugarLevel: 169),
          Obx(() {
            var blood = Get.find<BloodSugarController>();
            var controller = Get.find<ConnectionController>();
            return BloodSugarLevel(
                bloodSugarLevel: (controller.isConnected.value == false)
                    ? "--"
                    : blood.bloodSugar.value.toString(),
                timestamp: (controller.isConnected.value == false)
                    ? "--"
                    : blood.bloodSugarTimestamp.value);
          }),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: controller.isConnected.value
                        ? Color.fromRGBO(74, 178, 132, 1)
                        : Color.fromRGBO(218, 22, 22, 1),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  controller.isConnected.value
                      ? "เชื่อมต่ออุปกรณ์อยู่"
                      : "ยังไม่ได้เชื่อมต่ออุปกรณ์",
                  style: TextStyle(
                      color: controller.isConnected.value
                          ? Color.fromRGBO(74, 178, 132, 1)
                          : Color.fromRGBO(218, 22, 22, 1),
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 10),
            child: Text(
              "คลิกที่กล่องเพื่อดูมื้อถัดไป",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 10),
            child: GestureDetector(
              onTap: () {
                _showEachmeal(context);
              },
              child: Container(
                // height: 168,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 81,
                            child: Column(
                              children: [
                                Text(
                                  DateFormat('EEEE', 'th').format(selectedDate),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(74, 178, 132, 1),
                                    borderRadius: BorderRadius.circular(9),
                                  ),
                                  child: Text(
                                    DateFormat('dd').format(selectedDate),
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
                          Boxshowmeal(
                            breakfast_check: breakfast_check,
                            lunch_check: lunch_check,
                            dinner_check: dinner_check,
                            empty_breakfast_check: empty_breakfast_check,
                            effectiveDate: effectiveDate,
                            mealPlan: mealPlan,
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
                ),
              ),
            ),
          ),
          Header(
            title: "เมนูอาหาร",
            titletips_type: "a",
            titletips_name: "คำแนะนำในการเลือกเมนูอาหาร",
            titletips_p1: "เลือกอาหารประเภทต้ม นึ่ง ย่าง ปิ้ง ยำ แทนการทอด",
            titletips_p2:
                "หลีกเลี่ยงอาหารที่มีไขมันสูง เช่น อาหารทอด อาหารใส่กะทิ",
          ),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Menulistview(
                  menulist: recommendmenuList, path: "MenulistviewRecommend"),
          Header(
            title: "ผลไม้",
            titletips_type: "b",
            titletips_name: "คำแนะนำในการทานผลไม้",
            titletips_p1:
                "เลือกรสที่ไม่หวานจัด และกินในปริมาณที่เหมาะสม เช่น 1 ลูกขนาดกำปั้น หรือ 10 ชิ้นคำ",
            titletips_p2: "หลีกเลี่ยงผลไม้ที่มีน้ำตาลสูง เช่น ทุเรียน ลำไย",
          ),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Menulistview(
                  menulist: fruitmenuList, path: "MenulistviewRecommend"),
          Header(
            title: "เครื่องดื่ม",
            titletips_type: "c",
            titletips_name: "คำแนะนำในการเลือกเครื่องดื่ม",
            titletips_p1: "เลือกเครื่องดื่มที่มีโปรตีน ไม่มีน้ำตาล และไขมันต่ำ",
            titletips_p2:
                "หลีกเลี่ยงเครื่องดื่มที่มีน้ำตาลสูง เช่น น้ำอัดลม และเครื่องดื่มชูกำลัง",
          ),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Menulistview(
                  menulist: beveragesmenuList, path: "MenulistviewRecommend"),
        ],
      ),
    );
  }
}
