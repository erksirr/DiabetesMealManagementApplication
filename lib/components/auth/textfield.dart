import 'package:flutter/material.dart';

class Textfield extends StatefulWidget {
  final String text; // Text to display on the button
  final bool obscureText;
  final Function(String)? onChanged;
  final TextEditingController
      controller; // Callback function for the button press
  final String? hint; // Hint text for the TextField

  const Textfield({
    Key? key,
    required this.text, // Marked as required
    required this.controller, // Marked as required
    this.obscureText = false,
    this.onChanged,
    this.hint, // Optional hint text
  }) : super(key: key);

  @override
  _TextfieldState createState() => _TextfieldState();
}

class _TextfieldState extends State<Textfield> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      child: Builder(builder: (BuildContext context) {
        final isFocused = Focus.of(context).hasFocus;
        return TextField(
          controller: widget.controller,
          obscureText: _obscureText,
          cursorColor: Colors.black,
          style: TextStyle(
            color: isFocused
                ? Color.fromRGBO(101, 169, 200, 1) // blue when focused
                : Colors.black, // Default color when not focused
            fontSize: 16,
          ),
          decoration: InputDecoration(
              labelText: widget.text,
              hintText: widget.hint, // Add hint text here
              labelStyle: TextStyle(
                  color: Color.fromRGBO(74, 178, 132, 1),
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
              fillColor: Color.fromRGBO(236, 255, 247, 1),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 2.0, horizontal: 12.0),
              suffixIcon: widget.obscureText
                  ? IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Color.fromRGBO(74, 178, 132, 1),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                  : null),
          onChanged: widget.onChanged,
        );
      }),
    );
  }
}
