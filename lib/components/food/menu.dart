import 'package:flutter/material.dart';
import 'package:diabetes_meal_management_application_project/pages/food/menudetail.dart';

// คอมโพเนนต์ที่แสดงรายการเมนูอาหาร
class MenuItemComponent extends StatefulWidget {
  final String name;
  final String Url;
  final String path;
  final String menu_id;
  final int category_id;
  final int color;
  final Map<String, dynamic> nutrition;
  MenuItemComponent(
      {required this.name,
      required this.Url,
      required this.path,
      required this.menu_id,
      required this.category_id,
      required this.nutrition,
      required this.color});

  @override
  State<MenuItemComponent> createState() => _MenuItemComponentState();
}

class _MenuItemComponentState extends State<MenuItemComponent> {
  @override
  void initState() {
    // print("widget.Url:${widget.Url}");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MenudetailPage(),
            settings: RouteSettings(
              arguments: {
                'Url': widget.Url,
                'name': widget.name,
                'path': widget.path,
                'menu_id': widget.menu_id,
                'category_id': widget.category_id,
                'color': widget.color,
                'nutrition':widget.nutrition
              },
            ),
          ),
        );
        // print("result: $result");
        // Make sure the widget is still mounted before using BuildContext

        //path 1 is pass menu value
        if (result != null) {
          if (result is Map && result['value'] == 1) {
            print(widget.category_id);
            Navigator.pop(context, {
              'value': 1,
              'img': widget.Url,
              'name': widget.name,
              'menu_id': widget.menu_id,
              'category_id': widget.category_id,
              'color': widget.color,
              'nutrition':widget.nutrition
            });
          } else if (result is String && result == "toPlanPage") {
            print("Go to plan page");
            DefaultTabController.of(context).animateTo(1);
          } else if (result is String && result == "fromLookallmenu") {
            print("fromLookallmenu");
            Navigator.pop(context, "fromLookallmenu");
          } else {
            print("result is not 1 or 2");
          }
        } else {
          print("result is null");
        }
      },
      child: Stack(
        children: [
          // กรอบนอกสุด (ขอบเขียว)
          Container(
            decoration: BoxDecoration(
              color: widget.color == 1
                  ? Color.fromRGBO(4, 178, 132, 1)
                  : widget.color == 2
                      ? Color.fromRGBO(255, 116, 56, 1)
                      : Color.fromRGBO(218, 22, 22, 1), // สีขอบนอกสุด
              borderRadius: BorderRadius.circular(10), // ตัดมุมโค้ง
            ),
            padding: EdgeInsets.all(4), // ขนาดของขอบเขียว
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // ขอบสีขาว (ระหว่างรูปกับขอบเขียว)
                borderRadius: BorderRadius.circular(5), // ตัดมุมให้ตรงกัน
              ),
              padding: EdgeInsets.all(4), // ขนาดของขอบขาว
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: AspectRatio(
                  aspectRatio: 1, // มุมรูปภาพ
                  child: Image.network(
                    widget.Url, // ใช้ URL จาก MongoDB
                    height: 170,
                    width: 170,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.broken_image,
                          size: 50, color: Colors.grey);
                    },
                  ),
                ),
              ),
            ),
          ),
          // ป้ายชื่ออาหาร
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: widget.color == 1
                    ? Color.fromRGBO(4, 178, 132, 1)
                    : widget.color == 2
                        ? Color.fromRGBO(255, 116, 56, 1)
                        : Color.fromRGBO(218, 22, 22, 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ConstrainedBox(
                constraints:
                    BoxConstraints(maxWidth: 140), // ป้องกันข้อความยาวเกินไป
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    widget.name,
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
          ),
        ],
      ),
    );
  }
}
