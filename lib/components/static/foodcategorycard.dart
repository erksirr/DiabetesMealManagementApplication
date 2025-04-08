import 'package:flutter/material.dart';

class Foodcategorycard extends StatelessWidget {
  final String label;
  final String imageUrl;
  final VoidCallback onPressed;
  final num number; // Add a number to display in the box

  const Foodcategorycard({
    Key? key,
    required this.label,
    required this.imageUrl,
    required this.onPressed,
    required this.number, // Number is required
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(236, 255, 247, 1), // Background color
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          tileColor: Color.fromRGBO(236, 255, 247, 1), // Background color
          title: Text(
            label,
            style: TextStyle(
              color: Color.fromRGBO(74, 178, 131, 1),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min, // Keeps row compact
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(74, 178, 131, 1), // Box color
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  number.toString(), // Display the number
                  style: TextStyle(
                    color: Colors.white, // Text color
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(width: 10), // Space between number box and icon
              Icon(
                Icons.chevron_right,
                color: Color.fromRGBO(74, 178, 131, 1),
                size: 40, // Adjust icon size
              ),
            ],
          ),
        ),
      ),
    );
  }
}
