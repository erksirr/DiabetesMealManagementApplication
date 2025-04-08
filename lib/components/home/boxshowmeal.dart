import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:diabetes_meal_management_application_project/apis/Api_daymeal.dart';
import 'package:diabetes_meal_management_application_project/components/confirmpopup.dart';

class Boxshowmeal extends StatefulWidget {
  final bool breakfast_check;
  final bool lunch_check;
  final bool dinner_check;
  final bool empty_breakfast_check;
  final bool empty_lunch_check;
  final bool empty_dinner_check;
  final DateTime effectiveDate;
  final String fruitBreakfastname;
  final String beverageBreakfastname;
  final String mainmealBreakfastname;
  final String fruitLunchname;
  final String beverageLunchname;
  final String mainmealLunchname;
  final String fruitDinnername;
  final String beverageDinnername;
  final String mainmealDinnername;
  final String breakfast_id;
  final String lunch_id;
  final String dinner_id;
  final String mealPlan;
  final Function onMealConfirmed;
  Boxshowmeal(
      {Key? key,
      required this.breakfast_check,
      required this.lunch_check,
      required this.dinner_check,
      required this.empty_breakfast_check,
      required this.effectiveDate,
      required this.mealPlan,
      required this.fruitBreakfastname,
      required this.beverageBreakfastname,
      required this.mainmealBreakfastname,
      required this.fruitLunchname,
      required this.beverageLunchname,
      required this.mainmealLunchname,
      required this.fruitDinnername,
      required this.beverageDinnername,
      required this.mainmealDinnername,
      required this.breakfast_id,
      required this.lunch_id,
      required this.dinner_id,
      required this.empty_lunch_check,
      required this.empty_dinner_check,
      required this.onMealConfirmed}) // เอา required ออก
      : super(key: key);

  @override
  State<Boxshowmeal> createState() => _BoxshowmealState();
}

class _BoxshowmealState extends State<Boxshowmeal> {
  DateTime selectedDate = DateTime.now();

  bool isToday() {
    final effectiveDate_forcheck = selectedDate.hour > 19
        ? selectedDate.add(Duration(days: 1))
        : selectedDate;
    return effectiveDate_forcheck == selectedDate;
  }

  void onEat(String mealType, String mealId) async {
    var checkeatResult =
        await DaymealService.checkEatMeal(mealType: mealType, mealId: mealId);
    // print("checkeatResult:${checkeatResult}");
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Confirmpopup(
          textHeader: "คุณทานอาหารนี้จริงใช่หรือไม่",
          textContent:
              "โปรดยืนยันความถูกต้องเพราะมีผลต่อการติดตามน้ำตาลของคุณโดยตรง",
          textAction: "ยืนยันการรับประทาน",
          onPressed: () async {
            widget.mealPlan == 'แผนอาหารมื้อเช้าของคุณ'
                ? onEat("breakfast", widget.breakfast_id)
                : widget.mealPlan == 'แผนอาหารมื้อกลางวันของคุณ'
                    ? onEat("lunch", widget.lunch_id)
                    : onEat("dinner", widget.dinner_id);
            // Call the callback after action is completed
            widget.onMealConfirmed();
            Navigator.pop(context, "toRecommendPage");
          },
        ); // เรียกใช้ dialog ยืนยัน
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // print("breakfast_check:${widget.breakfast_check}");
    // print("lunch_check:${widget.lunch_check}");
    // print("dinner_check:${widget.dinner_check}");
    return Container(
      width: 232,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              !isToday()
                  ? Row(
                      children: [
                        Text(
                          DateFormat('EEEE', 'th').format(widget.effectiveDate),
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromRGBO(123, 123, 123, 1),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          DateFormat('dd').format(widget.effectiveDate),
                          style: TextStyle(
                              fontSize: 16,
                              color: Color.fromRGBO(123, 123, 123, 1),
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          DateFormat('MMMM', 'th').format(
                              widget.effectiveDate), // แสดงเดือนเป็นภาษาไทย
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromRGBO(123, 123, 123, 1),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '${(int.parse(DateFormat('yyyy').format(widget.effectiveDate)) + 543)}', // แปลงเป็นปีไทย
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromRGBO(123, 123, 123, 1),
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    )
                  : SizedBox.shrink(),
              Row(
                children: [
                  widget.mealPlan != "แผนอาหารมื้อเช้าของวันถัดไป"
                      ? widget.mealPlan == "แผนอาหารมื้อเช้าของคุณ"
                          ? Container(
                              width: 19,
                              height: 19,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Color.fromRGBO(74, 178, 132, 1),
                                  width: 1,
                                ),
                                color: widget.breakfast_check
                                    ? Color.fromRGBO(74, 178, 132, 1)
                                    : Colors.transparent,
                              ),
                              child: widget.breakfast_check
                                  ? Icon(
                                      Icons.check,
                                      size: 16,
                                      color: Colors.white,
                                    )
                                  : null,
                            )
                          : widget.mealPlan == "แผนอาหารมื้อกลางวันของคุณ"
                              ? Container(
                                  width: 19,
                                  height: 19,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Color.fromRGBO(74, 178, 132, 1),
                                      width: 1,
                                    ),
                                    color: widget.lunch_check
                                        ? Color.fromRGBO(74, 178, 132, 1)
                                        : Colors.transparent,
                                  ),
                                  child: widget.lunch_check
                                      ? Icon(
                                          Icons.check,
                                          size: 16,
                                          color: Colors.white,
                                        )
                                      : null,
                                )
                              : Container(
                                  width: 19,
                                  height: 19,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Color.fromRGBO(74, 178, 132, 1),
                                      width: 1,
                                    ),
                                    color: widget.dinner_check
                                        ? Color.fromRGBO(74, 178, 132, 1)
                                        : Colors.transparent,
                                  ),
                                  child: widget.dinner_check
                                      ? Icon(
                                          Icons.check,
                                          size: 16,
                                          color: Colors.white,
                                        )
                                      : null,
                                )
                      : SizedBox.shrink(),
                  widget.mealPlan != "แผนอาหารมื้อเช้าของวันถัดไป"
                      ? SizedBox(width: 10)
                      : SizedBox.shrink(),
                  Text(widget.mealPlan,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(74, 178, 132, 1))),
                ],
              ),
              SizedBox(height: 7),
              widget.mealPlan == 'แผนอาหารมื้อเช้าของคุณ'
                  ? Text(
                      "อาหาร: ${widget.mainmealBreakfastname}",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    )
                  : widget.mealPlan == 'แผนอาหารมื้อกลางวันของคุณ'
                      ? Text(
                          "อาหาร: ${widget.mainmealLunchname}",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                        )
                      : widget.mealPlan == 'แผนอาหารมื้อเย็นของคุณ'
                          ? Text(
                              "อาหาร: ${widget.mainmealDinnername}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16),
                            )
                          : Text(
                              "อาหาร: ${widget.mainmealBreakfastname}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16),
                            ),
              SizedBox(height: 5),
              widget.mealPlan == 'แผนอาหารมื้อเช้าของคุณ'
                  ? Text(
                      "ผลไม้: ${widget.fruitBreakfastname}",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    )
                  : widget.mealPlan == 'แผนอาหารมื้อกลางวันของคุณ'
                      ? Text(
                          "ผลไม้: ${widget.fruitLunchname}",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                        )
                      : widget.mealPlan == 'แผนอาหารมื้อเย็นของคุณ'
                          ? Text(
                              "ผลไม้: ${widget.fruitDinnername}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16),
                            )
                          : Text(
                              "ผลไม้: ${widget.fruitBreakfastname}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16),
                            ),
              SizedBox(height: 5),
              widget.mealPlan == 'แผนอาหารมื้อเช้าของคุณ'
                  ? Text(
                      "เครื่องดื่ม: ${widget.beverageBreakfastname}",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    )
                  : widget.mealPlan == 'แผนอาหารมื้อกลางวันของคุณ'
                      ? Text(
                          "เครื่องดื่ม: ${widget.beverageLunchname}",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                        )
                      : widget.mealPlan == 'แผนอาหารมื้อเย็นของคุณ'
                          ? Text(
                              "เครื่องดื่ม: ${widget.beverageDinnername}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16),
                            )
                          : Text(
                              "เครื่องดื่ม: ${widget.beverageBreakfastname}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16),
                            ),
              SizedBox(height: 10),
            ],
          ),
          isToday()
              ? widget.mealPlan == 'แผนอาหารมื้อเช้าของคุณ'
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: widget.empty_breakfast_check
                                  ? Colors.grey
                                  : (widget.breakfast_check
                                      ? Colors.grey
                                      : Color.fromRGBO(255, 139, 89, 1)),
                              borderRadius: BorderRadius.circular(6)),
                          child: GestureDetector(
                            onTap: () {
                              if (widget.empty_breakfast_check) {
                                print("ไม่มีอาหารให้เลือก");
                              } else if (!widget.breakfast_check) {
                                _showConfirmationDialog(context);
                              } else {
                                print("ทานไปแล้ว");
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Text(
                                widget.empty_breakfast_check
                                    ? "ไม่มีอาหาร"
                                    : (widget.breakfast_check
                                        ? "ทานไปแล้ว"
                                        : "ทานมื้อนี้"),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : widget.mealPlan == 'แผนอาหารมื้อกลางวันของคุณ'
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: widget.empty_lunch_check
                                      ? Colors.grey
                                      : (widget.lunch_check
                                          ? Colors.grey
                                          : Color.fromRGBO(255, 139, 89, 1)),
                                  borderRadius: BorderRadius.circular(6)),
                              child: GestureDetector(
                                onTap: () {
                                  if (widget.empty_lunch_check) {
                                    print("ไม่มีอาหารให้เลือก");
                                  } else if (!widget.lunch_check) {
                                    _showConfirmationDialog(context);
                                  } else {
                                    print("ทานไปแล้ว");
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Text(
                                    widget.empty_lunch_check
                                        ? "ไม่มีอาหาร"
                                        : (widget.lunch_check
                                            ? "ทานไปแล้ว"
                                            : "ทานมื้อนี้"),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : widget.mealPlan == 'แผนอาหารมื้อเย็นของคุณ'
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: widget.empty_dinner_check
                                        ? Colors.grey
                                        : (widget.dinner_check
                                            ? Colors.grey
                                            : Color.fromRGBO(255, 139, 89, 1)),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (widget.empty_dinner_check) {
                                        print("ไม่มีอาหารให้เลือก");
                                      } else if (!widget.dinner_check) {
                                        _showConfirmationDialog(context);
                                      } else {
                                        print("ทานไปแล้ว");
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Text(
                                        widget.empty_dinner_check
                                            ? "ไม่มีอาหาร"
                                            : (widget.dinner_check
                                                ? "ทานไปแล้ว"
                                                : "ทานมื้อนี้"),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: widget.empty_breakfast_check
                                          ? Colors.grey
                                          : (widget.breakfast_check
                                              ? Colors.grey
                                              : Color.fromRGBO(
                                                  255, 139, 89, 1)),
                                      borderRadius: BorderRadius.circular(6)),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (widget.empty_breakfast_check) {
                                        print("ไม่มีอาหารให้เลือก");
                                      } else if (!widget.breakfast_check) {
                                        _showConfirmationDialog(context);
                                      } else {
                                        print("ทานไปแล้ว");
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Text(
                                        widget.empty_breakfast_check
                                            ? "ไม่มีอาหาร"
                                            : (widget.breakfast_check
                                                ? "ทานไปแล้ว"
                                                : "ทานมื้อนี้"),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
