import 'package:flutter/material.dart';
import 'package:diabetes_meal_management_application_project/apis/Api_menu.dart';
import 'package:diabetes_meal_management_application_project/components/backbutton.dart';
import 'package:diabetes_meal_management_application_project/components/food/choosemeal.dart';
import 'package:diabetes_meal_management_application_project/components/food/nutritioncard_menudetail.dart';
import 'package:diabetes_meal_management_application_project/components/nutritioncard.dart';

class MenudetailPage extends StatefulWidget {
  const MenudetailPage({super.key});

  @override
  State<MenudetailPage> createState() => _MenudetailPageState();
}

class _MenudetailPageState extends State<MenudetailPage> {
  bool isLoading = true;
  Map<String, dynamic> menuDetail = {};
  String describe = "";
  String quantity = "";
  // ฟังก์ชันดึงข้อมูลจาก API
  void fetchMenuDetail(String menuId) async {
    try {
      var fetchedMenuDetail = await MenuService.getDetailMenu(menu_id: menuId);
      // print("menuDetail: $fetchedMenuDetail");
      if (!mounted) return;
      setState(() {
        // ตรวจสอบว่า 'menu' และ 'nutrition' มีค่าแล้วหรือไม่
        if (fetchedMenuDetail != null &&
            fetchedMenuDetail['menu'] != null &&
            fetchedMenuDetail['menu']['nutrition'] != null) {
          menuDetail = fetchedMenuDetail;
          describe = fetchedMenuDetail['menu']['describe'];
          quantity = fetchedMenuDetail['menu']['quantity'];

          // print("menuDetail: $menuDetail");
        } else {
          print("Error: Nutrition data is missing or incomplete");
        }

        isLoading = false;
      });
    } catch (error) {
      if (!mounted) return; // Check if the widget is still mounted
      setState(() {
        isLoading = false;
      });
      print('Error fetching menu details: $error');
    }
  }

  void _showChooseDialog(BuildContext context, Map<String, dynamic> args) {
    showDialog(
      context: context,
      builder: (context) {
        return Choosemeal(args: args); // เรียกใช้ dialog ยืนยัน
      },
    ).then((value) {
      if (value == "toPlanPage") {
        Navigator.pop(context, "toPlanPage");
      } else if (value == "fromLookallmenu") {
        Navigator.pop(context, "fromLookallmenu");
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String? imageUrl = args?['Url'];
    final String? name = args?['name'];
    final String? menu_id = args?['menu_id']; // รับ menu_id จาก arguments
    final String? path = args?['path']; // Get the URL from arguments
    final int? category_id = args?['category_id']; // Get the URL from arguments
    final int? color = args?['color']; // Get the URL from arguments
    final Map<String, dynamic>? nutrition =
        args?['nutrition']; // Get the URL from arguments
    // ดึงข้อมูลเมนูจาก API เมื่อหน้าโหลด
    if (isLoading && menu_id != null) {
      fetchMenuDetail(menu_id);
    }
    // print("path:${path}");
    // print("widget.Url:${imageUrl}");
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Backbutton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color.fromRGBO(241, 241, 241, 1),
          child: Column(
            children: [
              if (imageUrl != null)
                Container(
                  height: 300, // Adjust the height as needed
                  width: double.infinity, // ให้ภาพกว้างจนถึงขอบจอ
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: Image.network(
                        imageUrl, // ใช้ URL จาก MongoDB
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.broken_image,
                              size: 50, color: Colors.grey);
                        },
                      ).image,
                      fit: BoxFit.cover, // ให้ภาพเต็มกรอบ
                    ),
                  ),
                ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: Container(
                  padding: EdgeInsets.all(16),
                  color: Color.fromRGBO(241, 241, 241, 1),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              name ??
                                  'ชื่อเมนู', // ถ้าไม่มีชื่อให้แสดงชื่อเมนูเริ่มต้น
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w800),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          path != 'close'
                              ? Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 8),
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(255, 139, 89, 1),
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.3),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: Offset(0, 3),
                                        )
                                      ]),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (path == 'MenulistviewRecommend') {
                                        _showChooseDialog(context, {
                                          'value': 1,
                                          'img': imageUrl,
                                          'name': name,
                                          'menu_id': menu_id,
                                          'category_id': category_id,
                                          'nutrition': nutrition,
                                          'color': color
                                        });
                                      } else if (path ==
                                          'LookallmenuRecommend') {
                                        _showChooseDialog(context, {
                                          'value': 1,
                                          'img': imageUrl,
                                          'name': name,
                                          'menu_id': menu_id,
                                          'category_id': category_id,
                                          'nutrition': nutrition,
                                          'color': color,
                                          'back_path': 'fromLookallmenu'
                                        });
                                      } else {
                                        Navigator.pop(context, {
                                          'value': 1,
                                          'img': imageUrl,
                                          'name': name,
                                          'menu_id': menu_id,
                                          'category_id': category_id,
                                          'color': color
                                        });
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        Image.asset('asset/im/arrow.png'),
                                        SizedBox(width: 5),
                                        Text(
                                          "ทานเมนูนี้",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : SizedBox.shrink()
                        ],
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(74, 178, 132, 1),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            child: Text(
                              "พลังงาน ${(menuDetail['menu']?['nutrition']?['calories'] ?? 0)} กิโลแคลอรี่",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      NutritioncardMenudetail(
                        name: "ข้อมูลโภชณาการ",
                        carbohydrate: (menuDetail['menu']?['nutrition']
                                    ?['carbohydrate'] ??
                                0)
                            .toDouble(),
                        sugar: (menuDetail['menu']?['nutrition']?['sugar'] ?? 0)
                            .toDouble(),
                        fat: (menuDetail['menu']?['nutrition']?['fat'] ?? 0)
                            .toDouble(),
                        sodium:
                            (menuDetail['menu']?['nutrition']?['sodium'] ?? 0)
                                .toDouble(),
                        protein:
                            (menuDetail['menu']?['nutrition']?['protein'] ?? 0)
                                .toDouble(),
                        calories:
                            (menuDetail['menu']?['nutrition']?['calories'] ?? 0)
                                .toDouble(),
                      ),
                      SizedBox(height: 20),
                      describe != ""
                          ? Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Wrap(
                                      alignment: WrapAlignment.start,
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              child: Text(
                                                describe,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  height: 2,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox.shrink(),
                      describe != "" ? SizedBox(height: 20) : SizedBox.shrink(),
                      quantity != ""
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(74, 178, 132, 1),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    quantity,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            )
                          : SizedBox.shrink(),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 16.0,
                                      right: 16,
                                      top: 14,
                                      bottom: 4),
                                  child: Text(
                                    "วัตถุดิบ",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              color: Color.fromRGBO(231, 230, 230, 1.0),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Wrap(
                                alignment: WrapAlignment.start,
                                children: [
                                  for (int i = 0;
                                      i <
                                          (menuDetail['menu']?['ingredients']
                                                  ?.length ??
                                              0);
                                      i++) ...[
                                    Container(
                                      width: double.infinity,
                                      child: Text(
                                        '${i + 1}. ${menuDetail['menu']?['ingredients'][i]['name']} '
                                        '${menuDetail['menu']?['ingredients'][i]['quantity'] ?? ''} '
                                        '${menuDetail['menu']?['ingredients'][i]['unit'] ?? ''}',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    SizedBox(height: 30),
                                  ]
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
