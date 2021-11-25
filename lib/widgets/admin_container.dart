import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../constants.dart';

class AdminContainer extends StatelessWidget {
  final String num;
  final String img;
  final String dname;
  final String dsubtitle;
  const AdminContainer(
      {Key? key,
      required this.num,
      required this.img,
      required this.dname,
      required this.dsubtitle})
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
              padding: const EdgeInsets.only(right: 15.0, top: 5.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Text(
                  num,
                  style: GoogleFonts.manrope(
                    color: maincolor,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                bottom: 2.0,
              ),
              child: Image.asset(
                img,
                scale: 2.5,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 2.0),
              child: Text(
                dname,
                style: GoogleFonts.manrope(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
              child: Text(
                dsubtitle,
                style: GoogleFonts.manrope(
                  fontSize: 8.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
