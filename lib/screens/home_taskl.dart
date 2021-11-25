import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecaresystem/constants.dart';
import 'package:ecaresystem/services/auth.dart';
import 'package:ecaresystem/services/database/database.dart';
import 'package:ecaresystem/widgets/tasklistcontainer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import 'home_emp1.dart';

class HomeTaskList extends StatefulWidget {
  const HomeTaskList({Key? key}) : super(key: key);

  @override
  _HomeTaskListState createState() => _HomeTaskListState();
}

class _HomeTaskListState extends State<HomeTaskList> {
  bool _loading = true;
  final _auth = Get.find<AuthService>();
  late DocumentSnapshot user;
  late QuerySnapshot data;
  late String name;

  @override
  void initState() {
    // _gettasklist();
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _gettasklist();
    });
  }

  _gettasklist() async {
    user = await DataBase(_auth.user.value!.uid).getUser();
    name = user.get("Name");

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _pull() async {
      setState(() {});
    }

    return Material(
      child: Stack(
        children: [
          Container(
            height: 25.h,
            decoration: const BoxDecoration(
              color: maincolor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(35),
                bottomRight: Radius.circular(35),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.0.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Task Lists",
                    style: GoogleFonts.manrope(
                      fontSize: 18.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.defaultDialog(
                          middleText: "Are you sure you want to exit?",
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
                ],
              ),
            ),
          ),
          _loading
              ? const Center(
                  child: CircularProgressIndicator(
                  color: Colors.white,
                ))
              : Positioned(
                  top: 13.h,
                  left: 6.w,
                  right: 6.w,
                  bottom: 1.h,
                  child: RefreshIndicator(
                    onRefresh: _pull,
                    child: FutureBuilder(
                      future: DataBase("").getDailyTaskbyUser(name),
                      builder: (context, AsyncSnapshot<QuerySnapshot?> data) {
                        if (data.hasData) {
                          return ListView.builder(
                            itemCount: data.data!.docs.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TaskListContainer(
                                  title: data.data!.docs[index]["Taskname"],
                                  hours: data.data!.docs[index]['Hours'],
                                  mini: data.data!.docs[index]["minutes"],
                                  comment: data.data!.docs[index]['Comments'],
                                ),
                              );
                            },
                          );
                        }
                        return const CircularProgressIndicator();
                      },
                    ),
                  ),
                ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () {
                  Get.to(() => const HomeEmp());
                },
                backgroundColor: maincolor,
                elevation: 20,
                child: const Icon(Icons.add),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
