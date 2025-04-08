import 'package:flutter/material.dart';
import 'package:diabetes_meal_management_application_project/components/food/menu.dart';

class Menulistview extends StatefulWidget {
  final List menulist;
  final String path; // เพิ่มพารามิเตอร์ใหม่
  const Menulistview({
    Key? key,
    required this.menulist,
    required this.path,
  }) : super(key: key);

  @override
  State<Menulistview> createState() => _MenulistviewState();
}

class _MenulistviewState extends State<Menulistview> {
  void initState() {
    // print("ควย:${widget.menulist}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.menulist.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 4), // เพิ่มระยะห่างระหว่างรายการในแนวนอน
            child: MenuItemComponent(
                name: widget.menulist[index]['name'] ?? 'Unknown',
                Url: widget.menulist[index]['Url'] ?? '',
                menu_id: widget.menulist[index]['menu_id'],
                category_id: widget.menulist[index]['category_id'],
                path: widget.path,
                nutrition: widget.menulist[index]['nutrition'],
                color: widget.menulist[index]['color'] ?? 0),
          );
        },
      ),
    );
  }
}
