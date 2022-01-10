import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecaresystem/constants.dart';
import 'package:ecaresystem/screens/admin/admin_add_task.dart';
import 'package:ecaresystem/screens/admin/client.dart';
import 'package:ecaresystem/screens/admin/task_list_.dart';
import 'package:ecaresystem/screens/department/department_.dart';
import 'package:ecaresystem/screens/employee/employee1.dart';
import 'package:ecaresystem/services/auth.dart';
import 'package:ecaresystem/services/database/database.dart';
import 'package:ecaresystem/services/email_api.dart';
import 'package:ecaresystem/widgets/admin_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final _auth = Get.find<AuthService>();
  late QuerySnapshot user;
  late QuerySnapshot tasks;
  late QuerySnapshot department;
  late QuerySnapshot clients;
  bool _loading = true;
  @override
  void initState() {
    test();
    super.initState();
  }

  test() async {
    user = await DataBase("").getUserCount();
    tasks = await DataBase("").getTask();
    department = await DataBase("").getDepartment();
    clients = await DataBase("").getclient();
    setState(() {
      _loading = false;
    });
  }

  Future<void> _pull() async {
    test();
  }

  Future<void> sendEmails() async {
    var dd = await DataBase("").testData();

    // var fi = dd
    //     .map((e) =>
    //         '''${e.hours.toString()}:${e.min.toString()}  :-   ${e.taskname.toString()} (${e.clientname}) <br> ''')
    //     .join(" ");

    var subj = 'Total of all Task Report';

    var fi = dd.map((e) => '''
${e.total} :-   ${e.name} (${e.clientname}) <br>
    ''').join(" ");

    try {
      // ignore: unused_local_variable
      var res = await EmailAPi().sendEmail(fi.toString(), subj.toString());
      print(res);

      Get.showSnackbar(
        const GetSnackBar(
          message: "Message sent: successfully 🤗 ",
        ),
      );
      // ignore: unused_catch_clause
    } catch (e) {
      // ignore: avoid_print

      Get.showSnackbar(const GetSnackBar(
        message: "Message not sent.😕 🙁 ",
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const AddTaskScreen());
        },
        backgroundColor: maincolor,
        elevation: 10.0,
        child: const Icon(
          Icons.add,
        ),
      ),
      // floatingActionButton: Row(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     FloatingActionButton(
      //       onPressed: () {
      //         Get.to(() => const AddTaskScreen());
      //       },
      //       backgroundColor: maincolor,
      //       elevation: 10.0,
      //       child: const Icon(
      //         Icons.add,
      //       ),
      //     ),
      //     const SizedBox(
      //       width: 10,
      //     ),
      //     FloatingActionButton(
      //       onPressed: () {
      //         sendEmails();
      //       },
      //       backgroundColor: maincolor,
      //       elevation: 10.0,
      //       child: const Icon(
      //         Icons.mail,
      //       ),
      //     ),
      //   ],
      // ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(
                color: maincolor,
              ),
            )
          : RefreshIndicator(
              onRefresh: _pull,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 33.h,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage(
                            adminbg,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 8.h,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 25.0),
                              child: Align(
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  onTap: () {
                                    Get.defaultDialog(
                                        middleText:
                                            "Are you sure you want to exit?",
                                        onCancel: () {
                                          Get.back();
                                        },
                                        onConfirm: () {
                                          _auth.signout();
                                          Get.back();
                                        });
                                  },
                                  child: Image.asset(
                                    logout,
                                    scale: 3,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Text(
                              "Hi, LAXMAN",
                              style: GoogleFonts.manrope(
                                fontSize: 20.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Text(
                              "How you're doing today? Let's check\nout how your employees are doing\ntoday",
                              style: GoogleFonts.manrope(
                                fontSize: 10.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20.0,
                        left: 18,
                      ),
                      child: Text(
                        "Activities Monitoring",
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                    GridView.count(
                        physics: const BouncingScrollPhysics(),
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        childAspectRatio: 1.0,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(() => EmployeeScreen(
                                    user: user,
                                  ));
                            },
                            child: FittedBox(
                              child: AdminContainer(
                                dname: 'Employees',
                                dsubtitle: 'Total personnels',
                                img: emp,
                                num: user.docs.length.toString(),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => TaskListScreen(
                                    client: clients,
                                  ));
                            },
                            child: FittedBox(
                              child: AdminContainer(
                                dname: 'Total tasks',
                                img: totaltask,
                                num: tasks.docs.length.toString(),
                                dsubtitle: 'Overall projects',
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(() =>
                                  DepartmentScreen(department: department));
                            },
                            child: FittedBox(
                              child: AdminContainer(
                                dname: 'Departments',
                                dsubtitle: 'No. of departments',
                                img: dep,
                                num: department.docs.length.toString(),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => const ClientScreen());
                            },
                            child: FittedBox(
                              child: AdminContainer(
                                dname: 'Clients',
                                dsubtitle: 'No. of Clients',
                                img: dep,
                                num: clients.docs.length.toString(),
                              ),
                            ),
                          ),
                        ]),
                  ],
                ),
              ),
            ),
    );
  }
}
