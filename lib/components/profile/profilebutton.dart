import 'package:flutter/material.dart';

class Profilebutton extends StatelessWidget {
  final String url;
  final String title;
  final Function onPressed;
  const Profilebutton(
      {Key? key,
      required this.url, // Marked as required
      required this.title,
      required this.onPressed
      // Marked as required
      })
      : super(key: key); // Marked as required});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
      child: ListTile(
        leading: Image.asset('${url}'),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 16,
            // fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Icon(Icons.chevron_right,
            color: Color.fromRGBO(204, 204, 204, 1), size: 40),
        onTap: () {
          onPressed();
        },
      ),
    );
  }
}
