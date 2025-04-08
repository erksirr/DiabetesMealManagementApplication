import 'package:flutter/material.dart';

class Backbutton extends StatelessWidget {
  final VoidCallback onPressed;

  const Backbutton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Container(
          width: 50, // Width of the circle
          height: 50, // Height of the circle
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(74, 178, 132, 1), // Start color
                Color.fromRGBO(101, 169, 200, 1), // End color
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: EdgeInsets.only(left: 8, top: 8, bottom: 8),
          child: Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
        ),
      ),
      onPressed: onPressed,
    );
  }
}
