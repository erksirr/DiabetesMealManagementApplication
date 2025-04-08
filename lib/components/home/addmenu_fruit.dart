import 'package:flutter/material.dart';
import 'package:diabetes_meal_management_application_project/pages/food/menudetail.dart';
import 'package:diabetes_meal_management_application_project/pages/home/lookallmenu.dart';

class AddmenuFruit extends StatefulWidget {
  final String name;
  final String nameAdd;
  final List menulist;

  final Function(int, dynamic) onMenuSelected;
  final Function(int) onMenuDeleted;

  AddmenuFruit(
      {Key? key,
      required this.name,
      required this.nameAdd,
      required this.onMenuSelected,
      required this.onMenuDeleted,
      required this.menulist,
    })
      : super(key: key);

  @override
  AddmenuFruitState createState() => AddmenuFruitState();
}

class AddmenuFruitState extends State<AddmenuFruit> {
  List<int> _selectedItems = [0, 0, 0]; // เก็บสถานะของแต่ละช่อง
  List<String> getpic = ["", "", ""]; // เก็บภาพแยกตาม index
  List<String> menuname = ["", "", ""]; // เก็บชื่อเมนูแยกตาม index
  List<String> menu_id = [];
  List<int> color = [0, 0, 0];
  List menulist = [];
  void setvalue() {
    setState(() {
      menulist=[];
      menulist = widget.menulist;
print(menulist.length);
      for (var i = 0; i < menulist.length; i++) {
        menuname[i] = menulist[i]['name'];
        getpic[i] = menulist[i]['Url'] ?? '';
        menu_id.add(menulist[i]['menu_id']);
        color[i] = menulist[i]['color'];

        // print(
        //     "Name: ${menulist[i]['name']}, URL: ${menulist[i]['Url']}, Menu ID: ${menulist[i]['menu_id']}");
      }
    });
  }

  @override
  void initState() {
    if (widget.menulist.isNotEmpty) {
      if (widget.menulist.length == 2) {
        _selectedItems = [1, 1, 0];
      } else if (widget.menulist.length == 3) {
        _selectedItems = [1, 1, 1];
      } else {
        _selectedItems = [1, 0, 0];
      }
    }

    // print("hi:${widget.menulist}");
    // print("widget.menulist.fruit: ${widget.menulist}");
    // print("_selectedItems: $_selectedItems");
    // print("menu_idoo: $menu_id");
    setvalue();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AddmenuFruit oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.menulist != oldWidget.menulist) {
      setvalue();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 355,
      height: 210,
      decoration: BoxDecoration(
        color: Color.fromRGBO(203, 203, 203, 0.2),
        border: Border.all(
          color: Colors.white,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(3, (index) {
              return GestureDetector(
                onTap: () async {
                  if (_selectedItems[index] != 1) {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LookallmenuPage(
                            categoryId: 2,
                            searchText: "ค้นหาผลไม้ของคุณ",
                            path: "fromAddmenu"),
                      ),
                    );
                  
                    // print(result);
                    if (result != null &&
                        result is Map<String, dynamic> &&
                        result.containsKey('value')) {
                      // print("result: $result");
                      getpic[index] = result['img'];
                      menuname[index] = result['name'];
                      color[index] = result['color'];
                      // widget.refreshmenu();
                      widget.onMenuSelected(2, {
                        'name': result['name'],
                        'Url': result['img'],
                        'menu_id': result['menu_id']
                      });
                      setState(() {
                        _selectedItems[index] = 1; // Use '=' for assignment
                      });
                    }
                  }
                },
                child: Container(
                  width: 110,
                  height: 136,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          _selectedItems[index] == 0
                              ? Image.asset('asset/im/add.png', width: 30)
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: GestureDetector(
                                    child: Image.network(
                                      getpic[index], // ใช้ URL จาก MongoDB
                                      height: 130,
                                      width: 130,
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
                                              'Url': getpic[index],
                                              'name': menuname[index],
                                              'path': "close",
                                              'menu_id': menu_id[index],
                                            },
                                          ),
                                        ), // ลิงก์ไปยังหน้า breakfast.dart
                                      );
                                    },
                                  ),
                                ),
                          _selectedItems[index] == 0
                              ? SizedBox.shrink()
                              : Positioned(
                                  // top: 12,
                                  // left: 12,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: color[index] == 1
                                          ? Color.fromRGBO(4, 178, 132, 1)
                                          : color[index] == 2
                                              ? Color.fromRGBO(255, 116, 56, 1)
                                              : Color.fromRGBO(218, 22, 22, 1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      menuname[index],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.only(left: 6),
            height: 50,
            width: 375,
            color: Colors.white,
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
                _selectedItems.contains(1)
                    ? GestureDetector(
                        child: Image.asset('asset/im/delete.png'),
                        onTap: () {
                          widget.onMenuDeleted(2);
                          setState(() {
                            setState(() {
                              _selectedItems = [0, 0, 0];
                            });
                          });
                        }, // รีเซ็ตทั้งหมด
                      )
                    : Image.asset('asset/im/delete_white.png'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
