import 'package:flutter/material.dart';

class Confirmpopup extends StatefulWidget {
  final String textHeader;
  final String textAction;
   final Function onPressed;
   final String textContent;
 const Confirmpopup({Key? key, required this.textHeader,required this.textAction,required this.onPressed,this.textContent=''}) : super(key: key);

  @override
  State<Confirmpopup> createState() => _ConfirmpopupState();
}

class _ConfirmpopupState extends State<Confirmpopup> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text('${widget.textHeader}',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            )),
      ),
      content: widget.textContent.isNotEmpty? Container(
        // width: 20,
        height: 40,
        child: Text(
            '${widget.textContent}'),
      ):SizedBox.shrink(),
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(8.0), // Set the desired border radius here
      ),
      actions: <Widget>[
        Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch, // Stretch buttons to fill the width
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    // Border settings
                    color: Color.fromRGBO(74, 178, 132, 1), // Border color
                    width: 1, // Border width
                    style: BorderStyle
                        .solid, // Border style (can also be dotted, dashed, etc.)
                  ),
                  borderRadius: BorderRadius.circular(8)),
              child: TextButton(
                child: const Text(
                  'ย้อนกลับ',
                  style: TextStyle(
                        color: Color.fromRGBO(74, 178, 132, 1),
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(74, 178, 132, 1), // Start color
                    Color.fromRGBO(101, 169, 200, 1), // End color
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextButton(
                child: Text("${widget.textAction}",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                 onPressed: () async {
                  await widget.onPressed(); // เรียกใช้ฟังก์ชัน onPressed
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}