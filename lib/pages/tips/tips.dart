import 'package:flutter/material.dart';
import 'package:diabetes_meal_management_application_project/pages/tips/foodtips.dart';
import 'package:diabetes_meal_management_application_project/pages/tips/controltips.dart';
import 'package:diabetes_meal_management_application_project/pages/tips/exercisetips.dart';
import 'package:diabetes_meal_management_application_project/pages/tips/healthtips.dart';

class TipsPage extends StatelessWidget {
  const TipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       
        title: const Text(
          "เคล็ดลับดูแลตัวเองเมื่อเป็นเบาหวาน",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
         scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        elevation: 5,
        shadowColor: const Color.fromRGBO(0, 0, 0, 0.25),
        surfaceTintColor: Colors.transparent,
      ),
      backgroundColor: const Color(0xFFF1F1F1),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(), // เพิ่มการ scroll แบบเด้ง
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      "โรคเบาหวานคืออะไร",
                      style: TextStyle(
                        color: Color(0xFF4AB284),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: const Text(
                            "โรคเบาหวาน เป็นโรคเรื้อรังซึ่งเกิดจากประสิทธิภาพการสร้างฮอร์โมนอินซูลินของตับอ่อนลดลงส่งผลให้ร่างกายไม่สามารถเผาผลาญอาหารประเภทแป้งและน้ำตาลได้อย่างมีประสิทธิภาพ",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: Image.asset(
                            'asset/im/dia.png',
                            height: 104,
                            width: 102,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FoodTipsPage()),
                    );
                  },
                  child: const TipsBox(
                    title: "อาหาร",
                    iconPath: 'asset/im/foodtips.png',
                    backgroundColor: Colors.orange,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ControlTipsPage()),
                    );
                  },
                  child: const TipsBox(
                    title: "ควบคุมอาหาร",
                    iconPath: 'asset/im/controltips.png',
                    backgroundColor: Colors.blue,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ExerciseTipsPage()),
                    );
                  },
                  child: const TipsBox(
                    title: "ออกกำลังกาย",
                    iconPath: 'asset/im/exercisetips.png',
                    backgroundColor: Color(0xFF4AB284),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HealthTipsPage()),
                    );
                  },
                  child: const TipsBox(
                    title: "สุขภาพ",
                    iconPath: 'asset/im/healthtips.png',
                    backgroundColor: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "ทำไมต้องควบคุมอาหารเมื่อเป็นเบาหวาน?",
                      style: TextStyle(
                        color: Color(0xFF4AB284),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: const [
                        ListTile(
                          leading:
                              Icon(Icons.check_circle, color: Colors.orange),
                          title: Text(
                            "ควบคุมระดับน้ำตาลในเลือดให้อยู่ในเกณฑ์ที่ปลอดภัย",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        ListTile(
                          leading:
                              Icon(Icons.check_circle, color: Colors.orange),
                          title: Text(
                            "ลดการทานน้ำตาลและคาร์โบไฮเดรตสูง",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        ListTile(
                          leading:
                              Icon(Icons.check_circle, color: Colors.orange),
                          title: Text(
                            "เลือกอาหารที่มีไฟเบอร์สูง เช่น ผักผลไม้สด และธัญพืชเต็มเมล็ด",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        ListTile(
                          leading:
                              Icon(Icons.check_circle, color: Colors.orange),
                          title: Text(
                            "ช่วยลดความเสี่ยงจากภาวะแทรกซ้อน เช่น โรคหัวใจและไต",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        ListTile(
                          leading:
                              Icon(Icons.check_circle, color: Colors.orange),
                          title: Text(
                            "ส่งเสริมคุณภาพชีวิตที่ดีขึ้นและยืนยาว",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "ประโยชน์ของการออกกำลังกายในผู้ป่วยเบาหวาน",
                      style: TextStyle(
                        color: Color(0xFF4AB284),
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: const [
                        ListTile(
                          leading:
                              Icon(Icons.fitness_center, color: Colors.orange),
                          title: Text(
                            "ช่วยให้เซลล์ของร่างกายไวต่ออินซูลินมากขึ้น ทำให้ช่วยลดระดับน้ำตาลในเลือด",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        ListTile(
                          leading:
                              Icon(Icons.fitness_center, color: Colors.orange),
                          title: Text(
                            "เพิ่มการไหลเวียนของเลือดทั่วร่างกาย และช่วยป้องกันภาวะแทรกซ้อน เช่น แผลที่เท้า",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        ListTile(
                          leading:
                              Icon(Icons.fitness_center, color: Colors.orange),
                          title: Text(
                            "ช่วยควบคุมน้ำหนักและลดไขมันส่วนเกิน",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        ListTile(
                          leading:
                              Icon(Icons.fitness_center, color: Colors.orange),
                          title: Text(
                            "ช่วยลดปริมาณยาที่ต้องใช้ร่วมกับการฉีดอินซูลิน",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TipsBox extends StatelessWidget {
  final String title;
  final String iconPath;
  final Color backgroundColor;

  const TipsBox({
    required this.title,
    required this.iconPath,
    required this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 179,
      height: 65,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            color: backgroundColor,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              iconPath,
              height: 40,
              width: 40,
            ),
          ),
        ],
      ),
    );
  }
}
