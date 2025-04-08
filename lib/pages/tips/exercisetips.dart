import 'package:flutter/material.dart';
import 'package:diabetes_meal_management_application_project/components/backbutton.dart';
import 'package:diabetes_meal_management_application_project/components/tips/youtube_player_widget.dart';

class ExerciseTipsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "การออกกำลังกาย",
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
            children: [
              _buildExerciseSafety(),
              const SizedBox(height: 20),

              // Add YouTubePlayerWidget for the first video
              const YouTubePlayerWidget(
                videoUrl: 'https://www.youtube.com/embed/WV8Ts-YcF2M',
                title: 'ท่าออกกำลังกายในกลุ่มผู้ป่วยเบาหวาน',
                detail:
                    'พฤติกรรมการกินและใช้ชีวิตเสี่ยงก่อโรคเบาหวาน ความดัน ไขมันในเลือดสูง ควรดูแลสุขภาพด้วยการควบคุมอาหาร พักผ่อนให้เพียงพอและออกกำลังกายสม่ำเสมอ.',
              ),
              const SizedBox(height: 20),

              // Add YouTubePlayerWidget for the second video
              const YouTubePlayerWidget(
                videoUrl: 'https://www.youtube.com/embed/GHgKOVbNrMA',
                title: 'ผู้ป่วยเบาหวานอันตรายถึงตาย ถ้าออกกำลังกายโดยไม่รู้ 4 สิ่งนี้',
                detail: '',
              ),
              const SizedBox(height: 20),

              _buildExerciseTips(),
              const SizedBox(height: 20),

              _buildExerciseBenefits(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseSafety() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Center(
            child: Text(
              "การออกกำลังกายโดยไม่เสี่ยงอันตราย",
              style: TextStyle(
                color: Color(0xFF4AB284),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          SizedBox(height: 10),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.directions_walk, color: Colors.orange),
            title: Text("เดินเร็ว วิ่งเบา ว่ายน้ำ หรือปั่นจักรยาน", style: TextStyle(fontSize: 16)),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.fitness_center, color: Colors.orange),
            title: Text("เพิ่มกล้ามเนื้อด้วยยกน้ำหนัก วิดพื้น ชิทอัพ", style: TextStyle(fontSize: 16)),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.warning, color: Colors.orange),
            title: Text("ยืดกล้ามเนื้อป้องกันการบาดเจ็บ", style: TextStyle(fontSize: 16)),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.schedule, color: Colors.orange),
            title: Text("ออกกำลังกาย 4-5 ครั้ง/สัปดาห์ ครั้งละ 20-45 นาที", style: TextStyle(fontSize: 16)),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.medical_services, color: Colors.orange),
            title: Text("ผู้ป่วยเบาหวานควรปรึกษาแพทย์ก่อนออกกำลังกาย", style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseTips() {
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
              "การออกกำลังกายโดยไม่เสี่ยงอันตราย",
              style: TextStyle(
                color: Color(0xFF4AB284),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Column(
            children: [
              _buildCheckItem("เลือกสถานที่ออกกำลังกายที่อากาศปลอดโปร่ง"),
              _buildCheckItem("เลือกรูปแบบการออกกำลังกายที่เหมาะสมกับสภาพร่างกาย"),
              _buildCheckItem("ระวังการเกิดแผล ใส่ถุงเท้าและรองเท้าที่เหมาะสม"),
              const SizedBox(height: 10),
              Center(
                child: Image.asset(
                  'asset/im/exer.png',
                  width: 250,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseBenefits() {
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
              "ผลดีต่อผู้ป่วยเบาหวานเมื่อออกกำลังกาย",
              style: TextStyle(
                color: Color(0xFF4AB284),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Column(
            children: [
              _buildCheckItem("ลดระดับน้ำตาลในเลือดและระดับน้ำตาลสะสม"),
              _buildCheckItem("เพิ่มความแข็งแรงของระบบหัวใจหลอดเลือดและกล้ามเนื้อหัวใจ"),
              _buildCheckItem("ช่วยให้ระบบไหลเวียนเลือดดี"),
              _buildCheckItem("ลดความเสี่ยงการเกิดภาวะแทรกซ้อน เช่น โรคหลอดเลือดหัวใจและสมอง"),
              _buildCheckItem("ลดระดับไขมันและความดันโลหิต"),
              _buildCheckItem("ลดปริมาณไขมันในช่องท้องและใต้ผิวหนัง"),
              _buildCheckItem("เพิ่มความแข็งแรงของกล้ามเนื้อ"),
              _buildCheckItem("ช่วยควบคุมน้ำหนัก และลดน้ำหนัก"),
              _buildCheckItem("ลดความเครียด"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Colors.orange),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
