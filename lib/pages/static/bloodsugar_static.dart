import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:diabetes_meal_management_application_project/APIs/Api_bloodsugar.dart';
import 'package:diabetes_meal_management_application_project/components/home/bloodsugarlevel.dart';
import 'package:diabetes_meal_management_application_project/components/static/bloodsugarcard.dart';
import 'package:diabetes_meal_management_application_project/components/static/bloodsugartimestamp.dart';
import 'package:intl/intl.dart';

import 'package:get/get.dart';
import 'package:diabetes_meal_management_application_project/controllers/blood_sugar_controller.dart';

import 'package:diabetes_meal_management_application_project/controllers/connection_controller.dart';

class BloodsugarStaticPage extends StatefulWidget {
  const BloodsugarStaticPage({super.key});

  @override
  State<BloodsugarStaticPage> createState() => _BloodsugarStaticPageState();
}

class _BloodsugarStaticPageState extends State<BloodsugarStaticPage> {
  final ConnectionController connectionController =
      Get.find<ConnectionController>();
  DateTime selectedDate =  DateTime.now().add(Duration(days: 0));
  List bloodSugarData = [];
  List<FlSpot> graphData = [];
  int maxBloodSugar = 0;
  int minBloodSugar = 0;
  int avgBloodSugar = 0;
  Map<String, double>?
      selectedPeriod; // Holds the start and end times of the selected period
  bool isLoading = true; // Add this variable
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void fetchData() async {
    setState(() {
      isLoading = true; // Set loading to true before fetching data
    });
    await Future.wait([
      fetchBloodSugarStats(),
      fetchBloodSugarPeriod(),
      fetchBloodSugarGraph(),
    ]);
    if (mounted) {
      setState(() {
        isLoading = false; // Set loading to false after data is fetched
      });
    }
  }

  Future<void> fetchBloodSugarStats() async {
    String date = DateFormat('yyyy-MM-dd').format(selectedDate);
    var stats = await BloodsugarService.getDailyBloodsugarStats(date);
    print("📊 Blood Sugar Stats: $stats");

    if (stats.isNotEmpty && mounted) {
      setState(() {
        maxBloodSugar = stats[0]["maxBloodSugar"]?.toInt() ?? 0;
        minBloodSugar = stats[0]["minBloodSugar"]?.toInt() ?? 0;
        avgBloodSugar = stats[0]["averageBloodSugar"]?.toInt() ?? 0;
      });
    }
  }

  Future<void> fetchBloodSugarGraph() async {
    String date = DateFormat('yyyy-MM-dd').format(selectedDate);
    var graphResponse = await BloodsugarService.getDailyBloodsugarGraph(date);

    print("📈 Blood Sugar Graph Data Received: $graphResponse");

    if (graphResponse.isNotEmpty && mounted) {
      setState(() {
        graphData = graphResponse.map<FlSpot>((data) {
          try {
            double time = data["hour"] + (data["minute"] / 60.0);
            double glucose =
                double.tryParse(data["blood_sugar_level"].toString()) ?? 0;

            print("🔹 Adding Data to Graph: Time: $time, Glucose: $glucose");

            return FlSpot(time, glucose);
          } catch (e) {
            print("❌ Error Parsing Data: $e");
            return const FlSpot(0, 0);
          }
        }).toList();

        if (graphData.isEmpty) {
          graphData.add(const FlSpot(0, 0));
        }
      });
    }
  }

  Future<void> fetchBloodSugarPeriod() async {
    String date = DateFormat('yyyy-MM-dd').format(selectedDate);
    var periodData = await BloodsugarService.getDailyBloodsugarPeriod(date);
    print("⏳ Blood Sugar Period Data: $periodData");

    List<Map<String, dynamic>> tempData = [];

    if (periodData.isNotEmpty) {
      for (var data in periodData) {
        tempData.add({
          'time': data['time'], // Already formatted from backend
          'glucoseRange': data['range'] ?? '--'
        });
      }
    }

    if (mounted) {
      setState(() {
        bloodSugarData = tempData;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.orange, // Header background color
            colorScheme: ColorScheme.light(
              primary: Colors.orange, // Selected date color
              onPrimary: Colors.white, // Text color for selected date
              onSurface: Colors.black, // Default text color
            ),
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary, // Button text color
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
      fetchData();
    }
  }

  void _changeDate(int days) {
    setState(() {
      selectedDate = selectedDate.add(Duration(days: days));
      fetchData();
    });
  }

  double getMinX() {
    if (graphData.isEmpty) return 0;

    double firstX = graphData.first.x.floorToDouble();

    // bool isToday = selectedDate.year == DateTime.now().year &&
    //     selectedDate.month == DateTime.now().month &&
    //     selectedDate.day == DateTime.now().day;

    // return isToday ? firstX - 0.5 : firstX;
    return firstX;
  }

  double getMaxX() {
    if (graphData.isEmpty) return 24;

    double lastX = graphData.last.x.ceilToDouble();

    return lastX;
  }

  void onPeriodTap(double startTime, double endTime) {
    setState(() {
      // Toggle selection: if the same period is tapped, deselect it
      if (selectedPeriod != null &&
          selectedPeriod!['start'] == startTime &&
          selectedPeriod!['end'] == endTime) {
        selectedPeriod = null; // Deselect
      } else {
        selectedPeriod = {
          'start': startTime,
          'end': endTime
        }; // Select the tapped period
      }
    });
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        "${selectedDate.day} ${DateFormat('MMMM', 'th').format(selectedDate)} ${selectedDate.year + 543}";

    if (isLoading) {
      // Show a loading indicator while data is being fetched
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (graphData.isEmpty) {
      return Center(
        child: Text(
          "*กรุณาเชื่อมต่ออุปกรณ์เพื่อดูกราฟ*",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      controller: _scrollController,
      child: Container(
        color: Color.fromRGBO(242, 242, 242, 1.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  children: [
                    Obx(() {
                      var blood = Get.find<BloodSugarController>();
                      var controller = Get.find<ConnectionController>();
                      return BloodSugarLevel(
                          bloodSugarLevel:
                              (controller.isConnected.value == false)
                                  ? "--"
                                  : blood.bloodSugar.value.toString(),
                          timestamp: (controller.isConnected.value == false)
                              ? "--"
                              : blood.bloodSugarTimestamp.value);
                    }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(width: 2.0, color: Colors.black),
                            ),
                            padding: EdgeInsets.only(left: 5),
                            child: Icon(Icons.arrow_back_ios,
                                color: Colors.black, size: 10),
                          ),
                          onPressed: () => _changeDate(-1),
                        ),
                        Text(
                          formattedDate, // ใช้ค่าที่แก้ไขแล้ว
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        RotatedBox(
                          quarterTurns: 2,
                          child: IconButton(
                            icon: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(width: 2.0, color: Colors.black),
                              ),
                              padding: EdgeInsets.only(left: 5),
                              child: Icon(Icons.arrow_back_ios,
                                  color: Colors.black, size: 10),
                            ),
                            onPressed: () => _changeDate(1),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.calendar_month, color: Colors.black),
                          onPressed: () => _selectDate(context),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: connectionController.isConnected.value
                                  ? Color.fromRGBO(74, 178, 132, 1)
                                  : Color.fromRGBO(218, 22, 22, 1),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            connectionController.isConnected.value
                                ? "เชื่อมต่ออุปกรณ์อยู่"
                                : "ยังไม่ได้เชื่อมต่ออุปกรณ์",
                            style: TextStyle(
                                color: connectionController.isConnected.value
                                    ? Color.fromRGBO(74, 178, 132, 1)
                                    : Color.fromRGBO(218, 22, 22, 1),
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      height: 170,
                      child: LineChart(
                        LineChartData(
                          minY: ((minBloodSugar > 20) && (minBloodSugar != 0)
                                  ? minBloodSugar - 20
                                  : 0)
                              .toDouble(),
                          maxY: (maxBloodSugar + 20).toDouble(),
                          minX: getMinX(),
                          maxX: getMaxX(),
                          lineBarsData: [
                            LineChartBarData(
                              spots: graphData,
                              color: Colors.cyan,
                              isCurved: true,
                              barWidth: 2,
                              isStrokeCapRound: true,
                              dotData: FlDotData(show: false),
                              belowBarData: BarAreaData(show: false),
                            ),
                            if (selectedPeriod != null)
                              LineChartBarData(
                                spots: [
                                  FlSpot(selectedPeriod!['start']!, 0),
                                  FlSpot(selectedPeriod!['start']!,
                                      maxBloodSugar.toDouble() + 20),
                                  FlSpot(selectedPeriod!['end']!,
                                      maxBloodSugar.toDouble() + 20),
                                  FlSpot(selectedPeriod!['end']!, 0),
                                ],
                                isCurved: false,
                                barWidth: 0,
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: Colors.blue.withOpacity(
                                      0.4), // Darker color for selected period
                                ),
                                dotData: FlDotData(
                                  show: false,
                                  getDotPainter:
                                      (spot, percent, barData, index) =>
                                          FlDotCirclePainter(
                                    radius: 4,
                                    color: Colors.blue,
                                    strokeWidth: 2,
                                    strokeColor: Colors.white,
                                  ),
                                ),
                              ),
                            if (selectedDate.year == DateTime.now().year &&
                                selectedDate.month == DateTime.now().month &&
                                selectedDate.day ==
                                    DateTime.now()
                                        .day) // ✅ Check if the date is today
                              LineChartBarData(
                                spots: [
                                  FlSpot(graphData.last.x,
                                      graphData.last.y), // ✅ Last point
                                ],
                                color: Colors
                                    .red, // ✅ Red color for last data point
                                isCurved: false,
                                barWidth: 0, // ✅ Hide the line
                                dotData: FlDotData(
                                  show: true,
                                  getDotPainter:
                                      (spot, percent, barData, index) =>
                                          FlDotCirclePainter(
                                    radius: 4, // ✅ Size of the red dot
                                    color: Colors.red,
                                    strokeWidth: 2,
                                    strokeColor: Colors
                                        .white, // ✅ White border to highlight it
                                  ),
                                ),
                              ),
                          ],
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: true,
                            horizontalInterval: 1,
                            checkToShowHorizontalLine: (value) =>
                                [70, 100, 125].contains(value.toInt()),
                            checkToShowVerticalLine: (value) =>
                                value % 6 == 0, // ✅ Vertical every 3 hours
                          ),
                          titlesData: FlTitlesData(
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(
                                  showTitles: false), // ✅ Hides top labels
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(
                                  showTitles: false), // ✅ Hides right labels
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 6,
                                getTitlesWidget: (value, meta) {
                                  switch (value.toInt()) {
                                    case 6:
                                    case 12:
                                    case 18:
                                      return Text("${value.toInt()}:00",
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold));
                                    default:
                                      return SizedBox();
                                  }
                                },
                                reservedSize: 20,
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 25, // ตรวจสอบค่าทุกค่า
                                getTitlesWidget: (value, meta) {
                                  if (value == meta.min || value == meta.max) {
                                    return SizedBox
                                        .shrink(); // Hide the edge values
                                  }
                                  return Text(
                                    "${value.toInt()}",
                                    style: TextStyle(
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold),
                                  );
                                },
                              ),
                            ),
                          ),
                          clipData: FlClipData.all(),
                          borderData: FlBorderData(show: true),
                          lineTouchData: LineTouchData(
                            touchTooltipData: LineTouchTooltipData(
                              tooltipPadding: EdgeInsets.all(
                                  8), // ✅ Adds padding to the tooltip
                              tooltipRoundedRadius:
                                  8, // ✅ Makes the tooltip rounded
                              fitInsideHorizontally:
                                  true, // ✅ Prevents clipping at the edges
                              fitInsideVertically: true,
                              getTooltipItems:
                                  (List<LineBarSpot> touchedSpots) {
                                return touchedSpots.map((spot) {
                                  int hour = spot.x.toInt();
                                  int minutes = ((spot.x - hour) * 60).toInt();

                                  String formattedTime =
                                      "${hour.toString().padLeft(2, '0')}.${minutes.toString().padLeft(2, '0')}";

                                  return LineTooltipItem(
                                    "🩸 ${spot.y.toInt()} mg/dL\n⏰ $formattedTime",
                                    TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }).toList();
                              },
                            ),
                            handleBuiltInTouches:
                                true, // ✅ Enables built-in interactions
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Bloodsugarcard(
                      text: "ค่าระดับน้ำตาลสูงสุด",
                      num: maxBloodSugar,
                      color: Color.fromRGBO(255, 139, 89, 1)),
                  Bloodsugarcard(
                      text: "ค่าระดับน้ำตาลเฉลี่ย",
                      num: avgBloodSugar,
                      color: Color.fromRGBO(101, 169, 200, 1)),
                  Bloodsugarcard(
                      text: "ค่าระดับน้ำตาลต่ำสุด",
                      num: minBloodSugar,
                      color: Color.fromRGBO(74, 178, 132, 1))
                ],
              ),
            ),
            maxBloodSugar >= 180
                ? Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 20.0),
                    child: Text(
                      "น้ำตาลของคุณสูงเกินไป",
                      style: TextStyle(
                          fontSize: 11, color: Color.fromRGBO(255, 0, 0, 1)),
                    ),
                  )
                : SizedBox.shrink(),
            SizedBox(height: 12),
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("เวลา",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(113, 113, 113, 1))),
                    Text("ต่ำสุด-สูงสุด",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(113, 113, 113, 1)))
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.white,
              child: Divider(
                color: Color.fromRGBO(231, 230, 230, 1),
                indent: 16,
                endIndent: 16,
              ),
            ),
            Container(
  color: Colors.white,
  child: Column(
    children: [
      Column(
        children: bloodSugarData.map((data) {
          // ตรวจสอบว่า data['time'] เป็น String และแยกเวลาออกเป็น List
          String timeRange = data['time'];
          List<String> times = timeRange.split('-').map((t) => t.trim()).toList();

          // แปลงรูปแบบเวลาให้เป็น "06.00" แทน "6:00"
          String formatTime(String time) {
            List<String> parts = time.split(':');
            String hour = parts[0].padLeft(2, '0'); // เติมเลข 0 ข้างหน้า ถ้าเป็นตัวเลขหลักเดียว
            String minute = parts[1].padLeft(2, '0'); // เติมเลข 0 ข้างหน้า (กรณีที่เป็น "6:0" → "6:00")
            return "$hour.$minute";
          }
print(formatTime(times[0]));
          String startTimeFormatted = "${formatTime(times[0])}น."; // มีช่องว่างหลัง "น."
          String endTimeFormatted = "${formatTime(times[1])}น."; // ไม่มีช่องว่างหลัง "น."

          // รวมช่วงเวลาตามรูปแบบที่ต้องการ
          String formattedTime = "$startTimeFormatted-$endTimeFormatted";

          double startTime = _parseTimeToDouble(times[0]);
          double endTime = _parseTimeToDouble(times[1]);

          bool isSelected = selectedPeriod != null &&
              selectedPeriod!['start'] == startTime &&
              selectedPeriod!['end'] == endTime;

          return GestureDetector(
            onTap: () {
              onPeriodTap(startTime, endTime);
              _scrollToTop(); // เลื่อนหน้าไปด้านบน
            },
            child: Container(
              color: isSelected
                  ? Colors.blue.withOpacity(0.2)
                  : Colors.transparent,
              child: Bloodsugartimestamp(
                time: formattedTime, // ใช้ค่าที่เพิ่ม "น." แล้ว
                glucoseRange: data['glucoseRange']!,
              ),
            ),
          );
        }).toList(),
      ),
    ],
  ),
)




          ],
        ),
      ),
    );
  }
}

double _parseTimeToDouble(String time) {
  List<String> parts = time.split(':');
  int hours = int.parse(parts[0]);
  int minutes = int.parse(parts[1]);
  return hours + (minutes / 60.0);
}
