import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecaresystem/screens/department/employee_department_filter.dart';
import 'package:ecaresystem/services/database/database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:google_fonts/google_fonts.dart';

class DepartmentFilter extends StatefulWidget {
  final String department;
  const DepartmentFilter({Key? key, required this.department})
      : super(key: key);

  @override
  _DepartmentFilterState createState() => _DepartmentFilterState();
}

class _DepartmentFilterState extends State<DepartmentFilter> {
  late QuerySnapshot data;
  late double total;
  bool _loading = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    data = await DataBase("").getUserbyDeparment(widget.department);
    // List jj = [];
    // for (var item in data.docs) {
    //   jj.add(item.get("Hours"));
    // }
    // total = jj.reduce((value, element) => value + element);
    // print(total);
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
            "Employees",
            style: GoogleFonts.poppins(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
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
                      onTap: () {
                        Get.to(() => EmployeeDepartmentFilter(
                            name: data.docs[index]['Name']));
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      tileColor: Colors.white,
                      title: Text(
                        "${data.docs[index]["Name"]}",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      // subtitle: Text("${data.docs[index]['Taskname']}"),
                      // trailing: Text("${data.docs[index]['Hours']}"),
                    ),
                  );
                }),
      ),
    );
  }
}
