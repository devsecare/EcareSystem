import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecaresystem/screens/department/emp_dep_fliter.dart';
import 'package:ecaresystem/screens/department/employee_department_filter.dart';
import 'package:ecaresystem/services/database/database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../constants.dart';

class DepartmentFilterScreen extends StatefulWidget {
  final String department;
  const DepartmentFilterScreen({Key? key, required this.department})
      : super(key: key);

  @override
  _DepartmentFilterScreenState createState() => _DepartmentFilterScreenState();
}

class _DepartmentFilterScreenState extends State<DepartmentFilterScreen> {
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: maincolor,
        elevation: 0.0,
        title: const Text("Employees"),
      ),
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
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: data.docs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 10.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          minVerticalPadding: 35.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          onTap: () {
                            Get.to(() => EmpDepFilter(
                                  name: data.docs[index]["Name"],
                                ));
                            // Get.to(() => EmployeeDepartmentFilter(
                            //     name: data.docs[index]['Name']));
                          },
                          tileColor: Colors.white,
                          title: Text(
                            "${data.docs[index]["Name"]}",
                            style: GoogleFonts.manrope(
                              fontWeight: FontWeight.bold,
                              fontSize: 12.sp,
                            ),
                          ),
                          trailing: Image.asset(
                            data.docs[index]['Department'] == "Developer"
                                ? dev
                                : data.docs[index]['Department'] ==
                                        "Marketing & SEO"
                                    ? mark
                                    : design,
                            scale: 2.35,
                          ),
                        ),
                      ),
                    );
                  }),
        ],
      ),
    );
  }
}
