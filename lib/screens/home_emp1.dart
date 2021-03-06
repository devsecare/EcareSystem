import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecaresystem/constants.dart';
import 'package:ecaresystem/model/emailmodel.dart';
import 'package:ecaresystem/services/auth.dart';
import 'package:ecaresystem/services/database/database.dart';
import 'package:ecaresystem/services/email_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class HomeEmp extends StatefulWidget {
  const HomeEmp({Key? key}) : super(key: key);

  @override
  _HomeEmpState createState() => _HomeEmpState();
}

class _HomeEmpState extends State<HomeEmp> {
  bool _loading = true;
  bool _sending = false;
  final _auth = Get.find<AuthService>();
  late QuerySnapshot data;
  late QuerySnapshot client;
  late DocumentSnapshot user;
  late String name;
  late String taskvalue;
  late String clientname;
  late String hoursvalue;
  String? minutesvalue;
  bool _load = false;

  final TextEditingController _comments = TextEditingController();

  @override
  void initState() {
    _gettasklist();
    super.initState();
  }

  _gettasklist() async {
    data = await DataBase("").getTaskforUser();
    user = await DataBase(_auth.user.value!.uid).getUser();
    name = user.get("Name");
    client = await DataBase("").getclient();

    setState(() {
      _loading = false;
    });
  }

  _getTaskbyClient(String cl) async {
    setState(() {
      _load = true;
    });
    data = await DataBase("").getTaskbyclient(cl);

    setState(() {
      _load = false;
    });
  }

  Future<void> sendEmails() async {
    setState(() {
      _sending = true;
    });
    var dd = await DataBase("").getDailyTaskforEmail(name);

    List<EmailData> data = [];
    for (var element in dd.docs) {
      data.add(EmailData(
        hours: element.get("Hours"),
        min: element.get("minutes"),
        taskname: element.get("Taskname"),
        clientname: element.get('ClientName'),
      ));
    }
    var fi = data
        .map((e) =>
            '''${e.hours.toString()}:${e.min.toString()}  :-   ${e.taskname.toString()} (${e.clientname}) <br> ''')
        .join(" ");
    var subj = '$name - Daily Task - ${dd.docs.first.get("Date")}';

    try {
      // ignore: unused_local_variable
      var res = await EmailAPi().sendEmail(fi.toString(), subj.toString());

      Get.showSnackbar(
        const GetSnackBar(
          message: "Message sent: successfully ???? ",
        ),
      );
      // ignore: unused_catch_clause
    } catch (e) {
      // ignore: avoid_print

      Get.showSnackbar(const GetSnackBar(
        message: "Message not sent.???? ???? ",
      ));
    }
    setState(() {
      _sending = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: maincolor,
        title: Text(
          "Add your working hours",
          style: GoogleFonts.manrope(),
        ),
        actions: [
          _sending
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : IconButton(
                  onPressed: () async {
                    sendEmails();
                  },
                  icon: const Icon(Icons.mark_email_read),
                ),
        ],
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(18.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                          text: 'Select your client',
                          style: GoogleFonts.manrope(
                            color: Colors.black,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: '*',
                              style: GoogleFonts.manrope(
                                color: const Color(0xffE51C4C),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ]),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Center(
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(
                            Icons.person,
                            color: Color(0xffE51C4C),
                          ),
                        ),
                        items: client.docs.map((e) {
                          return DropdownMenuItem<String>(
                            value: e['ClientName'],
                            child: Text(
                              e['ClientName'],
                              style: const TextStyle(color: Colors.black),
                            ),
                          );
                        }).toList(),
                        focusColor: maincolor,
                        elevation: 5,
                        style: const TextStyle(color: Colors.white),
                        iconEnabledColor: maincolor,
                        icon: const Icon(CupertinoIcons.arrow_down_circle),
                        hint: Text(
                          "| Please choose a Client*",
                          style: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            clientname = value!;
                            _getTaskbyClient(clientname);
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    RichText(
                      text: TextSpan(
                          text: 'Select your task',
                          style: GoogleFonts.manrope(
                            color: Colors.black,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: '*',
                              style: GoogleFonts.manrope(
                                color: const Color(0xffE51C4C),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ]),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Center(
                      child: _load
                          ? const CircularProgressIndicator()
                          : DropdownButtonFormField(
                              isExpanded: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                prefixIcon: const Icon(
                                  Icons.person,
                                  color: Color(0xffE51C4C),
                                ),
                              ),
                              items: data.docs.map((e) {
                                return DropdownMenuItem<String>(
                                  value: e['Taskname'],
                                  child: Text(
                                    e['Taskname'],
                                    style: const TextStyle(
                                        color: Colors.black,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                );
                              }).toList(),
                              focusColor: Colors.white,
                              // value: _chosenValue,
                              elevation: 5,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              iconEnabledColor: maincolor,
                              icon:
                                  const Icon(CupertinoIcons.arrow_down_circle),
                              hint: Text(
                                " | Please select Task*",
                                style: GoogleFonts.poppins(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                              onChanged: (String? value) {
                                setState(() {
                                  taskvalue = value!;
                                });
                              },
                            ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Working hours',
                        style: GoogleFonts.manrope(
                          color: Colors.black,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: '*',
                            style: GoogleFonts.manrope(
                              color: const Color(0xffE51C4C),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Center(
                      child: DropdownButtonFormField(
                        isExpanded: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(
                            Icons.timelapse,
                            color: Color(0xffE51C4C),
                          ),
                        ),
                        items: hours.map((e) {
                          return DropdownMenuItem<String>(
                            value: e,
                            child: Text(
                              e,
                              style: const TextStyle(
                                  color: Colors.black,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          );
                        }).toList(),
                        focusColor: Colors.white,
                        // value: _chosenValue,
                        elevation: 5,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        iconEnabledColor: maincolor,
                        icon: const Icon(CupertinoIcons.arrow_down_circle),
                        hint: Text(
                          " | Enter hours",
                          style: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            hoursvalue = value!;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Working minutes',
                        style: GoogleFonts.manrope(
                          color: Colors.black,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: '*',
                            style: GoogleFonts.manrope(
                              color: const Color(0xffE51C4C),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Center(
                      child: DropdownButtonFormField(
                        isExpanded: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(
                            Icons.timelapse,
                            color: Color(0xffE51C4C),
                          ),
                        ),
                        items: minutes.map((e) {
                          return DropdownMenuItem<String>(
                            value: e,
                            child: Text(
                              e,
                              style: const TextStyle(
                                  color: Colors.black,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          );
                        }).toList(),
                        focusColor: Colors.white,
                        // value: _chosenValue,
                        elevation: 5,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        iconEnabledColor: maincolor,
                        icon: const Icon(CupertinoIcons.arrow_down_circle),
                        hint: Text(
                          " | Enter minutes",
                          style: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            minutesvalue = value!;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Text(
                      "Task comments",
                      style: GoogleFonts.manrope(
                        color: Colors.black,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    TextFormField(
                      controller: _comments,
                      maxLines: 5,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        hintText: "Enter here",
                      ),
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final da = DateTime.now();
                          final DateFormat formatter = DateFormat('yMMMMd');
                          final String formatted = formatter.format(da);

                          await DataBase(_auth.user.value!.uid).addTaskDaily(
                            formatted,
                            taskvalue,
                            hoursvalue,
                            minutesvalue ?? "00",
                            _comments.text,
                            user.get("Department"),
                            name,
                            clientname,
                          );
                          Get.snackbar(
                              "Task Added", "Your Task And Hours Added",
                              backgroundColor: Colors.black,
                              colorText: Colors.white);
                          _comments.clear();
                        },
                        icon: const Icon(Icons.arrow_forward_ios),
                        label: const Text("SAVE"),
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xffE51C4C),
                          minimumSize: Size(80.w, 7.h),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12), // <-- Radius
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
