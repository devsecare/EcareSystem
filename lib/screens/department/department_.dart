import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecaresystem/screens/department/department_filter_.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../constants.dart';

class DepartmentScreen extends StatefulWidget {
  final QuerySnapshot department;
  const DepartmentScreen({Key? key, required this.department})
      : super(key: key);

  @override
  _DepartmentScreenState createState() => _DepartmentScreenState();
}

class _DepartmentScreenState extends State<DepartmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: maincolor,
        elevation: 0.0,
        title: const Text("Departments"),
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
          ListView.builder(
              itemCount: widget.department.docs.length,
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
                        Get.to(() => DepartmentFilterScreen(
                            department: widget.department.docs[index]
                                ['Department']));
                      },
                      tileColor: Colors.white,
                      title: Text(
                        "${widget.department.docs[index]["Department"]}",
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ),
                      ),
                      trailing: Image.asset(
                        widget.department.docs[index]['Department'] ==
                                "Developer"
                            ? dev
                            : widget.department.docs[index]['Department'] ==
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
