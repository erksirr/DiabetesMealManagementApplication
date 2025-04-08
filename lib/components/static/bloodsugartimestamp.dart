import 'package:flutter/material.dart';

class Bloodsugartimestamp extends StatelessWidget {
  final String time;
  final String glucoseRange;
  const Bloodsugartimestamp(
      {Key? key, required this.time, required this.glucoseRange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              RotatedBox(
                quarterTurns: 2,
                child: IconButton(
                  icon: Container(
                    width: 25, // Set the width of the circle
                    height: 25, // Set the height of the circle
                    // decoration: BoxDecoration(
                    //     shape: BoxShape.circle,
                    //     border: Border.all(
                    //         width: 2.0,
                    //         color: Color.fromRGBO(46, 169, 51,
                    //             1)) // Background color for the circle
                    //     ),
                    padding: EdgeInsets.only(left: 5),
                    child: Icon(Icons.arrow_back_ios,
                        color: Color.fromRGBO(74, 178, 132, 1), size: 18),
                  ),
                  onPressed: null,
                ),
              ),
              Text(time,
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      color: Color.fromRGBO(113, 113, 113, 1))),
            ],
          ),
          Text(glucoseRange,
              style: TextStyle(fontSize: 15, color: Colors.black)),
        ],
      ),
    );
  }
}
