import 'package:flutter/material.dart';
import 'package:diabetes_meal_management_application_project/apis/Api_daymeal.dart';

import 'package:diabetes_meal_management_application_project/apis/Api_profile.dart';
import 'package:diabetes_meal_management_application_project/components/backbutton.dart';
import 'package:diabetes_meal_management_application_project/components/home/addmenu.dart';
import 'package:diabetes_meal_management_application_project/components/home/savebutton.dart';
import 'package:diabetes_meal_management_application_project/components/nutritioncard.dart';
import 'package:diabetes_meal_management_application_project/components/home/bmi_card.dart';
import 'package:diabetes_meal_management_application_project/components/home/addmenu_fruit.dart';
import 'package:intl/intl.dart';

import 'package:diabetes_meal_management_application_project/components/profile/areusure.dart';

class AllmealPage extends StatefulWidget {
  final DateTime selectedDate;
  final String mealType;
  final Map<String, dynamic> args;

  const AllmealPage(
      {Key? key,
      required this.selectedDate,
      required this.args,
      required this.mealType})
      : super(key: key);
  @override
  State<AllmealPage> createState() => _AllmealPageState();
}

class _AllmealPageState extends State<AllmealPage> {
  double calories = 0;
  double fat = 0;
  double carbohydrate = 0;
  double protein = 0;
  double sodium = 0;
  double sugar = 0;
  double glycemicIndex = 0;
  double glycemicLoad = 0;

  double temp_calories = 0;
  double temp_fat = 0;
  double temp_carbohydrate = 0;
  double temp_protein = 0;
  double temp_sodium = 0;
  double temp_sugar = 0;
  double temp_glycemicIndex = 0;
  double temp_glycemicLoad = 0;

  double caloriesmainmeal = 0;
  double fatmainmeal = 0;
  double carbohydratemainmeal = 0;
  double proteinmainmeal = 0;
  double sodiummainmeal = 0;
  double sugarmainmeal = 0;
  double glycemicIndexmainmeal = 0;
  double glycemicLoadmainmeal = 0;

  double caloriesbeverage = 0;
  double fatbeverage = 0;
  double carbohydratebeverage = 0;
  double proteinbeverage = 0;
  double sodiumbeverage = 0;
  double sugarbeverage = 0;
  double glycemicIndexbeverage = 0;
  double glycemicLoadbeverage = 0;

  double caloriesfruit = 0;
  double fatfruit = 0;
  double carbohydratefruit = 0;
  double proteinfruit = 0;
  double sodiumfruit = 0;
  double sugarfruit = 0;
  double glycemicIndexfruit = 0;
  double glycemicLoadfruit = 0;

  double plusCalories = 0;
  double plusFat = 0;
  double plusCarb = 0;
  double plusProtein = 0;
  double plusSugar = 0;
  double plusSodium = 0;
  double minusCalories = 0;
  double minusFat = 0;
  double minusCarb = 0;
  double minusProtein = 0;
  double minusSugar = 0;
  double minusSodium = 0;
  int colormainmeal = 0;
  int colorbeverage = 0;

  int save = 0;

  List<String> initialSelectedMenuIds = [];
  Map<String, dynamic>? userData;
  double weight = 0;
  double height = 0;
  double bmi = 0; // Changed to double for accuracy
  List<Map<String, dynamic>> mainmealmenuList = [];
  List<Map<String, dynamic>> fruitmenuList = [];
  List<Map<String, dynamic>> beveragesmenuList = [];
  List<Map<String, dynamic>> combinedMenuList = [];
  List<String> combinedMenuIdList = [];
  DateTime thailandTime = DateTime.now().toUtc().add(Duration(hours: 7));
  bool isLoading = true; // แสดงสถานะโหลดข้อมูล
  double maxEnergy = 0; // Add a state variable for maxEnergy
  @override
  void initState() {
    // fetchRecommendedMenus();
    thailandTime = widget.selectedDate.toUtc().add(Duration(hours: 7));
    // print("thailandTime:$thailandTime");
    // print("selectedDate:${widget.selectedDate}");
    fetchData();
    super.initState();
  }

  void fetchData() {
    // print("widget.args:${widget.args}");
    getMenu();
    fetchMaxEnergy(); // Fetch maxEnergy (TDEE) value
    loadUserProfile();
  }

  void checkisUpdate() {
    combinedMenuList = mainmealmenuList + fruitmenuList + beveragesmenuList;
    combinedMenuIdList = combinedMenuList
        .map((menu) => menu["menu_id"].toString()) // Ensure it's a String
        .toList();
    save = !Set.from(combinedMenuIdList).containsAll(initialSelectedMenuIds) ||
            !Set.from(initialSelectedMenuIds).containsAll(combinedMenuIdList)
        ? 1
        : 0;
        
  }

  void onMenuSelected(int categoryId, dynamic menuData) {
    print("categoryId:${categoryId}");
    print("menuData:${menuData}");
    setState(() {
      if (categoryId == 1) {
        mainmealmenuList = [];
        mainmealmenuList.add(menuData);
        print("mainmealmenuList:${mainmealmenuList}");
      } else if (categoryId == 3) {
        beveragesmenuList = [];
        beveragesmenuList.add(menuData);
      } else if (categoryId == 2) {
       
        fruitmenuList.add(menuData);
         print("fruit:${fruitmenuList}");
      } else {
        return;
      }
    });
    checkisUpdate();
  }

  void onMenuDeleted(int categoryId) {
    setState(() {
      if (categoryId == 1) {
        mainmealmenuList = [];
      } else if (categoryId == 3) {
        beveragesmenuList = [];
      } else if (categoryId == 2) {
        fruitmenuList = [];
      } else {
        return;
      }
    });

    checkisUpdate();
  }

  void plusNutrition(dynamic nutrition) {
    plusCalories = double.parse((nutrition['calorie'] ?? 0).toStringAsFixed(2));
    plusCarb =
        double.parse((nutrition['carbohydrate'] ?? 0).toStringAsFixed(2));
    plusFat = double.parse((nutrition['fat'] ?? 0).toStringAsFixed(2));
    plusProtein = double.parse((nutrition['protein'] ?? 0).toStringAsFixed(2));
    plusSodium = double.parse((nutrition['sodium'] ?? 0).toStringAsFixed(2));
    plusSugar = double.parse((nutrition['sugar'] ?? 0).toStringAsFixed(2));
    temp_calories = double.parse((calories + plusCalories).toStringAsFixed(2));
    temp_carbohydrate =
        double.parse((carbohydrate + plusCarb).toStringAsFixed(2));
    temp_fat = double.parse((fat + plusFat).toStringAsFixed(2));
     temp_sugar  = double.parse((sugar + plusSugar).toStringAsFixed(2));
    temp_sodium = double.parse((sodium + plusSodium).toStringAsFixed(2));
    protein = double.parse((protein + plusProtein).toStringAsFixed(2));
  }

  void minusNutrition(dynamic nutrition) {
    print("nutriton.fruit:${nutrition}");
    print(nutrition.runtimeType);
    minusCalories =
        double.parse((nutrition['calorie'] ?? 0).toStringAsFixed(2));
    minusCarb =
        double.parse((nutrition['carbohydrate'] ?? 0).toStringAsFixed(2));
    minusFat = double.parse((nutrition['fat'] ?? 0).toStringAsFixed(2));
    minusProtein = double.parse((nutrition['protein'] ?? 0).toStringAsFixed(2));
    minusSodium = double.parse((nutrition['sodium'] ?? 0).toStringAsFixed(2));
    minusSugar = double.parse((nutrition['sugar'] ?? 0).toStringAsFixed(2));
    temp_calories = double.parse((calories - minusCalories).toStringAsFixed(2));
    temp_carbohydrate =
        double.parse((carbohydrate - minusCarb).toStringAsFixed(2));
    temp_fat = double.parse((fat - minusFat).toStringAsFixed(2));
    temp_sugar = double.parse((sugar - minusSugar).toStringAsFixed(2));
    temp_sodium = double.parse((sodium - minusSodium).toStringAsFixed(2));
    temp_protein = double.parse((protein - minusProtein).toStringAsFixed(2));
  }

  void _resetAllMenus() {
    setState(() {
      save = 0;
      combinedMenuIdList.clear();
      initialSelectedMenuIds.clear();

      print("initialSelectedMenuIds:${initialSelectedMenuIds}");
      print("combinedMenuIdList:${combinedMenuIdList}");
    });
  }

  void onSave() async {
    String today = DateFormat('yyyy-MM-dd').format(thailandTime);
    List<String> finalSelected = [];

    if (mainmealmenuList.isNotEmpty) {
      finalSelected.add(mainmealmenuList[0]["menu_id"]);
    }
    if (beveragesmenuList.isNotEmpty) {
      finalSelected.add(beveragesmenuList[0]["menu_id"]);
    }
    if (fruitmenuList.isNotEmpty) {
      fruitmenuList.forEach((fruit) {
        finalSelected.add(fruit["menu_id"]);
      });
    }
    var upsertResult = await DaymealService.upsertMeal(
      date: today,
      mealType: widget.mealType,
      menuIds: finalSelected,
    );
    if (upsertResult != null) {
      print('มื้ออาหาร${widget.mealType}ถูกบันทึกสำเร็จ');
    } else {
      print('เกิดข้อผิดพลาดในการบันทึกข้อมูลมื้ออาหาร');
    }
    setState(() {
      getMenu();
    });
  }

  void processArgs() {
    print("mainmeallist:${mainmealmenuList}");
    print("fruitlist:${fruitmenuList}");
    // mainmealmenuList.c
    if (widget.args.isNotEmpty) {
      int categoryId = widget.args['category_id'];

      Map<String, dynamic> menuData = {
        'name': widget.args['name'],
        'Url': widget.args['img'],
        'menu_id': widget.args['menu_id'],
        'color': widget.args['color'],
        'nutrition': widget.args['nutrition'],
        'category_id': widget.args['category_id']
      };

      // plusNutrition(menuData['nutrition']);
      print("categoryIdarg:${categoryId}");
      if (categoryId != 0) {
        onMenuSelected(categoryId, menuData);
      }
      colormainmeal =
          mainmealmenuList.isNotEmpty ? mainmealmenuList[0]['color'] ?? 0 : 0;
      colorbeverage =
          beveragesmenuList.isNotEmpty ? beveragesmenuList[0]['color'] ?? 0 : 0;
      isLoading = false;
    }
  }

  void getMenu() async {
    String today = DateFormat('yyyy-MM-dd').format(thailandTime);
    var menus;

    if (widget.mealType == "breakfast") {
      menus = await DaymealService.getBreakfast(today);
    } else if (widget.mealType == "lunch") {
      menus = await DaymealService.getLunch(today);
    } else if (widget.mealType == "dinner") {
      menus = await DaymealService.getDinner(today);
    }

    // print("menusbreakfast:${menus}");
    if (menus != null) {
      if (mounted) {
        setState(() {
          mainmealmenuList = _parseMenuData(menus['data']['mainmeal']);
          fruitmenuList = _parseMenuData(menus['data']['fruit']);
          beveragesmenuList = _parseMenuData(menus['data']['beverage']);
          isLoading = false;

          for (var menu in mainmealmenuList) {
            combinedMenuIdList.add(menu['menu_id']);
            initialSelectedMenuIds.add(menu['menu_id']); // เก็บค่าเริ่มต้น
          }

          for (var menu in fruitmenuList) {
            combinedMenuIdList.add(menu['menu_id']);
            initialSelectedMenuIds.add(menu['menu_id']);
          }

          for (var menu in beveragesmenuList) {
            combinedMenuIdList.add(menu['menu_id']);
            initialSelectedMenuIds.add(menu['menu_id']); // เก็บค่าเริ่มต้น
          }
          // print("menu_data_fruit:${menus['data']['fruit']}");
          Map<String, double> mainmeal = menus['data']['mainmeal'] != null &&
                  menus['data']['mainmeal'].isNotEmpty
              ? extractNutrition(menus['data']['mainmeal'][0]['nutrition'])
              : {};
          Map<String, double> beverage = menus['data']['beverage'] != null &&
                  menus['data']['beverage'].isNotEmpty
              ? extractNutrition(menus['data']['beverage'][0]['nutrition'])
              : {};
          Map<String, double> fruit = {};
          if (menus['data']['fruit'] != null &&
              menus['data']['fruit'].isNotEmpty) {
            for (var item in menus['data']['fruit']) {
              var nutrition = extractNutrition(item['nutrition']);
              fruit.update('calorie', (value) => value + nutrition['calorie']!,
                  ifAbsent: () => nutrition['calorie']!);
              fruit.update('fat', (value) => value + nutrition['fat']!,
                  ifAbsent: () => nutrition['fat']!);
              fruit.update(
                  'carbohydrate', (value) => value + nutrition['carbohydrate']!,
                  ifAbsent: () => nutrition['carbohydrate']!);
              fruit.update('protein', (value) => value + nutrition['protein']!,
                  ifAbsent: () => nutrition['protein']!);
              fruit.update('sodium', (value) => value + nutrition['sodium']!,
                  ifAbsent: () => nutrition['sodium']!);
              fruit.update('sugar', (value) => value + nutrition['sugar']!,
                  ifAbsent: () => nutrition['sugar']!);
              fruit.update('glycemic_index',
                  (value) => value + nutrition['glycemic_index']!,
                  ifAbsent: () => nutrition['glycemic_index']!);
              fruit.update('glycemic_load',
                  (value) => value + nutrition['glycemic_load']!,
                  ifAbsent: () => nutrition['glycemic_load']!);
            }
          }
          caloriesmainmeal =
              double.parse((mainmeal['calorie'] ?? 0).toStringAsFixed(2));
          fatmainmeal = double.parse((mainmeal['fat'] ?? 0).toStringAsFixed(2));
          carbohydratemainmeal =
              double.parse((mainmeal['carbohydrate'] ?? 0).toStringAsFixed(2));
          proteinmainmeal =
              double.parse((mainmeal['protein'] ?? 0).toStringAsFixed(2));
          sodiummainmeal =
              double.parse((mainmeal['sodium'] ?? 0).toStringAsFixed(2));
          sugarmainmeal =
              double.parse((mainmeal['sugar'] ?? 0).toStringAsFixed(2));
          glycemicIndexmainmeal = double.parse(
              (mainmeal['glycemic_index'] ?? 0).toStringAsFixed(2));
          glycemicLoadmainmeal =
              double.parse((mainmeal['glycemic_load'] ?? 0).toStringAsFixed(2));

          caloriesbeverage =
              double.parse((beverage['calorie'] ?? 0).toStringAsFixed(2));
          fatbeverage = double.parse((beverage['fat'] ?? 0).toStringAsFixed(2));
          carbohydratebeverage =
              double.parse((beverage['carbohydrate'] ?? 0).toStringAsFixed(2));
          proteinbeverage =
              double.parse((beverage['protein'] ?? 0).toStringAsFixed(2));
          sodiumbeverage =
              double.parse((beverage['sodium'] ?? 0).toStringAsFixed(2));
          sugarbeverage =
              double.parse((beverage['sugar'] ?? 0).toStringAsFixed(2));
          glycemicIndexbeverage = double.parse(
              (beverage['glycemic_index'] ?? 0).toStringAsFixed(2));
          glycemicLoadbeverage =
              double.parse((beverage['glycemic_load'] ?? 0).toStringAsFixed(2));

          caloriesfruit =
              double.parse((fruit['calorie'] ?? 0).toStringAsFixed(2));
          fatfruit = double.parse((fruit['fat'] ?? 0).toStringAsFixed(2));
          carbohydratefruit =
              double.parse((fruit['carbohydrate'] ?? 0).toStringAsFixed(2));
          proteinfruit =
              double.parse((fruit['protein'] ?? 0).toStringAsFixed(2));
          sodiumfruit = double.parse((fruit['sodium'] ?? 0).toStringAsFixed(2));
          sugarfruit = double.parse((fruit['sugar'] ?? 0).toStringAsFixed(2));
          glycemicIndexfruit =
              double.parse((fruit['glycemic_index'] ?? 0).toStringAsFixed(2));
          glycemicLoadfruit =
              double.parse((fruit['glycemic_load'] ?? 0).toStringAsFixed(2));

          calories = double.parse(
              (caloriesmainmeal + caloriesbeverage + caloriesfruit)
                  .toStringAsFixed(2));

          fat = double.parse(
              (fatmainmeal + fatbeverage + fatfruit).toStringAsFixed(2));
          carbohydrate = double.parse(
              (carbohydratemainmeal + carbohydratebeverage + carbohydratefruit)
                  .toStringAsFixed(2));
          protein = double.parse(
              (proteinmainmeal + proteinbeverage + proteinfruit)
                  .toStringAsFixed(2));
          sodium = double.parse((sodiummainmeal + sodiumbeverage + sodiumfruit)
              .toStringAsFixed(2));
          sugar = double.parse(
              (sugarmainmeal + sugarbeverage + sugarfruit).toStringAsFixed(2));

          colormainmeal = mainmealmenuList.isNotEmpty
              ? mainmealmenuList[0]['color'] ?? 0
              : 0;
          colorbeverage = beveragesmenuList.isNotEmpty
              ? beveragesmenuList[0]['color'] ?? 0
              : 0;
          // print("mainmealmenuList:${mainmealmenuList}");
          // print("colormainmeal:${colormainmeal}");
          // print("beveragesmenuList:${beveragesmenuList}");
          // print("colorbeverage:${colorbeverage}");
          // print("fruitmenuList:${fruitmenuList}");
        });
      }
    } else {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
    processArgs();
  }

  Future<void> fetchMaxEnergy() async {
    var tdeeData = await Profile.calculateCalories();
    if (tdeeData != null && mounted) {
      setState(() {
        maxEnergy = double.tryParse(tdeeData['tdee'].toString()) ?? 0;
      });
    }
  }

  Future<void> loadUserProfile() async {
    var profile = await Profile.getUserProfile();
    if (mounted) {
      setState(() {
        userData = profile?['message'];
        if (userData != null) {
          weight = double.tryParse(userData!['weight'].toString()) ?? 0;
          height = double.tryParse(userData!['height'].toString()) ?? 0;
        }
      });
    }
  }

  Map<String, double> extractNutrition(Map<String, dynamic>? nutrition) {
    return {
      'calorie': _getDoubleValue(nutrition, 'calorie'),
      'fat': _getDoubleValue(nutrition, 'fat'),
      'carbohydrate': _getDoubleValue(nutrition, 'carbohydrate'),
      'protein': _getDoubleValue(nutrition, 'protein'),
      'sodium': _getDoubleValue(nutrition, 'sodium'),
      'sugar': _getDoubleValue(nutrition, 'sugar'),
      'glycemic_index': _getDoubleValue(nutrition, 'glycemic_index'),
      'glycemic_load': _getDoubleValue(nutrition, 'glycemic_load'),
    };
  }

  double _getDoubleValue(Map<String, dynamic>? nutrition, String key) {
    var value = nutrition?[key];
    if (value is double) {
      return value;
    } else if (value is int) {
      return value.toDouble();
    } else {
      return 0.0;
    }
  }

  List<Map<String, dynamic>> _parseMenuData(dynamic menuData) {
    if (menuData == null) return [];
    // print("menuData${menuData}");
    // Check if the data is a list, otherwise wrap it in a list
    if (menuData is List) {
      return menuData
          .map((item) => {
                'name': item['name'] ?? 'ไม่มีชื่อเมนู',
                'Url': item['menu_img'] ??
                    Icon(Icons.broken_image, size: 50, color: Colors.grey),
                'menu_id': item['menu_id'],
                'category_id': item['category_id'],
                'color': item['color'],
                'nutrition': item['nutrition']
              })
          .toList();
    } else if (menuData is Map) {
      return [
        {
          'name': menuData['name'] ?? 'ไม่มีชื่อเมนู',
          'Url': menuData['menu_img'] ??
              Icon(Icons.broken_image, size: 50, color: Colors.grey),
          'menu_id': menuData['menu_id'],
          'category_id': menuData['category_id'],
          'color': menuData['color'],
          'nutrition': menuData['nutrition']
        }
      ];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    void _showConfirmationDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) {
          return Areusure(); // เรียกใช้ dialog ยืนยัน
        },
      ).then((value) {
        if (value == "Don't stay") {
          if (widget.args['back_path'] == "fromLookallmenu") {
            Navigator.pop(context, "fromLookallmenu");
          } else {
            Navigator.pop(context, "toPlanPage");
          }
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.black,
        elevation: 3,
        backgroundColor: Colors.white,
        leading: Backbutton(
          onPressed: () {
            if (!Set.from(combinedMenuIdList)
                    .containsAll(initialSelectedMenuIds) ||
                !Set.from(initialSelectedMenuIds)
                    .containsAll(combinedMenuIdList)) {
              _showConfirmationDialog(context);
              print(combinedMenuIdList);
              print(initialSelectedMenuIds);
            } else {
              if (widget.args.isNotEmpty) {
                if (widget.args['back_path'] == "fromLookallmenu") {
                  Navigator.pop(context, "fromLookallmenu");
                } else {
                  Navigator.pop(context, "toPlanPage");
                }
              } else {
                Navigator.pop(context, "Default_toPlanPage");
              }
            }
          },
        ),
        title: Text(
          widget.mealType == "breakfast"
              ? 'วางแผนอาหารเช้าของคุณ'
              : widget.mealType == "lunch"
                  ? 'วางแผนอาหารกลางวันของคุณ'
                  : 'วางแผนอาหารเย็นของคุณ',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Savebutton(
            check: 1,
            save: save,
            onPressed: onSave,
            onReset: _resetAllMenus,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Color.fromRGBO(241, 241, 241, 1.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    isLoading
                        ? Center(child: CircularProgressIndicator())
                        : Addmenu(
                            name: "อาหาร",
                            nameAdd: "เพิ่มอาหาร\n ของคุณ...",
                            menulist: mainmealmenuList,
                            // imgUrl: "asset/im/bmi1.png",
                            onMenuSelected: onMenuSelected,
                            onMenuDeleted: onMenuDeleted,
                            color:
                                mainmealmenuList.isNotEmpty ? colormainmeal : 0,
                            plusNutrition: plusNutrition,
                            minusNutrition: minusNutrition,
                          ),
                    isLoading
                        ? Center(child: CircularProgressIndicator())
                        : Addmenu(
                            name: "เครื่องดื่ม",
                            nameAdd: "เพิ่มเครื่องดื่ม\n   ของคุณ...",
                            // imgUrl: "asset/im/bmi1.png",
                            menulist: beveragesmenuList,
                            onMenuSelected: onMenuSelected,
                            onMenuDeleted: onMenuDeleted,
                            color: beveragesmenuList.isNotEmpty
                                ? colorbeverage
                                : 0,
                            plusNutrition: plusNutrition,
                            minusNutrition: minusNutrition,
                          ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    isLoading
                        ? Center(child: CircularProgressIndicator())
                        : AddmenuFruit(
                            name: "ผลไม้",
                            nameAdd: "เพิ่มผลไม้\nของคุณ...",
                            menulist: fruitmenuList,
                            onMenuSelected: onMenuSelected,
                            onMenuDeleted: onMenuDeleted,
                          ),
                  ],
                ),
              ),
              SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: BMIWidget(
                  weight: weight,
                  height: height,
                  accumulatedEnergy: calories,
                  maxEnergy: maxEnergy,
                ),
              ),
              SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Nutritioncard(
                  path: 'history',
                  name: "ข้อมูลโภชนาการ",
                  carbohydrate: carbohydrate,
                  sugar: sugar,
                  fat: fat,
                  sodium: sodium,
                  protein: protein,
                  calories: calories,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
