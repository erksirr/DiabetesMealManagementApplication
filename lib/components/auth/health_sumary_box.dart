import 'package:flutter/material.dart';

class HealthSummaryBox extends StatelessWidget {
  final List<String> diseases;
  final List<String> allergies;
  final String exercise;

  const HealthSummaryBox({
    Key? key,
    required this.diseases,
    required this.allergies,
    required this.exercise,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFECFFF7),
        border: Border.all(color: Color(0xFF65A9C8)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummarySection("โรคประจำตัว", diseases),
          SizedBox(height: 12),
          _buildSummarySection("การแพ้อาหาร", allergies),
          SizedBox(height: 12),
          _buildSummarySection("การออกกำลังกาย", [exercise]),
        ],
      ),
    );
  }

  Widget _buildSummarySection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 10),
          child: Text(
            items.isNotEmpty ? items.join(', ') : "-",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
