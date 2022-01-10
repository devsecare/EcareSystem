// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecaresystem/model/final_total.dart';
import 'package:ecaresystem/model/test_model.dart';
import 'package:ecaresystem/model/total_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import "package:collection/collection.dart";

// ignore: non_constant_identifier_names
String DAILYTASK = "Daily Tasks";

class DataBase extends GetxController {
  final String uid;

  late QuerySnapshot tasktoclose;
  var totaltask = "0".obs;
  var loading = true.obs;

  late QuerySnapshot testDaily;
  late QuerySnapshot testTask;

  final CollectionReference ref = FirebaseFirestore.instance.collection("User");
  final CollectionReference task =
      FirebaseFirestore.instance.collection("Task");
  final CollectionReference dailyTask =
      FirebaseFirestore.instance.collection(DAILYTASK);
  final CollectionReference department =
      FirebaseFirestore.instance.collection("Department");
  DataBase(this.uid);

  final CollectionReference client =
      FirebaseFirestore.instance.collection("Client");

  final CollectionReference joiningCode =
      FirebaseFirestore.instance.collection("joiningPassword");

  Future addTaskDaily(
    String date,
    String task,
    String hours,
    String minutes,
    String comments,
    String department,
    String user,
    String clientname,
  ) async {
    return await dailyTask.doc().set({
      "Taskname": task,
      "Hours": hours,
      "minutes": minutes,
      "Comments": comments,
      "Date": date,
      "Department": department,
      "User": user,
      "ClientName": clientname,
      "CreatedAt": DateTime.now(),
      "Active": true,
    });
  }

  Future addClient(String clientname) async {
    return await client.doc().set({
      "ClientName": clientname,
    });
  }

  Future updateUser(
    String name,
    String department,
    String id,
  ) async {
    return await ref.doc(uid).set({
      "Name": name,
      "Department": department,
      "Userid": id,
    });
  }

  Future addTask(String taskname, String hours, String clientname) async {
    return await task.doc().set({
      "Taskname": taskname,
      "EstHours": double.parse(hours),
      "Clientname": clientname,
      "Active": true,
      "CreatedAt": Timestamp.now(),
    });
  }

  Future<QuerySnapshot> getquery(String departmentname) async {
    return await dailyTask.where("Department", isEqualTo: departmentname).get();
  }

  Future<QuerySnapshot> getUserbyDeparment(String departmentname) async {
    return await ref.where("Department", isEqualTo: departmentname).get();
  }

  Future<QuerySnapshot> getEmployeequery(String username) async {
    return await dailyTask
        .where("User", isEqualTo: username)
        .orderBy("CreatedAt", descending: true)
        .get();
  }

  Future<QuerySnapshot> getEmployeeFilter(
      String username, DateTime date) async {
    return await dailyTask.where("User", isEqualTo: username).get();
  }

  Future<QuerySnapshot> getIdofTask(String taskname) async {
    var dname = await task.where("Taskname", isEqualTo: taskname).get();
    print("aaa tasknu name che ${dname.docs.first.id}");
    return dname;
  }

  Future<List<TestModel>> getUserbyTask(String taskname) async {
    loading(true);
    var dd = await dailyTask
        .where("Taskname", isEqualTo: taskname)
        .orderBy("CreatedAt", descending: true)
        .get();

    var task1 = dd.docs;
    // List<String> d = [];
    List<TestModel> g = [];

    if (task1.isNotEmpty) {
      List jj = [];
      List vv = [];

      for (var item in dd.docs) {
        // d.add(item["User"]);
        g.add(
          TestModel(
            name: item["User"],
            hours: item["Hours"].toString(),
            min: item["minutes"].toString(),
            comment: item["Date"].toString(),
          ),
        );

        jj.add(int.parse(item["Hours"]));
        vv.add(int.parse(item["minutes"]));
      }

      // d = d.toSet().toList();
      int total1 = jj.reduce((value, element) => value + element);
      int totalmin = vv.reduce((value, element) => value + element);

      var dd1 = Duration(hours: total1, minutes: totalmin);

      totaltask(dd1.toString().substring(0, 5));

      update();

      loading(false);
    }

    loading(false);

    return g;
  }

  Future getUser() async {
    return await ref.doc(uid).get();
  }

  Future<QuerySnapshot> getUserCount() async {
    return await ref.get();
  }

  Future<QuerySnapshot> getTask([String? client]) async {
    if (client != null) {
      tasktoclose = await task.where("Clientname", isEqualTo: client).get();
      return tasktoclose;
    } else {
      tasktoclose = await task.get();
      return tasktoclose;
    }
  }

  Future<QuerySnapshot> getTaskforUser() async {
    return await task.where("Active", isEqualTo: true).get();
  }

  Future<QuerySnapshot> getTaskbyclient(String clientname) async {
    return await task
        .where("Clientname", isEqualTo: clientname)
        .where("Active", isEqualTo: true)
        .get();
  }

  Future<QuerySnapshot> getclient() async {
    return await client.get();
  }

  Future closeTask(String id, String name) async {
    await task.doc(id).update({
      "Active": false,
    });
    await dailyTask.where("Taskname", isEqualTo: name).get().then((value) {
      // ignore: avoid_function_literals_in_foreach_calls
      value.docs.forEach((element) {
        element.reference.update({
          "Active": false,
        });
      });
    });
  }

  Future changeName(String id, name, before) async {
    await dailyTask.where("ClientName", isEqualTo: before).get().then((value) {
      // ignore: avoid_function_literals_in_foreach_calls
      value.docs.forEach((element) {
        element.reference.update({
          "ClientName": name,
        });
      });
    });
    await task.where("Clientname", isEqualTo: before).get().then((value) {
      // ignore: avoid_function_literals_in_foreach_calls
      value.docs.forEach((element) {
        element.reference.update({
          "Clientname": name,
        });
      });
    });
    await client.doc(id).update({
      "ClientName": name,
    });
  }

  Future changeTaskName(String id, name, before) async {
    await dailyTask.where("Taskname", isEqualTo: before).get().then((value) {
      // ignore: avoid_function_literals_in_foreach_calls
      value.docs.forEach((element) {
        element.reference.update({
          "Taskname": name,
        });
      });
    });
    await task.where("Taskname", isEqualTo: before).get().then((value) {
      // ignore: avoid_function_literals_in_foreach_calls
      value.docs.forEach((element) {
        element.reference.update({
          "Taskname": name,
        });
      });
    });

    await task.doc(id).update({
      "Taskname": name,
    });
  }

  Future<QuerySnapshot> getTest() async {
    return await dailyTask.get();
  }

  Future<QuerySnapshot> getDailyTaskbyUser(String user) async {
    return await dailyTask
        .where(
          "User",
          isEqualTo: user,
        )
        .orderBy("CreatedAt", descending: true)
        .get();
  }

  Future<QuerySnapshot> getDepartment() async {
    return await department.get();
  }

  Future<QuerySnapshot> getDailyTaskforEmail(String name) async {
    final da = DateTime.now();
    final DateFormat formatter = DateFormat('yMMMMd');
    final String formatted = formatter.format(da);

    return await dailyTask
        .where("User", isEqualTo: name)
        .where("Date", isEqualTo: formatted)
        .get();
  }

  Future<List<FinalTotal>> testData([String? client]) async {
    if (client != null) {
      testDaily = await dailyTask.where("ClientName", isEqualTo: client).get();
    } else {
      testDaily = await dailyTask.get();
    }

    List<TotalModel> j1 = [];
    List<FinalTotal> v1 = [];

    testDaily.docs
        .fold(<String, List<dynamic>>{}, (Map<String, List<dynamic>> a, b) {
          a.putIfAbsent(b['Taskname'], () => []).add(b);
          return a;
        })
        .values
        .where((l) => l.isNotEmpty)
        .map((l) => {
              j1.add(TotalModel(
                name: l.first['Taskname'],
                clientname: l.first['ClientName'],
                active: l.first['Active'],
                hours: l.map((e) {
                  return int.parse(e['Hours']);
                }).toList(),
                min: l.map((e) {
                  return int.parse(e['minutes']);
                }).toList(),
              )),
            })
        .toList();

    for (var item in j1) {
      print(item.name);
      print(item.min.sum);
      int totalmin = item.min.sum;
      int total1 = item.hours.sum;
      print(item.hours.sum);
      var dd1 = Duration(hours: total1, minutes: totalmin);
      print("aa time che $dd1");
      v1.add(
        FinalTotal(
          name: item.name,
          total: dd1.toString().substring(0, 5),
          clientname: item.clientname,
          active: item.active,
        ),
      );
    }
    return v1;
  }

  Future<bool> getJoiningCode({required String code}) async {
    late QuerySnapshot data;
    late bool join;
    print("aaa uprthi aave che $code");

    data = await joiningCode.get();
    String check = data.docs[0].get("joiningCode");
    if (check == code) {
      join = true;
      print(join);
    } else {
      join = false;
      print(join);
    }

    print(data.docs[0].get("joiningCode"));
    print(join);

    return join;
  }
}
