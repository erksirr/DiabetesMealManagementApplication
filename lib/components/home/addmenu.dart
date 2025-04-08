import 'package:flutter/material.dart';
import 'package:diabetes_meal_management_application_project/pages/food/menudetail.dart';
import 'package:diabetes_meal_management_application_project/pages/home/lookallmenu.dart';

class Addmenu extends StatefulWidget {
  final String name;
  final String nameAdd;
  final List menulist;
  final int color;
  final Function(int, dynamic) onMenuSelected;
  final Function(int) onMenuDeleted;
  final Function(dynamic) plusNutrition;
   final Function(dynamic) minusNutrition;

  Addmenu({
    Key? key,
    required this.name,
    required this.nameAdd,
    required this.onMenuSelected,
    required this.onMenuDeleted,
    required this.menulist,
      required this.color,
    required this.plusNutrition,
    required this.minusNutrition
  }) : super(key: key);

  @override
  AddmenuState createState() => AddmenuState();
}

class AddmenuState extends State<Addmenu> {
  bool isData = false;
  String getpic = "";
  String menuname = "";
  List menulist = [];
  String menu_id = "";
  int category_id = 0;
  int color = 0;
  Object nutrition = {};
  void setvalue() {
    setState(() {
      menulist = widget.menulist;
      color = widget.color;
      // print("menulist:${menulist}");
      for (var menu in menulist) {
        menuname = menu['name'];
        getpic = menu['Url'];
        menu_id = menu['menu_id'];
        category_id = menu['category_id'] ?? 0;
        nutrition  = menu['nutrition'];
      }
      // print("category_id:${category_id}");
      //  print("menuname:${menuname}");
      //  print("getpic:${getpic}");
    });
  }

  @override
  void initState() {
    isData = widget.menulist.isNotEmpty;
    setvalue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 175,
          height: 190,
          decoration: BoxDecoration(
            color: Color.fromRGBO(203, 203, 203, 0.2),
            border: Border.all(
              color: Colors.white,
              width: 2.0,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  if (!isData) {
                    // print("getpic: $getpic");
                    // print("menuname: $menuname");
                    // print("menu_id: $menu_id");
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LookallmenuPage(
                            categoryId: widget.name == 'อาหาร' ? 1 : 3,
                            searchText: widget.name == 'อาหาร'
                                ? "ค้นหาอาหารของคุณ"
                                : "ค้นหาเครื่องดื่มของคุณ",
                            path: "fromAddmenu"),
                      ),
                    );

                    print("result:${result}");
                    if (result != null &&
                        result is Map<String, dynamic> &&
                        result.containsKey('value')) {
                      menu_id = result['menu_id'];
                      category_id = result['category_id'];
                      // print(
                      //     "category_idresukt=====================================:${category_id}");
                      getpic = result['img'];
                      menuname = result['name'];
                      color = result['color'];
                   
                      nutrition = result['nutrition'];
                      widget.onMenuSelected(category_id, {
                        'name': result['name'],
                        'Url': result['img'],
                        'menu_id': result['menu_id'],
                      });
                      // widget.plusNutrition(nutrition);

                      setState(() {
                        isData = !isData;
                      });
                      // menulist=[];
                      // setvalue();
                    }
                    print(getpic);
                  }
                },
                child: Column(
                  children: [
                    !isData
                        ? Image.asset('asset/im/add.png')
                        : (getpic.isNotEmpty
                            ? Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: GestureDetector(
                                      child: Image.network(
                                        getpic, // ใช้ URL จาก MongoDB
                                        height: 180,
                                        width: 170,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Icon(Icons.broken_image,
                                              size: 50, color: Colors.grey);
                                        },
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MenudetailPage(),
                                            settings: RouteSettings(
                                              arguments: {
                                                'Url': getpic,
                                                'name': menuname,
                                                'path': "close",
                                                'menu_id': menu_id,
                                              },
                                            ),
                                          ), // ลิงก์ไปยังหน้า breakfast.dart
                                        );
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    top: 6,
                                    left: 6,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: color == 1
                                            ? Color.fromRGBO(4, 178, 132, 1)
                                            : color == 2
                                                ? Color.fromRGBO(
                                                    255, 116, 56, 1)
                                                : Color.fromRGBO(218, 22, 22,
                                                    1), // สีขอบนอกสุด
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                            maxWidth:
                                                140), // ป้องกันข้อความยาวเกินไป
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            menuname,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            : Image.asset(
                                'asset/im/bmi1.png',
                                fit: BoxFit.cover, // Fallback image with BoxFit
                              )),
                    // SizedBox(height: 16),
                    !isData
                        ? Text(
                            widget.nameAdd,
                            style: TextStyle(
                                color: Color.fromRGBO(153, 153, 153, 1)),
                          )
                        : SizedBox.shrink(), // Empty widget when _num != 0
                  ],
                ),
              ),
              // SizedBox(height: 50),erkำพาerk
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 6),
          height: 50,
          width: 176,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.name,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              isData
                  ? GestureDetector(
                      child: Image.asset('asset/im/delete.png'),
                      onTap: () {
                        // print("a");
                        // print("category:$category_id");
                        // print("category type:${category_id.runtimeType}");

                        widget.onMenuDeleted(category_id);
                        // widget.minusNutrition(nutrition);
                        setState(() {
                          isData = !isData;
                        });
                      },
                    )
                  : Image.asset('asset/im/delete_white.png'),
            ],
          ),
        ),
      ],
    );
  }
}
