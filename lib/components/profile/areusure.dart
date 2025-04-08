import 'package:flutter/material.dart';

class Areusure extends StatefulWidget {
  const Areusure({super.key});

  @override
  State<Areusure> createState() => _AreusureState();
}

class _AreusureState extends State<Areusure> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text('ต้องการย้อนกลับหรือไม่',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            )),
      ),
      content: Container(
        // width: 20,
        height: 40,
        child: Center(
          child: Text(
              'หากคุณย้อนกลับตอนนี้ การเปลี่ยนแปลงที่คุณทำไปจะไม่ได้รับการบันทึก'),
        ),
      ),
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
                        .solid, // Border style (can als so be dotted, dashed, etc.)
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
                  Navigator.pop(context,"Don't stay");
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
                child: const Text('แก้ไขต่อไป',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.pop(context);
                  // Navigate to profile
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
