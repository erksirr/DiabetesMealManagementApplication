import 'package:flutter/material.dart';

class Tagmenu extends StatelessWidget {
  final String title;
  final String textColorHex;
  final List<String> borderGradientHex;
  final String backgroundColorHex;
  final VoidCallback onTap;
  final bool isSelected;

  const Tagmenu({
    Key? key,
    required this.title,
    required this.onTap,
    required this.isSelected,
    this.textColorHex = "4AB284",
    this.borderGradientHex = const ["4AB284", "D6F9FD"],
    this.backgroundColorHex = "D6F9FD",
  }) : super(key: key);

  Color _hexToColor(String hex) {
    hex = hex.replaceAll("#", "");
    if (hex.length == 6) {
      hex = "FF$hex";
    }
    return Color(int.parse("0x$hex"));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSelected
                ? [
                    _hexToColor(backgroundColorHex),
                    _hexToColor(backgroundColorHex)
                  ]
                : borderGradientHex.map((hex) => _hexToColor(hex)).toList(),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          margin: const EdgeInsets.all(1),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(
            color: isSelected
                ? _hexToColor(textColorHex)
                : _hexToColor(backgroundColorHex),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: isSelected
                  ? _hexToColor(backgroundColorHex)
                  : _hexToColor(textColorHex),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
