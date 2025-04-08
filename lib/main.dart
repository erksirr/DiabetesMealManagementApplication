import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diabetes_meal_management_application_project/pages/auth/firstpage.dart';
import 'package:diabetes_meal_management_application_project/pages/auth/login.dart';
import 'package:diabetes_meal_management_application_project/pages/noti/notification.dart';
import 'package:diabetes_meal_management_application_project/pages/profile/profile.dart';
import 'package:diabetes_meal_management_application_project/pages/static/beverages.dart';
import 'package:diabetes_meal_management_application_project/pages/static/bloodsugar.dart';
import 'package:diabetes_meal_management_application_project/pages/static/history.dart';
import 'package:diabetes_meal_management_application_project/pages/static/mainmeal.dart';
import 'package:diabetes_meal_management_application_project/pages/static/fruit.dart';
import 'package:diabetes_meal_management_application_project/pages/tips/tips.dart';
import 'package:diabetes_meal_management_application_project/pages/home/recommend.dart';
import 'package:diabetes_meal_management_application_project/controllers/blood_sugar_controller.dart';
import 'package:diabetes_meal_management_application_project/controllers/dexcom_controller.dart';
import 'package:diabetes_meal_management_application_project/controllers/connection_controller.dart';
import 'package:diabetes_meal_management_application_project/controllers/blood_sugar_check_controller.dart';


void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  setupControllers();
  Future.delayed(Duration(seconds: 3), () {
    runApp(MyApp());
  });
}

void setupControllers() {
  Get.lazyPut(() => ConnectionController());
  Get.lazyPut(() => DexcomController());
  Get.lazyPut(() => BloodSugarController());
  Get.lazyPut(() => BloodSugarCheckController());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'NotoSansThai',
        primaryColor: Colors.white,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.white,
          onPrimary: Colors.black,
        ),
      ),
      initialRoute: '/', // กำหนดให้ FirstPage() เป็นหน้าแรก
      initialBinding: BindingsBuilder(() {
        // ใช้ initialBinding แทน Get.put()
        Get.lazyPut(() => BloodSugarController());
        Get.lazyPut(() => BloodSugarCheckController());
      }),

      getPages: [
        GetPage(name: '/', page: () => FirstPage()),
        GetPage(name: '/login', page: () => LoginPage()),
      ],
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(index,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          RecommendPage(),
          BloodsugarPage(),
          TipsPage(),
          NotificationPage(),
          ProfilePage(onNavigate: _onItemTapped),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'หน้าหลัก',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.query_stats),
            label: 'สถิติ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.playlist_add_check),
            label: 'ข้อมูล',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active_outlined),
            label: 'แจ้งเตือน',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: 'โปรไฟล์',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromRGBO(74, 178, 132, 1),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
