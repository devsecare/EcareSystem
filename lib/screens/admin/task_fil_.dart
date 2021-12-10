import 'package:ecaresystem/constants.dart';
import 'package:ecaresystem/model/test_model.dart';
import 'package:ecaresystem/services/database/database.dart';
import 'package:ecaresystem/widgets/tasklistcontainer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class TaskFilScreen extends StatefulWidget {
  final String taskname;
  final String id;
  const TaskFilScreen({Key? key, required this.taskname, required this.id})
      : super(key: key);

  @override
  _TaskFilScreenState createState() => _TaskFilScreenState();
}

class _TaskFilScreenState extends State<TaskFilScreen> {
  final contro = Get.find<DataBase>();
  // ignore: prefer_typing_uninitialized_variables
  List<TestModel> data = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    contro.totaltask.value = "00";
    data = await contro.getUserbyTask(widget.taskname);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: maincolor,
        elevation: 0.0,
        title: Text(widget.taskname),
      ),
      floatingActionButton: Obx(
        () => contro.loading.value
            ? const CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                child: Container(
                  // height: 9.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  // alignment: Alignment.center,

                  child: Obx(
                    () => contro.loading.value
                        ? const CircularProgressIndicator()
                        : Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Get.defaultDialog(
                                        middleText:
                                            "Are you sure you want to Close this task?",
                                        onCancel: () {},
                                        onConfirm: () async {
                                          await DataBase("")
                                              .closeTask(widget.id);
                                          Get.back();
                                          Get.snackbar("Task Closed",
                                              "Your Task is Closed",
                                              backgroundColor: Colors.black,
                                              colorText: Colors.white);
                                        });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: maincolor,
                                    minimumSize: Size(40.w, 7.h),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0)),
                                  ),
                                  child: Text(
                                    "CLOSE",
                                    style: GoogleFonts.manrope(
                                      fontSize: 12.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                FittedBox(
                                  child: Container(
                                    height: 7.h,
                                    width: 40.w,
                                    decoration: BoxDecoration(
                                      color: const Color(0xffF7ECEF),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: Center(
                                      child: RichText(
                                        text: TextSpan(children: [
                                          TextSpan(
                                            text: contro.totaltask.value,
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
                                                'hrs',
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
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Stack(
        children: [
          Container(
            height: 10.h,
            decoration: const BoxDecoration(
              color: maincolor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(45.0),
                bottomRight: Radius.circular(45.0),
              ),
            ),
          ),
          Obx(
            () => contro.loading.value
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TaskListContainer(
                          title: data[index].name,
                          mini: data[index].min,
                          hours: data[index].hours,
                          comment: data[index].comment,
                        ),
                      );
                      // return Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Card(
                      //     elevation: 10.0,
                      //     shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(12.0)),
                      //     child: ListTile(
                      //       contentPadding: const EdgeInsets.all(10.0),
                      //       tileColor: Colors.white,
                      //       shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(15),
                      //       ),
                      //       title: Text(data[index].name),
                      //     ),
                      //   ),
                      // );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
