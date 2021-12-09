import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecaresystem/constants.dart';
import 'package:ecaresystem/screens/admin/task_fil_.dart';
import 'package:ecaresystem/services/database/database.dart';
import 'package:ecaresystem/widgets/taskcontainer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class TaskListScreen extends StatefulWidget {
  final QuerySnapshot client;
  const TaskListScreen({Key? key, required this.client}) : super(key: key);

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  Future<void> _pull() async {
    getdd();
    setState(() {});
  }

  late QuerySnapshot data;
  late List<QueryDocumentSnapshot> dd;
  bool _loading = true;
  String? clientname;
  // final cro = Get.find<AuthService>();
  @override
  void initState() {
    getdd();
    super.initState();
  }

  void displayDialog() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          height: 38.h,
          width: 80.w,
          decoration: BoxDecoration(
            color: maincolor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Filter Task By Client",
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.client.docs.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 10.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            onTap: () async {
                              setState(() {
                                clientname =
                                    widget.client.docs[index]['ClientName'];

                                getdd(clientname);
                                Navigator.pop(context);
                              });
                            },
                            tileColor: Colors.white,
                            title: Text(
                              widget.client.docs[index]['ClientName'],
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getdd([String? cl]) async {
    setState(() {
      _loading = true;
    });
    data = await DataBase("").getTask(cl);
    dd = data.docs;

    dd.sort((a, b) {
      if (b["Active"]) {
        return 1;
      }
      return -1;
    });
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: maincolor,
        elevation: 0.0,
        title: const Text('Task list'),
        actions: [
          IconButton(
              onPressed: () {
                displayDialog();
              },
              icon: const Icon(
                Icons.sort,
              ))
        ],
      ),
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
          _loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : RefreshIndicator(
                  onRefresh: _pull,
                  child: ListView.builder(
                    itemCount: data.docs.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => TaskFilScreen(
                                taskname: dd[index]["Taskname"],
                                id: dd[index].reference.id,
                              ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TaskContainer(
                            active: dd[index]["Active"],
                            title: dd[index]['Taskname'],
                            comment: dd[index]['Clientname'],
                            mini: dd[index]['EstHours'].toString(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
