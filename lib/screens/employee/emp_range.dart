import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecaresystem/constants.dart';
import 'package:ecaresystem/widgets/tasklistcontainer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class EmpRange extends StatefulWidget {
  final String name;
  final List<QueryDocumentSnapshot> week;
  const EmpRange({Key? key, required this.name, required this.week})
      : super(key: key);

  @override
  _EmpRangeState createState() => _EmpRangeState();
}

class _EmpRangeState extends State<EmpRange> {
  late String total = "0";
  bool _loading = true;
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    List jj = [];
    List vv = [];
    for (var item in widget.week) {
      jj.add(int.parse(item.get("Hours")));
      vv.add(int.parse(item.get("minutes")));
    }
    if (jj.isNotEmpty && vv.isNotEmpty) {
      int total1 = jj.reduce((value, element) => value + element);
      int totalmin = vv.reduce((value, element) => value + element);

      var dd1 = Duration(hours: total1, minutes: totalmin);
      total = dd1.toString().substring(0, 5);
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: maincolor,
        elevation: 0.0,
        title: Text(widget.name),
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
                  itemCount: widget.week.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TaskListContainer(
                        title: widget.week[index]["Taskname"],
                        hours: widget.week[index]['Hours'],
                        mini: widget.week[index]["minutes"],
                        comment: widget.week[index]['Date'],
                      ),
                    );
                  }),
        ],
      ),
    );
  }
}
