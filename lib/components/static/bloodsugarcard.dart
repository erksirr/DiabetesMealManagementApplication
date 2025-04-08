import 'package:flutter/material.dart';

class Bloodsugarcard extends StatefulWidget {
  final Color color;
  final String text;
  final int num;
  const Bloodsugarcard({Key? key, required this.color, required this.text, required this.num})
      : super(key: key);
 
  @override
  State<Bloodsugarcard> createState() => _BloodsugarcardState();
}

class _BloodsugarcardState extends State<Bloodsugarcard> {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      shadowColor: Colors.black,
      borderRadius: BorderRadius.circular(8), // Add borderRadius to Material

      child: Container(
        width: 110,
        height: 110,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(8), // Add borderRadius here
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 16.0, left: 8, right: 8, bottom: 16), // Inside card padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("${widget.text}",
                  style: TextStyle(fontSize: 11, color: Colors.white)),
              Text("${widget.num}",
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              Text("mg/dL",
                  style: TextStyle(fontSize: 11, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
