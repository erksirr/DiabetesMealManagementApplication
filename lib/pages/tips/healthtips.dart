import 'package:flutter/material.dart';
import 'package:diabetes_meal_management_application_project/components/backbutton.dart';
import 'package:diabetes_meal_management_application_project/components/tips/youtube_player_widget.dart';

class HealthTipsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "การดูแลสุขภาพ",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        centerTitle: true,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: Backbutton(onPressed: () => Navigator.pop(context)),
      ),
      backgroundColor: const Color(0xFFF1F1F1),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHealthTips(),
              const SizedBox(height: 20),

              // Add YouTubePlayerWidget for the first video
              const YouTubePlayerWidget(
                videoUrl: 'https://www.youtube.com/embed/MrnB6PgWhtI',
                title: 'การดูแลผู้ป่วยโรคเบาหวาน',
                detail:
                    'โรคเบาหวานคือน้ำตาลในเลือดสูงจากการขาดหรือมีอินซูลินไม่พอ ต้องดูแลรักษาอย่างต่อเนื่อง.',
              ),
              const SizedBox(height: 20),

              // Add YouTubePlayerWidget for the second video
              const YouTubePlayerWidget(
                videoUrl: 'https://www.youtube.com/embed/n7_XkM4jQFQ',
                title: 'วิธีควบคุมระดับน้ำตาลในเลือด',
                detail:
                    'การควบคุมระดับน้ำตาลในเลือดสำคัญมากสำหรับผู้ป่วยเบาหวาน ควรหลีกเลี่ยงอาหารที่มีน้ำตาลสูงและหมั่นตรวจวัดระดับน้ำตาลอย่างสม่ำเสมอ.',
              ),
              const SizedBox(height: 20),

              _buildFootCareTips(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHealthTips() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              "วิธีดูแลตัวเอง...เมื่อเป็นเบาหวาน",
              style: TextStyle(
                color: Color(0xFF4AB284),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 10),
          _buildHealthTip(
            "ควบคุมอาหาร\nประเภทแป้งและของหวาน",
            "asset/im/foodhealth.png",
            isImageLeft: true,
          ),
          _buildHealthTip(
            "รับประทานยา\nและพบแพทย์ตามนัดหมาย",
            "asset/im/drughealth.png",
            isImageLeft: false,
          ),
          _buildHealthTip(
            "รักษาโรคอื่นๆ ที่พบร่วมด้วย",
            "asset/im/diseasehealth.png",
            isImageLeft: true,
          ),
          _buildHealthTip(
            "ควบคุมน้ำหนักออกกำลังกาย",
            "asset/im/weighthealth.png",
            isImageLeft: false,
          ),
          _buildHealthTip(
            "ไม่สูบบุหรี่และไม่ดื่มสุรา",
            "asset/im/smokehealth.png",
            isImageLeft: true,
          ),
          _buildHealthTip(
            "ดูแลสุขภาพเท้าให้ดี",
            "asset/im/foothealth.png",
            isImageLeft: false,
          ),
        ],
      ),
    );
  }

  Widget _buildFootCareTips() {
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
              "ผู้ป่วยเบาหวานควรดูแลเท้าอย่างไร",
              style: TextStyle(
                color: Color(0xFF4AB284),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Column(
            children: const [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.check_circle, color: Colors.orange),
                title: Text(
                  "ดูแลและรักษาความสะอาด",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.check_circle, color: Colors.orange),
                title: Text(
                  "ไม่เดินเท้าเปล่า และสวมถุงเท้าก่อนใส่รองเท้าเสมอ",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.check_circle, color: Colors.orange),
                title: Text(
                  "สำรวจเท้าอย่างละเอียดเป็นประจำ หากพบว่าเริ่มมีแผลมีตาปลา มีเล็บขบหรือการติดเชื้อรา ควรรีบมาพบแพทย์",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.check_circle, color: Colors.orange),
                title: Text(
                  "ตรวจเท้าอย่างละเอียดโดยแพทย์อย่างน้อยปีละ 1 ครั้ง",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHealthTip(String text, String imagePath,
      {required bool isImageLeft}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        decoration: BoxDecoration(
          color:
              isImageLeft ? Color.fromARGB(255, 233, 252, 243) : Colors.white,
          border: isImageLeft
              ? null
              : Border.all(color: Color.fromARGB(255, 179, 241, 212), width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: isImageLeft
              ? [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(imagePath),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      text,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]
              : [
                  Expanded(
                    child: Text(
                      text,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(imagePath),
                  ),
                ],
        ),
      ),
    );
  }
}
