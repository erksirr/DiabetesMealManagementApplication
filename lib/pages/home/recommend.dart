import 'package:flutter/material.dart';
import 'package:diabetes_meal_management_application_project/pages/home/plan.dart';

import 'package:diabetes_meal_management_application_project/pages/home/recommend_menu.dart'; // Import คอมโพเนนต์จาก meal.dart\

// ตัวอย่าง model สำหรับเมนูอาหาร

class RecommendPage extends StatefulWidget {
  @override
  _RecommendPageState createState() => _RecommendPageState();
}

class _RecommendPageState extends State<RecommendPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
          elevation: 5,
          shadowColor: const Color.fromRGBO(0, 0, 0, 0.25),
          surfaceTintColor: Colors.transparent,
          title: Column(
            children: [
              TabBar(
                labelColor: Color.fromRGBO(74, 178, 132, 1),
                unselectedLabelColor: Colors.black,
                indicatorColor: Color.fromRGBO(74, 178, 132, 1),
                tabs: [
                  Tab(
                    child: Text(
                      "แนะนำเมนูอาหาร",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NotoSansThai',
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "วางแผนมื้ออาหาร",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NotoSansThai',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // หน้าแนะนำเมนูอาหาร
            RecommendMenuPage(),
            // หน้าใหม่สำหรับวางแผนมื้ออาหาร
            PlanPage()
          ],
        ),
      ),
    );
  }
}
