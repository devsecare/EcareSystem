import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecaresystem/screens/employee/emp_range.dart';
import 'package:ecaresystem/services/database/database.dart';
import 'package:ecaresystem/widgets/tasklistcontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../constants.dart';

class EmpFilter extends StatefulWidget {
  final String name;
  const EmpFilter({Key? key, required this.name}) : super(key: key);

  @override
  _EmpFilterState createState() => _EmpFilterState();
}

class _EmpFilterState extends State<EmpFilter> {
  bool _loading = true;
  late QuerySnapshot data;
  List<QueryDocumentSnapshot> dd = List.empty(growable: true);
  late List<QueryDocumentSnapshot> week;
  late List<QueryDocumentSnapshot> month;
  late List<QueryDocumentSnapshot> year;
  late String total = "0";
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    data = await DataBase("").getEmployeequery(widget.name);
    dd = data.docs;
    if (dd.isNotEmpty) {
      List jj = [];
      List vv = [];
      for (var item in data.docs) {
        jj.add(int.parse(item.get("Hours")));
        vv.add(int.parse(item.get("minutes")));
      }

      int total1 = jj.reduce((value, element) => value + element);
      int totalmin = vv.reduce((value, element) => value + element);

      var dd1 = Duration(hours: total1, minutes: totalmin);
      total = dd1.toString().substring(0, 5);
    }

    setState(() {
      _loading = false;
    });
  }

  void displayDialog() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          height: 32.h,
          width: 80.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(
                  "Select data range",
                  style: GoogleFonts.manrope(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18.00),
                child: TextButton(
                    onPressed: () {
                      getByLastWeek();
                      Navigator.pop(context);
                      Get.to(() => EmpRange(
                            name: widget.name,
                            week: week,
                          ));
                    },
                    child: Text(
                      "Last Week",
                      style: GoogleFonts.manrope(
                        color: Colors.black,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18.00),
                child: TextButton(
                    onPressed: () {
                      getByLastMonth();
                      Navigator.pop(context);
                      Get.to(() => EmpRange(
                            name: widget.name,
                            week: month,
                          ));
                    },
                    child: Text(
                      "Last Month",
                      style: GoogleFonts.manrope(
                        color: Colors.black,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18.00),
                child: TextButton(
                    onPressed: () {
                      getByLastYears();
                      Navigator.pop(context);
                      Get.to(() => EmpRange(
                            name: widget.name,
                            week: year,
                          ));
                    },
                    child: Text(
                      "Last Year",
                      style: GoogleFonts.manrope(
                        color: Colors.black,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
              ),
              SizedBox(
                height: 1.h,
              ),
              Center(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: maincolor,
                        minimumSize: Size(68.w, 6.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(
                        "CLOSE",
                        style: GoogleFonts.manrope(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      )))
            ],
          ),
        ),
      ),
    );
  }

  getByLastWeek() async {
    var now = DateTime.now();
    var now_1w = now.subtract(const Duration(days: 7));
    week = dd.where((element) {
      final date = (element["CreatedAt"] as Timestamp).toDate();
      return now_1w.isBefore(date);
    }).toList();
  }

  getByLastMonth() async {
    var now = DateTime.now();

    var now_1m = DateTime(now.year, now.month - 1, 1);
    var now_1m1 = DateTime(now.year, now.month, 1);

    // var now_1m = now.subtract(const Duration(days: 30));

    var month1 = dd.where((element) {
      final date = (element["CreatedAt"] as Timestamp).toDate();

      return now_1m.isBefore(date);
    }).toList();

    month = month1.where((element) {
      final date = (element["CreatedAt"] as Timestamp).toDate();
      return now_1m1.isAfter(date);
    }).toList();
  }

  getByLastYears() async {
    var now = DateTime.now();

    var now_1y = DateTime(now.year - 1, now.month, now.day);
    year = dd.where((element) {
      final date = (element["CreatedAt"] as Timestamp).toDate();
      return now_1y.isAfter(date);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: maincolor,
        elevation: 0.0,
        title: Text(widget.name),
        actions: [
          GestureDetector(
            onTap: () {
              displayDialog();
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Image.asset(
                cal,
                scale: 2.8,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 18.0, right: 18.0),
        child: Container(
          width: double.infinity,
          height: 9.h,
          decoration: BoxDecoration(
            color: maincolor,
            borderRadius: BorderRadius.circular(15),
          ),
          // alignment: Alignment.center,

          child: _loading
              ? Container()
              : Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Total hours",
                            style: GoogleFonts.manrope(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          FittedBox(
                            child: Text(
                              "Worked by ${widget.name}",
                              style: GoogleFonts.manrope(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const VerticalDivider(
                        color: Colors.white70,
                        width: 18.0,
                        thickness: 1.0,
                      ),
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: total.toString(),
                            style: GoogleFonts.manrope(
                              fontSize: 22.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          WidgetSpan(
                            child: Transform.translate(
                              offset: const Offset(2, -11),
                              child: Text(
                                'hrs',
                                //superscript is usually smaller in size
                                textScaleFactor: 0.7,
                                style: GoogleFonts.manrope(
                                  fontSize: 18.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        ]),
                      ),
                    ],
                  ),
                ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Stack(
        children: [
          Container(
            height: 10.h,
            decoration: const BoxDecoration(
              color: maincolor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(45.0),
                bottomRight: Radius.circular(45.0),
              ),
            ),
          ),
          _loading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: maincolor,
                  ),
                )
              : ListView.builder(
                  itemCount: dd.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TaskListContainer(
                        title: dd[index]["Taskname"],
                        hours: dd[index]['Hours'],
                        mini: dd[index]["minutes"],
                        comment: dd[index]['Date'],
                      ),
                    );
                  }),
        ],
      ),
    );
  }
}
