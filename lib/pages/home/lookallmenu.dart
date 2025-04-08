import 'package:flutter/material.dart';
import 'package:diabetes_meal_management_application_project/apis/Api_menu.dart';
import 'package:diabetes_meal_management_application_project/components/backbutton.dart';
import 'package:diabetes_meal_management_application_project/components/food/menu.dart';
import 'package:diabetes_meal_management_application_project/components/food/tagmenu.dart';

class LookallmenuPage extends StatefulWidget {
  final int categoryId;
  final String searchText;
  final String path;
  const LookallmenuPage(
      {super.key,
      required this.categoryId,
      this.searchText = '',
      required this.path});

  @override
  State<LookallmenuPage> createState() => _LookallmenuPageState();
}

class _LookallmenuPageState extends State<LookallmenuPage> {
  final TextEditingController _searchController = TextEditingController();
  String search = '';
  List<int> cooking_type_Id = [];

  int? selectedTagIndex; // ใช้เก็บค่าของป้ายกำกับที่เลือก
  int? color; // ใช้เก็บค่าของป้ายกำกับที่เลือก
  List<Map<String, String>> tagMenuData = [
    {
      "title": "ทานได้ประจำ",
      "textColorHex": "4AB284",
      "borderGradientHex1": "D6F9E9",
      "borderGradientHex2": "D6F9E9",
      "backgroundColorHex": "D6F9E9"
    },
    {
      "title": "ทานในปริมาณที่เหมาะสม",
      "textColorHex": "FF7438",
      "borderGradientHex1": "FFEBDF",
      "borderGradientHex2": "FFEBDF",
      "backgroundColorHex": "FFEBDF"
    },
    {
      "title": "ควรหลีกเลี่ยง",
      "textColorHex": "DA1616",
      "borderGradientHex1": "FFE5E5",
      "borderGradientHex2": "FFE5E5",
      "backgroundColorHex": "FFE5E5"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        elevation: 5,
        shadowColor: const Color.fromRGBO(0, 0, 0, 0.25),
        surfaceTintColor: Colors.transparent,
        leading: Backbutton(onPressed: () {
          Navigator.pop(context);
        }),
        title: Container(
          width: 300,
          height: 40,
          child: Focus(
            child: Builder(builder: (BuildContext context) {
              final isFocused = Focus.of(context).hasFocus;
              return TextField(
                controller: _searchController,
                cursorColor: Colors.black,
                style: TextStyle(
                  color: isFocused
                      ? Color.fromRGBO(101, 169, 200, 1)
                      : Colors.black,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  label: Row(
                    children: [
                      Image.asset(
                        'asset/im/search.png',
                        height: 20,
                        width: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "${widget.searchText}",
                        style: TextStyle(
                          color: Color.fromRGBO(153, 153, 153, 1),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(160, 159, 159, 1),
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(160, 159, 159, 1),
                      width: 1.0,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 2.0, horizontal: 12.0),
                ),
                onChanged: (value) {
                  setState(() {
                    search = value;
                  });
                },
              );
            }),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0, bottom: 12),
            child: Column(
              children: [
                Row(
                  children: List.generate(tagMenuData.length, (index) {
                    return Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: Tagmenu(
                        title: tagMenuData[index]["title"]!,
                        textColorHex: tagMenuData[index]["textColorHex"]!,
                        borderGradientHex: [
                          tagMenuData[index]["borderGradientHex1"]!,
                          tagMenuData[index]["borderGradientHex2"]!
                        ],
                        backgroundColorHex: tagMenuData[index]
                            ["backgroundColorHex"]!,
                        isSelected: selectedTagIndex == index,
                        onTap: () {
                          setState(() {
                            if (selectedTagIndex == index) {
                              selectedTagIndex = null;
                              color = 0; // กดครั้งที่สองเพื่อยกเลิก
                            } else {
                              selectedTagIndex = index; // กดเพื่อเลือก
                              color = index + 1;
                            }
                          });
                          print("selectedTagIndex:${selectedTagIndex}");
                        },
                      ),
                    );
                  }),
                ),
                SizedBox(height: 5),
                Row(
                  children: List.generate(5, (index) {
                    List<String> titles = [
                      "ต้ม/นึ่",
                      "ปิ้ง/ย่าง",
                      "ยำ",
                      "เส้น",
                      "ผัด/ทอด"
                    ];
                    return Padding(
                      padding: EdgeInsets.only(right: 6),
                      child: Tagmenu(
                        title: titles[index],
                        textColorHex: "4AB284",
                        borderGradientHex: ["4AB284", "65A9C8"],
                        backgroundColorHex: "FFFFFF",

                        isSelected: cooking_type_Id
                            .contains(index + 1), // ส่งสถานะไปที่ Tagmenu
                        onTap: () {
                          setState(() {
                            if (cooking_type_Id.contains(index + 1)) {
                              cooking_type_Id.remove(index + 1);
                            } else {
                              cooking_type_Id.add(index + 1);
                            }
                          });
                        },
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: MenuService.getSearchMenu(
            categoryId: widget.categoryId,
            search: search,
            cooking_type_Id: cooking_type_Id,
            color: color),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Container(
              color: Color.fromRGBO(238, 238, 238, 1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.block,
                        size: 50,
                        color: Color.fromRGBO(123, 123, 123, 1),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "ขออภัย",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 20),
                      ),
                      Text(
                        "ไม่พบเมนูที่ค้นหา",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ));
          }
          var recommendMenuList = snapshot.data!;

//  print("recommendMenuListcolor:${recommendMenuList['color']}");
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 20.0,
              ),
              itemCount: recommendMenuList.length,
              itemBuilder: (context, index) {
                return MenuItemComponent(
                  name: recommendMenuList[index]['name'] ?? 'Unknown',
                  Url: recommendMenuList[index]['menu_img'],
                  menu_id: recommendMenuList[index]['_id'] ?? '',
                  // path: "LookallmenuRecommend",
                  path: widget.path,
                  category_id: recommendMenuList[index]['category_id'],
                  nutrition: recommendMenuList[index]['nutrition'],
                  color: recommendMenuList[index]['color'],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
