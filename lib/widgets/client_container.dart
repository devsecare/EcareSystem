import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../constants.dart';

class ClientContainer extends StatelessWidget {
  final String name;
  final VoidCallback edit;
  const ClientContainer({Key? key, required this.name, required this.edit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              15.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                offset: const Offset(
                  5.0,
                  5.0,
                ),
                blurRadius: 10.0,
                spreadRadius: 2.0,
              ), //BoxShadow
              const BoxShadow(
                color: Colors.white,
                offset: Offset(0.0, 0.0),
                blurRadius: 0.0,
                spreadRadius: 0.0,
              ), //Bo
            ]),
        width: 40.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  right: 15.0, top: 15.0, bottom: 15, left: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  name,
                  style: GoogleFonts.manrope(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton.icon(
                  onPressed: edit,
                  icon: const Icon(
                    Icons.edit,
                    color: maincolor,
                  ),
                  label: const Text(
                    "Edit",
                    style: TextStyle(
                      color: maincolor,
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
