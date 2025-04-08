import 'package:flutter/material.dart';
import 'package:diabetes_meal_management_application_project/pages/static/bloodsugar_static.dart';
import 'package:diabetes_meal_management_application_project/pages/static/history.dart';

class BloodsugarPage extends StatefulWidget {
  // final Function(int) onNavigate;

  // const BloodsugarPage({Key? key, required this.onNavigate}) : super(key: key);

  @override
  State<BloodsugarPage> createState() => _BloodsugarPageState();
}

class _BloodsugarPageState extends State<BloodsugarPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
                      "ระดับน้ำตาลในเลือด",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NotoSansThai',
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "ประวัติการบริโภค",
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
            BloodsugarStaticPage(),
            HistoryPage(),
          ],
        ),
      ),
    );
  }
}
