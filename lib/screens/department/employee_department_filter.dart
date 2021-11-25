import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecaresystem/screens/employee/employee_week.dart';
import 'package:ecaresystem/services/database/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class EmployeeDepartmentFilter extends StatefulWidget {
  final String name;
  const EmployeeDepartmentFilter({Key? key, required this.name})
      : super(key: key);

  @override
  _EmployeeDepartmentFilterState createState() =>
      _EmployeeDepartmentFilterState();
}

class _EmployeeDepartmentFilterState extends State<EmployeeDepartmentFilter> {
  bool _loading = true;
  late QuerySnapshot data;
  late String total = "0";

  List<QueryDocumentSnapshot> dd = List.empty(growable: true);
  late List<QueryDocumentSnapshot> week;
  late List<QueryDocumentSnapshot> month;
  late List<QueryDocumentSnapshot> year;
  @override
  void initState() {
    getData();
    super.initState();
  }

  void displayDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text("Select Range"),
        content: Column(
          children: [
            TextButton(
                onPressed: () {
                  getByLastWeek();
                  Navigator.pop(context);
                  Get.to(() => EmployeeWeek(
                        name: widget.name,
                        week: week,
                      ));
                },
                child: const Text("Last Week")),
            TextButton(
                onPressed: () {
                  getByLastMonth();
                  Navigator.pop(context);
                  Get.to(() => EmployeeWeek(
                        name: widget.name,
                        week: month,
                      ));
                },
                child: const Text("Last Month")),
            TextButton(
                onPressed: () {
                  getByLastYears();
                  Navigator.pop(context);
                  Get.to(() => EmployeeWeek(
                        name: widget.name,
                        week: year,
                      ));
                },
                child: const Text("Last Year")),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text("Close"),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
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

  getData() async {
    data = await DataBase("").getEmployeequery(widget.name);
    dd = data.docs;
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
          actions: [
            IconButton(
                onPressed: () {
                  displayDialog();
                },
                icon: const Icon(Icons.date_range)),
          ],
        ),
        floatingActionButton: Container(
            width: double.infinity,
            height: 60.0,
            alignment: Alignment.center,
            color: Colors.cyan,
            child: _loading ? Container() : Text(total.toString())),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: _loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: data.docs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      tileColor: Colors.white,
                      title: Text(
                        "${data.docs[index]["Taskname"]}",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text("${data.docs[index]['Date']}"),
                      trailing: Text("${data.docs[index]['Hours']}:"
                          "${data.docs[index]["minutes"]}"),
                    ),
                  );
                }),
      ),
    );
  }
}
