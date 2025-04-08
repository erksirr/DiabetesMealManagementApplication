import 'package:flutter/material.dart';
import 'package:diabetes_meal_management_application_project/components/auth/showerrordialog.dart';

class Planmealbutton extends StatefulWidget {
  final String title;
  final String time;
  final String leadingImagePath;
  final VoidCallback onPressed;
  final String trailingImagePath;
  final String isplaned;
  const Planmealbutton({
    Key? key,
    required this.onPressed,
    required this.leadingImagePath, // Marked as required
    required this.title,
    required this.time,
    required this.trailingImagePath,
    required this.isplaned,
  }) : super(key: key);
  @override
  State<Planmealbutton> createState() => _PlanmealbuttonState();
}

class _PlanmealbuttonState extends State<Planmealbutton> {
  // Marked as required});

  @override
  Widget build(BuildContext context) {
  
    // กำหนดค่าของ imgplaned ตามค่า isplaned
    String planText = widget.isplaned == "a"
        ? 'วางแผนเรียบร้อยแล้ว'
        : widget.isplaned == 'c'
            ? 'รับประทานมื้อนี้เรียบร้อย'
            : widget.isplaned == 'd'
                ? 'ผ่านการวางแผนวันนี้ไปแล้ว'
                : 'ยังไม่ได้วางแผน';

    return InkWell(
      onTap: () {
        widget.isplaned == 'd'
            ? ShowErrorDialog.show(context, 'ผ่านการวางแผนวันนี้ไปแล้ว',
                'คุณได้ผ่านการวางแผนอาหารวันนี้ไปแล้ว')
            : widget.isplaned != 'c'
                ? widget.onPressed()
                : ShowErrorDialog.show(context, 'รับประทานมื้อนี้เรียบร้อย',
                    'คุณได้รับประทานอาหารมื้อนี้ไปแล้ว');
      }, // ใช้ onPressed เมื่อกดปุ่ม
      child: Container(
        width: double.infinity,
        height: 68,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // กลุ่มของ Container ที่ 1 และ 2 ติดกันทางซ้าย
            Row(
              children: [
                // รูปภาพด้านซ้าย
                Container(
                  width: 39.73,
                  height: 35.31,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(widget.leadingImagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // ข้อความถัดจากรูปภาพ
                SizedBox(width: 10), // เพิ่มช่องว่างระหว่างรูปภาพและข้อความ
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(fontSize: 19),
                ),
                Row(
                  children: [
                    Text(
                      widget.time,
                      style: TextStyle(color: Color.fromRGBO(150, 150, 150, 1)),
                    ),
                    SizedBox(width: 8), // ช่องว่างระหว่างข้อความและรูป
                    Container(
                      decoration: BoxDecoration(
                          color: widget.isplaned == "a"
                              ? Color.fromRGBO(231, 255, 244, 1)
                              : widget.isplaned == 'c'||widget.isplaned=="d"
                                  ? Color.fromRGBO(255, 229, 229, 1)
                                  : Color.fromRGBO(240, 240, 240, 1)),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Center(
                          child: Text(
                            planText,
                            
                            style: TextStyle(
                              fontSize: widget.isplaned=="d"?12:null,
                                color: widget.isplaned == "a"
                                    ? Color.fromRGBO(74, 178, 132, 1)
                                    : widget.isplaned == 'c'||widget.isplaned=="d"
                                        ? Color.fromRGBO(218, 22, 22, 1)
                                        : Color.fromRGBO(123, 123, 123, 1)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Spacer เพื่อดัน Container ที่ 3 ไปอยู่ทางขวา
            Spacer(),
            // รูปภาพด้านขวา
            Container(
              width: 13.75,
              height: 25.03,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(widget.trailingImagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
