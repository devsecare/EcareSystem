import 'package:ecaresystem/services/database/database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskFilter extends StatefulWidget {
  final String taskname;
  final String id;
  const TaskFilter({Key? key, required this.taskname, required this.id})
      : super(key: key);

  @override
  _TaskFilterState createState() => _TaskFilterState();
}

class _TaskFilterState extends State<TaskFilter> {
  final contro = Get.find<DataBase>();
  // ignore: prefer_typing_uninitialized_variables
  var data;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    data = await contro.getUserbyTask(widget.taskname);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomLeft,
            colors: [Colors.lightBlueAccent, Colors.blueGrey]),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0.0,
          title: Text(
            widget.taskname,
            style: GoogleFonts.poppins(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Obx(
              () => contro.loading.value
                  ? const Center(child: CircularProgressIndicator())
                  : Center(
                      child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        contro.totaltask.value,
                        style: GoogleFonts.poppins(
                            color: Colors.black, fontSize: 20.0),
                      ),
                    )),
            ),
          ],
          backgroundColor: Colors.transparent,
        ),
        floatingActionButton: Container(
            height: 60,
            width: double.infinity,
            color: Colors.cyan,
            child: TextButton(
              onPressed: () async {
                Get.defaultDialog(
                    middleText: "Are you sure you want to Close this task?",
                    onCancel: () {},
                    onConfirm: () async {
                      await DataBase("").closeTask(widget.id);
                      Get.back();
                      Get.snackbar("Task Closed", "Your Task is Closed",
                          backgroundColor: Colors.black,
                          colorText: Colors.white);
                    });
              },
              child: Text(
                "Close Task",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: Obx(
          () => contro.loading.value
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        tileColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        title: Text(data[index]),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
