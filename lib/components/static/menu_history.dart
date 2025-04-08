import 'package:flutter/material.dart';

class MenuHistory extends StatefulWidget {
  final String name;
  final String imageUrl;
  final String time;
  final num color;
  final List<dynamic> meal;
  MenuHistory({
    Key? key,
    required this.name,
    required this.imageUrl,
    required this.time,
    required this.meal,
    required this.color
  }) : super(key: key);

  @override
  State<MenuHistory> createState() => _MenuHistoryState();
}

class _MenuHistoryState extends State<MenuHistory> {
  String translateMeal(String meal) {
    switch (meal) {
      case 'lunch':
        return 'กลางวัน';
      case 'dinner':
        return 'เย็น';
      case 'breakfast':
        return 'เช้า';
      default:
        return meal;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Image inside a column for layout purposes
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              widget.imageUrl, // ใช้ URL จาก MongoDB
              height: 200,
              width: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.broken_image, size: 50, color: Colors.grey);
              },
            ),
          ),
        ),
        // Positioned tag (name) at the top left
        Positioned(
          top: 5,
          left: 5,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            decoration: BoxDecoration(
              color: widget.color == 1
                  ? Color.fromRGBO(4, 178, 132, 1)
                  : widget.color == 2
                      ? Color.fromRGBO(255, 116, 56, 1)
                      : Color.fromRGBO(218, 22, 22, 1), // สีขอบนอกสุด
              borderRadius: BorderRadius.circular(10), // ตัดมุมโค้ง
            ),
            child: Text(
              widget.name,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        // Positioned time and icon buttons at the bottom
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              height: 40,
              width: 190,
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Text("มื้อ : ",style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),),
                  Text(
                    widget.meal.map((m) => translateMeal(m)).join(", "),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
