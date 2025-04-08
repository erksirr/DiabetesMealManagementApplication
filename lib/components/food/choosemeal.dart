import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:diabetes_meal_management_application_project/apis/Api_daymeal.dart';
import 'package:diabetes_meal_management_application_project/components/auth/showerrordialog.dart';
import 'package:diabetes_meal_management_application_project/pages/home/allmeal.dart';

class Choosemeal extends StatefulWidget {
  final Map<String, dynamic> args;

  const Choosemeal({super.key, required this.args});
  @override
  State<Choosemeal> createState() => _ChoosemealState();
}

class _ChoosemealState extends State<Choosemeal> {
  DateTime selectedDate = DateTime.now();
  DateTime effectiveDate = DateTime.now().hour > 19
      ? DateTime.now().add(Duration(days: 1))
      : DateTime.now().add(Duration(days: 0));
  bool isEatenBreakfast = false;
  bool isEatenLunch = false;
  bool isEatenDinner = false;

  bool mainmealBreakfastCheck = false;
  bool mainmealLunchCheck = false;
  bool mainmealDinnerCheck = false;
  bool beverageBreakfastCheck = false;
  bool beverageLunchCheck = false;
  bool beverageDinnerCheck = false;
  bool fruitBreakfastCheck = false;
  bool fruitLunchCheck = false;
  bool fruitDinnerCheck = false;
  @override
  void initState() {
    fetchData();

    super.initState();
  }

  void fetchData() {
    _getCheckisPlannedToday();
    getMenu();
  }

  bool checkNullAndName(String mealType, dynamic value) {
  if (value == null) {
    print("$mealType is NULL");
    return false; // คืนค่า false หากเป็น null
  } else {
    print("$mealType is NOT NULL (Type: ${value.runtimeType})");

    if (value is List) {
      int countName = 0;
      // ตรวจสอบแต่ละ item ใน List
      for (var item in value) {
        if (item is Map && item.containsKey('name')) {
          print("$mealType name: ${item['name']}");
          countName++; // เพิ่มจำนวนรายการที่มี 'name'
        } else {
          print("$mealType item does not contain 'name'");
        }
      }

      // สำหรับ fruit ต้องการเช็คว่า countName >= 3 หรือไม่
      if (mealType.contains('fruit')) {
        if (countName >= 3) {
          return true; // คืนค่า true ถ้าพบ 'name' อย่างน้อย 3 รายการ
        } else {
          return false; // คืนค่า false หากมี 'name' น้อยกว่า 3 รายการ
        }
      }else{
        if (countName > 0) {
        return true;
      }
      }

      // สำหรับค่าอื่นๆ ก็คืนค่า true ถ้ามี name
      
    } else if (value is Map && value.containsKey('name')) {
      print("$mealType name: ${value['name']}");
      return true; // คืนค่า true เมื่อพบ 'name'
    } else {
      print("$mealType does not contain 'name'");
      return false; // คืนค่า false เมื่อไม่มี 'name'
    }
  }
  return false; // คืนค่า false หากไม่พบ 'name'
}


  void getMenu() async {
    print("widget.args['category_id']:${widget.args['category_id']}");
    String today = DateFormat('yyyy-MM-dd').format(selectedDate);
    var menusbreakfast;
    var menuslunch;
    var menusdinner;
    menusbreakfast = await DaymealService.getBreakfast(today);
    menuslunch = await DaymealService.getLunch(today);
    menusdinner = await DaymealService.getDinner(today);
    int categoryId = widget.args['category_id'];
    if (categoryId == 1) {
      // แสดง mainmeal สำหรับทุกมื้อ
      mainmealBreakfastCheck = checkNullAndName(
          "menus1 mainmeal", menusbreakfast['data']['mainmeal']);
      mainmealLunchCheck =
          checkNullAndName("menus2 mainmeal", menuslunch['data']['mainmeal']);
      mainmealDinnerCheck =
          checkNullAndName("menus3 mainmeal", menusdinner['data']['mainmeal']);
    } else if (categoryId == 3) {
      // แสดง lunch สำหรับทุกมื้อ
      beverageBreakfastCheck =
          checkNullAndName("menus1 lunch", menusbreakfast['data']['beverage']);
      beverageLunchCheck =
          checkNullAndName("menus2 lunch", menuslunch['data']['beverage']);
      beverageDinnerCheck =
          checkNullAndName("menus3 lunch", menusdinner['data']['beverage']);
    } else if (categoryId == 2) {
      print(menusbreakfast['data']['fruit']);
      print(menuslunch['data']['fruit']);
      print(menusdinner['data']['fruit']);
      // แสดง dinner สำหรับทุกมื้อ
      fruitBreakfastCheck =
          checkNullAndName("fruit", menusbreakfast['data']['fruit']);
      fruitLunchCheck =
          checkNullAndName("fruit", menuslunch['data']['fruit']);
      fruitDinnerCheck =
          checkNullAndName("fruit", menusdinner['data']['fruit']);
    }

    print("Mainmeal Breakfast Check: $mainmealBreakfastCheck");
    print("Mainmeal Lunch Check: $mainmealLunchCheck");
    print("Mainmeal Dinner Check: $mainmealDinnerCheck");
    print("Beverage Breakfast Check: $beverageBreakfastCheck");
    print("Beverage Lunch Check: $beverageLunchCheck");
    print("Beverage Dinner Check: $beverageDinnerCheck");
    print("Fruit Breakfast Check: $fruitBreakfastCheck");
    print("Fruit Lunch Check: $fruitLunchCheck");
    print("Fruit Dinner Check: $fruitDinnerCheck");
// Checking for each meal type
    // checkNullAndName("menus1 mainmeal", menusbreakfast['data']['mainmeal']);
    // checkNullAndName("menus1 beverage", menusbreakfast['data']['beverage']);
    // checkNullAndName("menus1 fruit", menusbreakfast['data']['fruit']);

    // checkNullAndName("menus2 mainmeal", menuslunch['data']['mainmeal']);
    // checkNullAndName("menus2 beverage", menuslunch['data']['beverage']);
    // checkNullAndName("menus2 fruit", menuslunch['data']['fruit']);

    // checkNullAndName("menus3 mainmeal", menusdinner['data']['mainmeal']);
    // checkNullAndName("menus3 beverage", menusdinner['data']['beverage']);
    // checkNullAndName("menus3 fruit", menusdinner['data']['fruit']);

    // print("menusbreakfast:${menusbreakfast}");
    // print("menuslunch:${menuslunch}");
    // print("menusdinner:${menusdinner}");

    // print("menusbreakfast:${menus}");
  }

  Future<void> _getCheckisPlannedToday() async {
    String date = DateFormat('yyyy-MM-dd').format(selectedDate);
    var data = await DaymealService.getDayMeal(date: date);

    // Print the full data to check the response structure
    // print("plan data: $data");

    // Extract breakfast, lunch, and dinner data
    isEatenBreakfast = data?["data"]?["breakfast"]?["check_eat"] ?? false;
    isEatenLunch = data?["data"]?["lunch"]?["check_eat"] ?? false;
    isEatenDinner = data?["data"]?["dinner"]?["check_eat"] ?? false;
  }

  @override
  Widget build(BuildContext context) {
    print(selectedDate.day);
    print(effectiveDate.day);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Container(
          height: 210, // Set a fixed height
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'เพิ่มในการวางแผนอาหารของคุณ',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 30, // Set the width of the circle
                      height: 30,
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromRGBO(74, 178, 132, 1)),
                        child: IconButton(
                          icon: const Icon(Icons.close,
                              color: Colors.white, size: 14), // ลดขนาดไอคอน
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 6),
              Divider(
                thickness: 1,
                color: Colors.grey.shade300,
                indent: 1,
                endIndent: 1,
                height: 1,
              ),
              _buildMealOption(
                "asset/im/fluent-mdl2_breakfast.png",
                "เพิ่มในวางแผนอาหารมื้อเช้าของคุณ",
                () async {
                  if (mainmealBreakfastCheck == true ||
                      beverageBreakfastCheck == true ||
                      fruitBreakfastCheck == true) {
                    ShowErrorDialog.show(context, 'มีเมนูนี้แล้ว',
                        'คุณได้เพิ่มอาหารมื้อนี้ไปแล้ว');
                  } else if (selectedDate.day != effectiveDate.day) {
                    ShowErrorDialog.show(context, 'ผ่านการวางแผนวันนี้ไปแล้ว',
                        'คุณได้ผ่านการวางแผนอาหารวันนี้ไปแล้ว');
                  } else if (!isEatenBreakfast) {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllmealPage(
                          selectedDate: DateTime.now(),
                          args: widget.args,
                          mealType: "breakfast",
                        ),
                      ),
                    );

                    if (result != null && result == "toPlanPage") {
                      if (mounted) {
                        Navigator.pop(context, "toPlanPage");
                      }
                    }
                    if (result != null && result == "fromLookallmenu") {
                      if (mounted) {
                        Navigator.pop(context, "fromLookallmenu");
                      }
                    }
                  } else {
                    ShowErrorDialog.show(context, 'รับประมานเมนูเรียบร้อย',
                        'คุณได้รับประทานอาหารมื้อนี้ไปแล้ว');
                  }
                },
              ),
              Divider(
                thickness: 1,
                color: Colors.grey.shade300,
                indent: 1,
                endIndent: 1,
                height: 1,
              ),
              _buildMealOption(
                "asset/im/mdi_food-outline.png",
                "เพิ่มในวางแผนอาหารมื้อกลางวันของคุณ",
                () async {
                  if (mainmealLunchCheck == true ||
                      beverageLunchCheck == true ||
                      fruitLunchCheck == true) {
                    ShowErrorDialog.show(context, 'มีเมนูนี้แล้ว',
                        'คุณได้เพิ่มอาหารมื้อนี้ไปแล้ว');
                  } else if (selectedDate.day != effectiveDate.day) {
                    ShowErrorDialog.show(context, 'ผ่านการวางแผนวันนี้ไปแล้ว',
                        'คุณได้ผ่านการวางแผนอาหารวันนี้ไปแล้ว');
                  } else if (!isEatenLunch) {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllmealPage(
                          selectedDate: DateTime.now(),
                          args: widget.args,
                          mealType: "lunch",
                        ),
                      ),
                    );

                    if (result != null && result == "toPlanPage") {
                      if (mounted) {
                        Navigator.pop(context, "toPlanPage");
                      }
                    }
                    if (result != null && result == "fromLookallmenu") {
                      if (mounted) {
                        Navigator.pop(context, "fromLookallmenu");
                      }
                    }
                  } else {
                    ShowErrorDialog.show(context, 'รับประมานเมนูเรียบร้อย',
                        'คุณได้รับประทานอาหารมื้อนี้ไปแล้ว');
                  }
                },
              ),
              Divider(
                thickness: 1,
                color: Colors.grey.shade300,
                indent: 1,
                endIndent: 1,
                height: 1,
              ),
              _buildMealOption(
                "asset/im/mingcute_dinner-line.png",
                "เพิ่มในวางแผนอาหารมื้อเย็นของคุณ",
                () async {
                  if (mainmealDinnerCheck == true ||
                      beverageDinnerCheck == true ||
                      fruitDinnerCheck == true) {
                    ShowErrorDialog.show(context, 'มีเมนูนี้แล้ว',
                        'คุณได้เพิ่มอาหารมื้อนี้ไปแล้ว');
                  } else if (selectedDate.day != effectiveDate.day) {
                    ShowErrorDialog.show(context, 'ผ่านการวางแผนวันนี้ไปแล้ว',
                        'คุณได้ผ่านการวางแผนอาหารวันนี้ไปแล้ว');
                  } else if (!isEatenDinner) {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllmealPage(
                          selectedDate: DateTime.now(),
                          args: widget.args,
                          mealType: "dinner",
                        ),
                      ),
                    );

                    if (result != null && result == "toPlanPage") {
                      if (mounted) {
                        Navigator.pop(context, "toPlanPage");
                      }
                    }
                    if (result != null && result == "fromLookallmenu") {
                      if (mounted) {
                        Navigator.pop(context, "fromLookallmenu");
                      }
                    }
                  } else {
                    ShowErrorDialog.show(context, 'รับประมานเมนูเรียบร้อย',
                        'คุณได้รับประทานอาหารมื้อนี้ไปแล้ว');
                  }
                },
              ),
              Divider(
                thickness: 1,
                color: Colors.grey.shade300,
                indent: 1,
                endIndent: 1,
                height: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMealOption(String Url, String text, VoidCallback onTap) {
    return ListTile(
      leading: SizedBox(
        width: 28, // Set the width of the image
        height: 28, // Set the height of the image
        child: Image.asset(Url),
      ), // Adjust icon size
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
