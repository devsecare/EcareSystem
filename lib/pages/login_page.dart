import 'package:ecaresystem/constants.dart';
import 'package:ecaresystem/pages/signup_page.dart';
import 'package:ecaresystem/services/auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final Size sd = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.topCenter,
      decoration: const BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
            image: AssetImage(bg), alignment: Alignment.topCenter),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 8.h,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    logo,
                    height: 20.h,
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Text(
                  "A WORLD-CLASS\nDIGITAL SOLUTIONS\nCOMPANY",
                  style: GoogleFonts.manrope(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 20.0.sp,
                  ),
                ),
                SizedBox(
                  height: 3.h,
                ),
                Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(20.0),
                  child: Container(
                    height: 40.h,
                    width: sd.width,
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
                      child: Column(
                        children: [
                          SizedBox(
                            height: 2.h,
                          ),
                          Text(
                            "Welcome to eCare infoway LLP, sign",
                            style: GoogleFonts.manrope(
                              fontWeight: FontWeight.w600,
                              fontSize: 10.0.sp,
                            ),
                          ),
                          Text(
                            "In to manage all your task lists",
                            style: GoogleFonts.manrope(
                              fontWeight: FontWeight.w600,
                              fontSize: 10.0.sp,
                            ),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          SizedBox(
                            width: 80.w,
                            child: TextFormField(
                              controller: _email,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter email";
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
                            height: 2.h,
                          ),
                          SizedBox(
                            width: 80.w,
                            child: TextFormField(
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
                            height: 2.5.h,
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              if (_formkey.currentState!.validate()) {
                                AuthService().signInwithEmail(
                                    _email.text, _password.text);
                              }
                            },
                            icon: const Icon(Icons.arrow_forward_ios),
                            label: const Text("LOGIN"),
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
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Center(
                  child: RichText(
                    text: TextSpan(
                        text: 'Don\'t have an account?',
                        style: GoogleFonts.manrope(
                          color: Colors.black,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: ' Sign up',
                              style: GoogleFonts.manrope(
                                color: const Color(0xffE51C4C),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.to(() => const SignUpScreen());
                                })
                        ]),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
