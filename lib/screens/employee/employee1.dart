import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecaresystem/constants.dart';
import 'package:ecaresystem/screens/employee/emp_filter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class EmployeeScreen extends StatefulWidget {
  final QuerySnapshot user;
  const EmployeeScreen({Key? key, required this.user}) : super(key: key);

  @override
  _EmployeeScreenState createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
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
          ListView.builder(
              itemCount: widget.user.docs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 10.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      minVerticalPadding: 25.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      onTap: () {
                        Get.to(() => EmpFilter(
                              name: widget.user.docs[index]["Name"],
                            ));
                      },
                      tileColor: Colors.white,
                      title: Text(
                        "${widget.user.docs[index]["Name"]}",
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ),
                      ),
                      subtitle:
                          Text("${widget.user.docs[index]['Department']}"),
                      trailing: Image.asset(
                        widget.user.docs[index]['Department'] == "Developer"
                            ? dev
                            : widget.user.docs[index]['Department'] ==
                                    "Marketing"
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
