import 'package:flutter/material.dart';

class Notibox extends StatefulWidget {
  final num bloodSugar;
  final String time;
  const Notibox({Key? key, required this.bloodSugar, required this.time})
      : super(key: key);

  @override
  State<Notibox> createState() => _NotiboxState();
}

class _NotiboxState extends State<Notibox> {
  String checkBloodSugarLeveltoString() {
    if (widget.bloodSugar < 50) {
      return 'รระดับน้ำตาลของคุณอยู่ในระดับอันตราย!';
    } else if (widget.bloodSugar < 70) {
      return 'ะดับน้ำตาลในเลือดของคุณต่ำกว่าปกติ!';
    } else if (widget.bloodSugar >= 70 && widget.bloodSugar <= 100) {
      return 'ระดับน้ำตาลในเลือดของคุณปกติ';
    } else if (widget.bloodSugar > 100 && widget.bloodSugar <= 180) {
      return 'ระดับน้ำตาลในเลือดของคุณปกติ';
    } else if (widget.bloodSugar > 180 && widget.bloodSugar <= 300) {
      return 'ระดับน้ำตาลของคุณสูงเกินไป!';
    } else {
      return 'ระดับน้ำตาลของคุณอยู่ในระดับอันตราย!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // จุดสีแดง
              widget.bloodSugar < 70 || widget.bloodSugar >= 180
                  ? Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    )
                  : SizedBox.shrink(),
              SizedBox(width: 5),
              // ข้อความ "ฉุกเฉิน!!!"
              widget.bloodSugar < 70 || widget.bloodSugar >= 180
                  ? Text(
                      "ฉุกเฉิน!!!",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(255, 0, 0, 1),
                      ),
                    )
                  : Text(
                      "อยู่ในเกณฑ์ปกติ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
              Spacer(), // ดัน "5น." ไปด้านขวาสุด
              Text(
                "${widget.time}",
                style: TextStyle(
                  fontSize: 12,
                  color: Color.fromRGBO(159, 159, 159, 1),
                ),
              ),
              // SizedBox(width: 16),
              // // ปุ่มปิด (Close Button)
              // Container(
              //   width: 20, // ขยายขนาดวงกลม
              //   height: 20,
              //   decoration: BoxDecoration(
              //     shape: BoxShape.circle,
              //     color: Color.fromRGBO(74, 178, 132, 1),
              //   ),
              //   child: Center(
              //     child: Icon(
              //       Icons.close_rounded, // ใช้เวอร์ชันที่หนากว่า
              //       color: Colors.white,
              //       size: 14, // ปรับขนาดไอคอนให้ใหญ่ขึ้น
              //     ),
              //   ),
              // ),
            ],
          ),
          SizedBox(height: 16), // ระยะห่างระหว่างข้อความ
          Row(
            children: [
              Container(
                  width: 20, // ขยายขนาดวงกลม
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(
                      // เพิ่มขอบสี
                      color: Color.fromRGBO(255, 0, 0, 1), // สีขอบ
                      width: 2, // ความหนาของขอบ
                    ),
                  ),
                  child: Center(
                      child: Text(
                    "!",
                    style: TextStyle(color: Color.fromRGBO(255, 0, 0, 1)),
                  ))),
              SizedBox(
                width: 10,
              ),
              Text(
                checkBloodSugarLeveltoString(),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(height: 16), // ระยะห่างระหว่างข้อความ
          Row(
            children: [
              Image.asset("asset/im/blood_red.png"),
              SizedBox(
                width: 14,
              ),
              Text("ค่าระดับน้ำตาลคือ"),
              SizedBox(
                width: 6,
              ),
              Text(
                "${widget.bloodSugar}",
                style: TextStyle(
                    color: Color.fromRGBO(255, 0, 0, 1),
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                width: 6,
              ),
              Text("มิลลิกรัม/เดซิลิตร"),
            ],
          )
        ],
      ),
    );
  }
}
