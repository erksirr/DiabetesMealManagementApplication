import 'package:flutter/material.dart';
import 'package:diabetes_meal_management_application_project/components/backbutton.dart';

class ControlTipsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "การควบคุมอาหาร",
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
            // Navigator.pushReplacementNamed(
            //     context, '/filldisease'); // ✅ กลับไปหน้า filldisease
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
              Container(
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
                        "จุดมุ่งหมายในการควบคุมอาหาร",
                        style: TextStyle(
                          color: Color(0xFF4AB284),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        _buildCheckItem(
                            "ควบคุมระดับน้ำตาลและไขมันให้ใกล้เคียงปกติ"),
                        _buildCheckItem("รักษาน้ำหนักให้เหมาะสม"),
                        _buildCheckItem(
                            "เลือกกินอาหารที่มีประโยชน์ในปริมาณที่พอดี"),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Container ใหม่ (ตามรูปที่แนบมา)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "        การควบคุมอาหาร",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF4AB284), // สีเขียว
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text:
                                " คือการเลือกรับประทานอาหารให้ครบหมู่และเหมาะสมกับร่างกาย เพื่อป้องกันและลดโรคแทรกซ้อน",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Image.asset(
                        'asset/im/control.png',
                        width: 250,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDietTip(
                      "อาหารประเภทข้าว/แป้ง",
                      "หากจะทานข้าวเหนียวแทนข้าวเจ้า\nต้องลดปริมาณลงครึ่งนึง\nข้าวเจ้า 1 ทัพพี = ข้าวเหนียวครึ่งทัพพี",
                      "asset/im/foodhealth.png",
                      Color(0xFFFFF7E6),
                    ),
                    const SizedBox(height: 10),
                    _buildDietTip(
                      "อาหารหวานต่างๆ",
                      "หลีกเลี่ยงผลไม้หวานจัด เช่น มะม่วงสุก มังคุด ลำไย ทุเรียน ละมุด ขนุน องุ่น น้อยหน่า เป็นต้น",
                      "asset/im/sweets.png",
                      Colors.white,
                    ),
                    const SizedBox(height: 10),
                    _buildDietTip(
                      "อาหารกระป๋อง",
                      "อาหารสำเร็จรูป อาหารหมักดอง \nผงชูรส อาหารเค็มจัด",
                      "asset/im/can.png",
                      Color(0xFFFFF7E6),
                    ),
                    const SizedBox(height: 10),
                    _buildDietTip(
                      "เนื้อสัตว์ติดมัน",
                      "ทานได้พอควร เลือกใช้เนื้อสัตว์ที่ไขมันต่ำ เช่น ปลา อกไก่ เนื้อหมูไม่ติดมัน เป็นต้น",
                      "asset/im/pork.png",
                      Colors.white,
                    ),
                    const SizedBox(height: 10),
                    _buildDietTip(
                      "ไขมัน",
                      "น้ำมันที่เหมาะสมในการปรุงอาหาร ได้แก่ น้ำมันถั่วเหลือง น้ำมันรำข้าว\nไม่ควรใช้น้ำมันปาล์มหรือกะทิ",
                      "asset/im/oil.png",
                      Color(0xFFFFF7E6),
                    ),
                    const SizedBox(height: 10),
                    _buildDietTip(
                      "การดื่มเหล้า",
                      "รวมไปถึงเบียร์และเครื่องดื่มที่มีแอลกอฮอล์ชนิดอื่นๆ",
                      "asset/im/alcohol.png",
                      Colors.white,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
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
                        "ประโยชน์ของการควบคุมอาหาร",
                        style: TextStyle(
                          color: Color(0xFF4AB284),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        _buildCheckItem(
                            "ช่วยรักษาระดับน้ำตาลและไขมันในเลือดให้ใกล้เคียงระดับปกติ"),
                        _buildCheckItem("ทำให้น้ำหนักตัวอยู่ในเกณฑ์ที่ควรเป็น"),
                        _buildCheckItem("ช่วยป้องกันโรคแทรกซ้อนต่างๆ"),
                        _buildCheckItem("ทำให้สุขภาพแข็งแรงและอายุยืน"),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ฟังก์ชันสร้างรายการพร้อมไอคอนอยู่ด้านหน้า
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

  // ฟังก์ชันสร้างการ์ดสำหรับอาหารที่ต้องลด
  Widget _buildDietTip(String title, String description, String imagePath,
      Color backgroundColor) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFFFFD07A), width: 2),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // หัวข้อชิดซ้าย
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start, // หัวข้อชิดซ้าย
                  children: [
                    Text(
                      "ลด",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Color(0xFFFF8B59), // สีพื้นหลังของหัวข้อ
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // ตัวหนังสือสีขาว
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Center(
                  child: Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center, // ข้อความย่อยกึ่งกลาง
                  ),
                ),
              ],
            ),
          ),

          // รูปภาพอาหาร
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imagePath,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
