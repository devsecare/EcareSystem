import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecaresystem/screens/employee/empolyeefilter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class EmployeeScreen extends StatefulWidget {
  final QuerySnapshot user;
  const EmployeeScreen({Key? key, required this.user}) : super(key: key);

  @override
  _EmployeeScreenState createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
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
        body: ListView.builder(
            itemCount: widget.user.docs.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  onTap: () {
                    Get.to(() => EmployeeFilter(
                          name: widget.user.docs[index]["Name"],
                        ));
                  },
                  tileColor: Colors.white,
                  title: Text(
                    "${widget.user.docs[index]["Name"]}",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text("${widget.user.docs[index]['Department']}"),
                ),
              );
            }),
      ),
    );
  }
}
