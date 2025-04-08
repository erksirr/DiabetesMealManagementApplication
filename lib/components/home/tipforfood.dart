import 'package:flutter/material.dart';

class TipForFood extends StatelessWidget {
  final String title;
  final String titletips_type;
  final String titletips_name;
  final String titletips_p1;
  final String titletips_p2;

  const TipForFood({
    Key? key,
    required this.title,
    required this.titletips_type,
    required this.titletips_name,
    required this.titletips_p1,
    required this.titletips_p2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // คำนวณข้อความสำหรับบรรทัดแรกและข้อความที่เหลือ
    final textStyle = TextStyle(fontSize: 16);
    final maxWidth =
        MediaQuery.of(context).size.width - 170; // ความกว้างที่ใช้ได้
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: titletips_p2, style: textStyle),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);

    final firstLineText = titletips_p2.substring(
      0,
      textPainter.getPositionForOffset(Offset(maxWidth, 0)).offset,
    );
    final remainingText = titletips_p2.substring(firstLineText.length).trim();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                titletips_name,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Image.asset('asset/im/Vector (1).png'),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Image.asset('asset/im/Rectangle 66.png'),
          const SizedBox(height: 12),
          Text(
            titletips_p1,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "หลีกเลี่ยง",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFFF0000),
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xFFFF0000),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      firstLineText,
                      style: textStyle,
                      softWrap: false,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ],
              ),
              if (remainingText.isNotEmpty)
                Text(
                  remainingText,
                  style: textStyle,
                  softWrap: true,
                ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
