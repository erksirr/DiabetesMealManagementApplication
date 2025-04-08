import 'package:flutter/material.dart';
import 'package:diabetes_meal_management_application_project/pages/home/lookallmenu.dart';
import 'package:diabetes_meal_management_application_project/components/home/tipforfood.dart';

class Header extends StatefulWidget {
  final String title;
  final String titletips_type;
  final String titletips_name;
  final String titletips_p1;
  final String titletips_p2;

  const Header({
    Key? key,
    required this.title,
    required this.titletips_type,
    required this.titletips_name,
    required this.titletips_p1,
    required this.titletips_p2,
    // Marked as required
  }) : super(key: key);
  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  // Marked as required});
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        margin: const EdgeInsets.fromLTRB(5, 5, 5, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 2.0, vertical: 0.0),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: TipForFood(
                              title: widget.title,
                              titletips_type: widget.titletips_type,
                              titletips_name: widget.titletips_name,
                              titletips_p1: widget.titletips_p1,
                              titletips_p2: widget.titletips_p2,
                            ),
                          );
                        },
                      );
                    },
                    child: Row(
                      children: [
                        Image.asset(
                          'asset/im/icons8_idea.png',
                          fit: BoxFit.contain,
                        ),
                        Text("คำแนะนำ",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFFFF7E47),
                            )),
                      ],
                    ),
                  ),
                ),
                Image.asset(
                  'asset/im/Rectangle 65.png',
                  fit: BoxFit.contain,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 2.0, vertical: 0.0),
                  child: GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LookallmenuPage(
                              categoryId: widget.title == 'เมนูอาหาร'
                                  ? 1
                                  : widget.title == 'เครื่องดื่ม'
                                      ? 3
                                      : 2,
                              searchText: widget.title == 'เมนูอาหาร'
                                  ? "ค้นหาอาหารของคุณ"
                                  : widget.title == 'เครื่องดื่ม'
                                      ? "ค้นหาเครื่องดื่มของคุณ"
                                      : "ค้นหาผลไม้ของคุณ",
                              path: "LookallmenuRecommend"),
                        ),
                      );
                      if (result is String && result == "fromLookallmenu") {
                        DefaultTabController.of(context).animateTo(1);
                      }
                    },
                    child: Text("ดูทั้งหมด",
                        style:
                            TextStyle(fontSize: 16, color: Color(0xFF20A1DC))),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
