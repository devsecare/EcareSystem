import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecaresystem/services/database/database.dart';
import 'package:ecaresystem/widgets/client_container.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../constants.dart';

class TaskEditingScreen extends StatefulWidget {
  final String clientname;
  const TaskEditingScreen({Key? key, required this.clientname})
      : super(key: key);

  @override
  _TaskEditingScreenState createState() => _TaskEditingScreenState();
}

class _TaskEditingScreenState extends State<TaskEditingScreen> {
  late QuerySnapshot task;
  bool _loading = true;
  final TextEditingController _newclient = TextEditingController();
  @override
  void initState() {
    _getTask();
    super.initState();
  }

  _getTask() async {
    setState(() {
      _loading = true;
    });
    task = await DataBase("").getTaskbyclient(widget.clientname);
    setState(() {
      _loading = false;
    });
  }

  _displayDialog(BuildContext context, String id, String before) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            title: const Text('Enter New Name of Task'),
            content: TextField(
              controller: _newclient,
              // textInputAction: TextInputAction.go,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                hintText: '| Task ',
                prefixIcon: Icon(
                  Icons.person,
                  color: Color(0xffE51C4C),
                ),
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white70,
                focusColor: Color(0xffE51C4C),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  borderSide: BorderSide(color: Colors.grey, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Color(0xffE51C4C), width: 2),
                ),
              ),
            ),
            actions: [
              TextButton.icon(
                onPressed: () async {
                  print(id);
                  if (_newclient.text.isNotEmpty) {
                    await DataBase("")
                        .changeTaskName(id, _newclient.text, before);
                    _getTask();
                  }
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.done,
                  color: maincolor,
                ),
                label: const Text(
                  "Save",
                  style: TextStyle(color: maincolor),
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: maincolor,
        elevation: 0.0,
        title: Text(widget.clientname),
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
              : ListView.builder(
                  itemCount: task.docs.length,
                  itemBuilder: (context, index) {
                    return ClientContainer(
                      name: task.docs[index]['Taskname'],
                      edit: () {
                        _displayDialog(context, task.docs[index].id,
                            task.docs[index]['Taskname']);
                      },
                    );
                  }),
        ],
      ),
    );
  }
}
