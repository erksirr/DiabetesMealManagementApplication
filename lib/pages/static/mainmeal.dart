import 'package:flutter/material.dart';
import 'package:diabetes_meal_management_application_project/components/backbutton.dart';
import 'package:diabetes_meal_management_application_project/components/static/menu_history.dart';

class MainmealPage extends StatefulWidget {
  @override
  _MainmealPageState createState() => _MainmealPageState();
}

class _MainmealPageState extends State<MainmealPage> {
  // Sample menu list with images and time data

  // void deleteMenuItem(int index) {
  //   setState(() {
  //     menuList.removeAt(index); // Remove the item at the given index
  //   });
  // }
  // @override
  // void initState() {

  // }
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    List<Map<String, dynamic>> menuList = args['menuList'];
    // print(menuList);
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.black,
        elevation: 1,
        backgroundColor: Colors.white,
        leading: Backbutton(
          onPressed: () {
            Navigator.pop(context); // Navigate back to previous page
          },
        ),
        title: Text(
          "อาหาร",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Color.fromRGBO(241, 241, 241, 1),
        padding: EdgeInsets.all(8),
        child: menuList.isEmpty
            ? Center(
                child: Text(
                  "ไม่มีรายการ", // Display "No items" message when list is empty
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
              )
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two columns
                  childAspectRatio: 0.8, // Adjust aspect ratio as needed
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 32.0,
                ),
                itemCount: menuList.length,
                itemBuilder: (context, index) {
                  return MenuHistory(
                    name: menuList[index]
                        ['name']!, // Pass the meal name to MenuHistory
                    imageUrl: menuList[index]['Url'] ??
                        'asset/menu/Rectangle 4.png', // Pass the image URL
                    time: menuList[index]['time'] ?? "", // Pass the meal time
                    meal: menuList[index]['meal'] ?? "", // Pass the meal time
                    color:menuList[index]['color'] ??""
                    // Pass the delete function
                  );
                },
              ),
      ),
    );
  }
}
