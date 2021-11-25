import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../constants.dart';

class TaskListContainer extends StatelessWidget {
  final String? title;
  final String? comment;
  final String? mini;
  final String? hours;

  const TaskListContainer(
      {Key? key, this.title, this.comment, this.mini, this.hours})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 10,
              offset: Offset(0.0, 0.0),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      title!,
                      style: GoogleFonts.manrope(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: '$hours:$mini',
                        style: GoogleFonts.manrope(
                          fontSize: 22.sp,
                          color: maincolor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      WidgetSpan(
                        child: Transform.translate(
                          offset: const Offset(2, -11),
                          child: Text(
                            'hr',
                            //superscript is usually smaller in size
                            textScaleFactor: 0.7,
                            style: GoogleFonts.manrope(
                              fontSize: 18.sp,
                              color: maincolor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ]),
                  ),
                ],
              ),
              // SizedBox(
              //   height: 1.h,
              // ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  comment!,
                  style: GoogleFonts.manrope(
                    fontSize: 10.sp,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
