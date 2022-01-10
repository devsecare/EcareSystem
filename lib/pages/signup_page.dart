import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecaresystem/services/auth.dart';
import 'package:ecaresystem/services/database/database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../constants.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _joiningcode = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final _auth = Get.find<AuthService>();
  late QuerySnapshot data;
  bool _loading = true;
  bool _load = false;
  late String departmentvalue;
  @override
  void initState() {
    getDepartments();
    super.initState();
  }

  getDepartments() async {
    data = await DataBase("").getDepartment();
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size sd = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 60.h,
            width: sd.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(bg2),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.h),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 8.h,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      logo,
                      height: 10.h,
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "A WORLD-CLASS\nDIGITAL SOLUTIONS\nCOMPANY",
                      style: GoogleFonts.manrope(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 20.0.sp,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(20.0),
                    child: Container(
                      height: 55.h,
                      width: 90.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 10,

                            offset: Offset(
                                0.0, 0.0), // shadow direction: bottom right
                          )
                        ],
                      ),
                      child: Form(
                        key: _formkey,
                        child: FittedBox(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 2.h,
                              ),
                              Text(
                                "Register into eCare infoway LLP",
                                style: GoogleFonts.manrope(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10.0.sp,
                                ),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              SizedBox(
                                width: 85.w,
                                child: TextFormField(
                                  autocorrect: true,
                                  controller: _name,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter name";
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    hintText: '| Name ',
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: Color(0xffE51C4C),
                                    ),
                                    hintStyle: TextStyle(color: Colors.grey),
                                    filled: true,
                                    fillColor: Colors.white70,
                                    focusColor: Color(0xffE51C4C),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 1),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide: BorderSide(
                                          color: Color(0xffE51C4C), width: 2),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              _loading
                                  ? const CircularProgressIndicator()
                                  : SizedBox(
                                      width: 85.w,
                                      child: DropdownButtonFormField(
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          prefixIcon: const Icon(
                                            Icons.backpack,
                                            color: Color(0xffE51C4C),
                                          ),
                                        ),
                                        items: data.docs.map((e) {
                                          return DropdownMenuItem<String>(
                                            value: e['Department'],
                                            child: Text(
                                              e['Department'],
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                          );
                                        }).toList(),
                                        focusColor: Colors.black,
                                        elevation: 5,
                                        style: const TextStyle(
                                            color: Colors.black),
                                        iconEnabledColor:
                                            const Color(0xffE51C4C),
                                        hint: Text(
                                          "| Select department",
                                          style: GoogleFonts.poppins(
                                              color: Colors.grey,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        onChanged: (String? value) {
                                          setState(() {
                                            departmentvalue = value!;
                                          });
                                        },
                                      ),
                                    ),
                              SizedBox(
                                height: 2.h,
                              ),
                              SizedBox(
                                width: 85.w,
                                child: TextFormField(
                                  autocorrect: true,
                                  controller: _email,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter Email";
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    hintText: '| Email ',
                                    prefixIcon: Icon(
                                      Icons.email,
                                      color: Color(0xffE51C4C),
                                    ),
                                    hintStyle: TextStyle(color: Colors.grey),
                                    filled: true,
                                    fillColor: Colors.white70,
                                    focusColor: Color(0xffE51C4C),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 1),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide: BorderSide(
                                          color: Color(0xffE51C4C), width: 2),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              SizedBox(
                                width: 85.w,
                                child: TextFormField(
                                  autocorrect: true,
                                  controller: _password,
                                  obscureText: true,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter password";
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    hintText: '| Password ',
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: Color(0xffE51C4C),
                                    ),
                                    hintStyle: TextStyle(color: Colors.grey),
                                    filled: true,
                                    fillColor: Colors.white70,
                                    focusColor: Color(0xffE51C4C),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 1),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide: BorderSide(
                                          color: Color(0xffE51C4C), width: 2),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              SizedBox(
                                width: 85.w,
                                child: TextFormField(
                                  autocorrect: true,
                                  controller: _joiningcode,
                                  obscureText: false,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter joining password";
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    hintText: '| joining password ',
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: Color(0xffE51C4C),
                                    ),
                                    hintStyle: TextStyle(color: Colors.grey),
                                    filled: true,
                                    fillColor: Colors.white70,
                                    focusColor: Color(0xffE51C4C),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 1),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide: BorderSide(
                                          color: Color(0xffE51C4C), width: 2),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 2.5.h,
                              ),
                              ElevatedButton.icon(
                                onPressed: () async {
                                  if (_formkey.currentState!.validate()) {
                                    setState(() {
                                      _load = true;
                                    });
                                    await DataBase("")
                                        .getJoiningCode(
                                      code: _joiningcode.text.toString().trim(),
                                    )
                                        .then((value) async {
                                      if (value) {
                                        await AuthService()
                                            .signUp(_email.text, _password.text)
                                            .then((val) async {
                                          await DataBase(_auth.user.value!.uid)
                                              .updateUser(
                                                  _name.text,
                                                  departmentvalue,
                                                  _auth.user.value!.uid);
                                          Get.back();
                                        });
                                        setState(() {
                                          _load = false;
                                        });
                                      } else {
                                        print("naaaa");
                                        setState(() {
                                          _load = false;
                                          Get.showSnackbar(const GetSnackBar(
                                            message:
                                                "Not valid joining Code.😕 🙁 ",
                                          ));
                                        });
                                      }
                                    });
                                  }
                                },
                                icon: const Icon(Icons.arrow_forward_ios),
                                label: _load
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : const Text("REGISTER"),
                                style: ElevatedButton.styleFrom(
                                  primary: const Color(0xffE51C4C),
                                  minimumSize: Size(80.w, 6.h),
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(12), // <-- Radius
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 2.5.h,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Center(
                    child: RichText(
                      text: TextSpan(
                          text: 'Already registered?',
                          style: GoogleFonts.manrope(
                            color: Colors.black,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: ' Login here',
                                style: GoogleFonts.manrope(
                                  color: const Color(0xffE51C4C),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.back();
                                  })
                          ]),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
