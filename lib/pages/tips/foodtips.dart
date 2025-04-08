import 'package:flutter/material.dart';
import 'package:diabetes_meal_management_application_project/components/backbutton.dart';
import 'package:diabetes_meal_management_application_project/components/tips/youtube_player_widget.dart';

class FoodTipsPage extends StatelessWidget {
  final List<Map<String, String>> riceTypes = [
    {
      "image": "asset/im/rice1.png",
      "name": "ข้าวกล้อง",
      "description":
          "มีสารกามาที่มีส่วนสำคัญต่อระบบประสาท ระบบเผาผลาญและสารแอนตี้ออกซิแดนท์ มีส่วนช่วยป้องกันมะเร็ง ป้องกันความจำเสื่อม บำรุงโลหิต บำรุงหัวใจ ชะลอความแก่ชราได้"
    },
    {
      "image": "asset/im/rice2.png",
      "name": "ข้าวไรซ์เบอร์รี่",
      "description":
          "เป็นข้าวที่มีสารต้านอนุมูลอิสระ สารอาหารและแร่ธาตุสูง มีน้ำตาลน้อยและแคลอรี่ต่ำ ช่วยลดเสี่ยงโรคเบาหวาน หัวใจ ความดันโลหิต"
    },
    {
      "image": "asset/im/rice3.png",
      "name": "ข้าวสังข์หยด",
      "description":
          "มีสารกามาที่มีส่วนสำคัญต่อระบบประสาท ระบบเผาผลาญและสารแอนตี้ออกซิแดนท์ มีส่วนช่วยป้องกันมะเร็ง ป้องกันความจำเสื่อม บำรุงโลหิต บำรุงหัวใจ ชะลอความแก่ชราได้"
    },
    {
      "image": "asset/im/rice4.png",
      "name": "ข้าวกข.43",
      "description":
          "มีดัชนีน้ำตาลต่ำ เหมาะกับผู้ที่เป็นโรคเบาหวานและคนรักสุขภาพแต่ยังติดกินข้าวขาว ช่วยซ่อมแซมความเสียหายในระบบย่อย บรรเทาอาการท้องเสีย"
    },
    {
      "image": "asset/im/rice5.png",
      "name": "ข้าวหอมนิล",
      "description":
          "มีสารต้านอนุมูลอิสระ มีคุณสมบัติช่วยป้องกันโรคหัวใจ บำรุงสายตา ขับสารพิษในตับ ป้องกันเบาหวาน และโรคเรื้อรัง"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "อาหารสำหรับผู้ป่วยเบาหวาน",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        centerTitle: true,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: Backbutton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: const Color(0xFFF1F1F1),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFoodAdvice(),
              const SizedBox(height: 20),
              // Add the first YouTube video
              const YouTubePlayerWidget(
                videoUrl: 'https://www.youtube.com/embed/n3MOprH-CYY?si=ygJUuODbDEAaHtE1',
                title: 'อาหารสำหรับผู้ป่วยเบาหวาน',
                detail: 'โรคเบาหวานคือภาวะที่ร่างกายควบคุมระดับน้ำตาลในเลือดได้ยาก '
                    '“Diabetic Diet” เน้นอาหารสุขภาพรสไม่หวานจัด ควบคุมปริมาณและชนิดของข้าว แป้ง และไขมัน '
                    'เพื่อช่วยควบคุมระดับน้ำตาลและไขมันในเลือด.',
              ),
              const SizedBox(height: 20),
              // Add another YouTube video
              _buildRiceTypeContainer(context),
              const SizedBox(height: 20),
              _buildFruit(),
              const SizedBox(height: 20),
              const YouTubePlayerWidget(
                videoUrl: 'https://www.youtube.com/embed/Ux7SgMZeWFU',
                title: 'ผลไม้ควรกิน ควรเลี่ยง ในผู้ป่วยเบาหวาน',
                detail: '',
              ),
              const SizedBox(height: 20),
              _buildSweets(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFoodAdvice() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              "คำแนะนำการทานอาหาร",
              style: TextStyle(
                color: Color(0xFF4AB284),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text:
                      "ผู้ป่วยเบาหวานควรกินอาหารที่มีไฟเบอร์สูง เช่น ผัก ธัญพืช และโปรตีนไม่ติดมัน ",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                TextSpan(
                  text: "หลีกเลี่ยง",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.red
                  ),
                ),
                TextSpan(
                  text:
                      " อาหารที่มีน้ำตาลสูงหรือแป้งขัดสี และกินในปริมาณที่เหมาะสมในแต่ละมื้อเพื่อควบคุมน้ำตาลในเลือด",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiceTypeContainer(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "ชนิดของข้าว",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              decoration: TextDecoration.underline,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: riceTypes.length,
              itemBuilder: (context, index) {
                return _buildRiceCard(context, riceTypes[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiceCard(BuildContext context, Map<String, String> rice) {
    return GestureDetector(
      onTap: () => _showImageOverlay(context, rice["image"]!, rice["name"]!, rice["description"]!),
      child: Container(
        width: 150,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFCBCBCB), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          children: [
            Expanded(
              child: Image.asset(
                rice["image"]!,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Text(
                rice["name"]!,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFruit() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "ผลไม้",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "แนะนำผลไม้ที่มีค่า GI ≤ 55 ได้แก่ แอปเปิล สตรอว์เบอร์รี ฝรั่ง เชอร์รี และส้ม ควรกินในปริมาณที่เหมาะสมและเลือกผลไม้สดแทนผลไม้แปรรูปเพื่อควบคุมน้ำตาลในเลือด",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          ClipOval(
            child: Image.asset(
              'asset/im/fruit.png',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSweets() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              "ผู้ป่วยเบาหวานสามารถทาน\nน้ำหวานหรือขนมหวานได้หรือไม่",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4AB284),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          const Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text:
                      "น้ำหวาน ลูกอมชนิดต่างๆ มีน้ำเป็นส่วนประกอบหลัก ไม่มีสารอาหารที่เป็นประโยชน์อื่นๆ จึงไม่เหมาะกับผู้ป่วยเบาหวาน เพราะจะทำให้ระดับน้ำตาลในเลือดสูงขึ้นรวดเร็ว ยกเว้นเมื่อผู้ป่วยมีอาการน้ำตาลในเลือดต่ำ ",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                TextSpan(
                  text: "ควรงด",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                      decorationColor: Colors.red
                  ),
                ),
                TextSpan(
                  text: " ขนมหวานจัด",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Image.asset(
              'asset/im/sweetsfood.png',
              width: 250,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  void _showImageOverlay(BuildContext context, String imagePath, String title, String description) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Center(
              child: Container(
                width: 323,
                height: 410,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.black, size: 24),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Image.asset(
                      imagePath,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}