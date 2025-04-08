import 'package:flutter/material.dart';

class ButtonPressNext extends StatelessWidget {
  final String text; // Text to display on the button
  final VoidCallback onPressed; // Callback function for the button press

  const ButtonPressNext({
    Key? key,
    required this.text, // Marked as required
    required this.onPressed, // Marked as required
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              Colors.transparent, // Make button background transparent
          shadowColor: Colors.transparent, // Remove shadow
          minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
