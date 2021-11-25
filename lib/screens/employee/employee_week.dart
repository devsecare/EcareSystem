import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmployeeWeek extends StatefulWidget {
  final String name;
  final List<QueryDocumentSnapshot> week;
  const EmployeeWeek({Key? key, required this.name, required this.week})
      : super(key: key);

  @override
  _EmployeeWeekState createState() => _EmployeeWeekState();
}

class _EmployeeWeekState extends State<EmployeeWeek> {
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

    int total1 = jj.reduce((value, element) => value + element);
    int totalmin = vv.reduce((value, element) => value + element);

    var dd1 = Duration(hours: total1, minutes: totalmin);
    total = dd1.toString().substring(0, 5);

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomLeft,
            colors: [Colors.lightBlueAccent, Colors.blueGrey]),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          title: Text(
            widget.name,
            style: GoogleFonts.poppins(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        floatingActionButton: Container(
            width: double.infinity,
            height: 60.0,
            alignment: Alignment.center,
            color: Colors.cyan,
            child: _loading ? Container() : Text(total.toString())),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: ListView.builder(
            itemCount: widget.week.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  onTap: () {},
                  tileColor: Colors.white,
                  title: Text(
                    "${widget.week[index]["Taskname"]}",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text("${widget.week[index]["Date"]}"),
                  trailing: Text("${widget.week[index]['Hours']}:"
                      "${widget.week[index]["minutes"]}"),
                ),
              );
            }),
      ),
    );
  }
}
