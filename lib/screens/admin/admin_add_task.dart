import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecaresystem/constants.dart';
import 'package:ecaresystem/services/database/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _taskname = TextEditingController();
  final TextEditingController _hours = TextEditingController();
  final TextEditingController _client = TextEditingController();
  late QuerySnapshot data;
  bool _loading = true;
  late String clientname;

  Future<void> _pull() async {
    _loading = true;
    _getclient();
    setState(() {});
  }

  @override
  void initState() {
    _getclient();
    super.initState();
  }

  _getclient() async {
    data = await DataBase("").getclient();
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70.0,
        backgroundColor: maincolor,
        title: const Text("Add new task"),
        actions: [
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => Container(
                    height: 350.0,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.0),
                        topRight: Radius.circular(25.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(19.0),
                      child: ListView(
                        children: [
                          SizedBox(
                            height: 4.h,
                          ),
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
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          SizedBox(
                            width: 80.w,
                            child: TextFormField(
                              controller: _client,
                              decoration: const InputDecoration(
                                hintText: '| Enter client name ',
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Color(0xffE51C4C),
                                ),
                                hintStyle: TextStyle(color: Colors.grey),
                                filled: true,
                                fillColor: Colors.white70,
                                focusColor: Color(0xffE51C4C),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0)),
                                  borderSide:
                                      BorderSide(color: Colors.grey, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(
                                      color: Color(0xffE51C4C), width: 2),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          ElevatedButton.icon(
                            onPressed: () async {
                              if (_client.text.isNotEmpty) {
                                await DataBase("").addClient(_client.text);
                                _client.clear();
                              }
                              Get.back();
                            },
                            icon: const Icon(Icons.add),
                            label: const Text("ADD NEW Client"),
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
                        ],
                      ),
                    )),
              );
            },
            child: Image.asset(
              addtask,
              scale: 3,
            ),
          ),
          GestureDetector(
            onTap: _pull,
            child: Image.asset(
              reload,
              scale: 3,
            ),
          ),
        ],
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(
                color: maincolor,
              ),
            )
          : Form(
              key: _formkey,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: ListView(
                  children: [
                    SizedBox(
                      height: 1.h,
                    ),
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
                            Icons.person,
                            color: Color(0xffE51C4C),
                          ),
                        ),
                        items: data.docs.map((e) {
                          return DropdownMenuItem<String>(
                            value: e['ClientName'],
                            child: Text(
                              e['ClientName'],
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
                          " | please select client",
                          style: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            clientname = value!;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Enter task name',
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

                    SizedBox(
                      width: 80.w,
                      child: TextFormField(
                        controller: _taskname,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter password";
                          }
                        },
                        decoration: const InputDecoration(
                          hintText: '| Please enter title ',
                          prefixIcon: Icon(
                            Icons.backpack,
                            color: Color(0xffE51C4C),
                          ),
                          hintStyle: TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.white70,
                          focusColor: Color(0xffE51C4C),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide:
                                BorderSide(color: Color(0xffE51C4C), width: 2),
                          ),
                        ),
                      ),
                    ),
                    /////////////////////
                    SizedBox(
                      height: 2.h,
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Set estimated hours',
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
                    SizedBox(
                      width: 80.w,
                      child: TextFormField(
                        controller: _hours,
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter hours";
                          }
                        },
                        decoration: const InputDecoration(
                          hintText: '| Enter estimated hours ',
                          prefixIcon: Icon(
                            Icons.timelapse,
                            color: Color(0xffE51C4C),
                          ),
                          hintStyle: TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.white70,
                          focusColor: Color(0xffE51C4C),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide:
                                BorderSide(color: Color(0xffE51C4C), width: 2),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        if (_formkey.currentState!.validate()) {
                          // await DataBase("")
                          //     .addTask(_taskname.text, _hours.text, clientname);

                          // Get.snackbar("Task Added", "Your Task Added",
                          //     backgroundColor: Colors.black,
                          //     colorText: Colors.white);
                          _taskname.clear();
                          _hours.clear();
                          final Email email = Email(
                            body: 'Email body',
                            subject: 'Email subject',
                            recipients: ['jayveersinh.ecareinfoway@gmail.com'],
                            isHTML: false,
                          );

                          await FlutterEmailSender.send(email);
                        }
                      },
                      icon: const Icon(Icons.arrow_forward_ios),
                      label: const Text("ADD TASK"),
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xffE51C4C),
                        minimumSize: Size(80.w, 7.h),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // <-- Radius
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
