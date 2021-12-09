import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// ignore: non_constant_identifier_names
String DAILYTASK = "Daily Tasks";

class DataBase extends GetxController {
  final String uid;

  late QuerySnapshot tasktoclose;
  var totaltask = "0".obs;
  var loading = true.obs;

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

  Future<List<String>> getUserbyTask(String taskname) async {
    loading(true);
    var dd = await dailyTask.where("Taskname", isEqualTo: taskname).get();
    var task = dd.docs;
    List<String> d = [];
    if (task.isNotEmpty) {
      List jj = [];
      List vv = [];

      for (var item in dd.docs) {
        d.add(item["User"]);
        jj.add(int.parse(item["Hours"]));
        vv.add(int.parse(item["minutes"]));
      }
      d = d.toSet().toList();
      int total1 = jj.reduce((value, element) => value + element);
      int totalmin = vv.reduce((value, element) => value + element);

      var dd1 = Duration(hours: total1, minutes: totalmin);
      totaltask(dd1.toString().substring(0, 5));
      update();
      loading(false);
    }
    loading(false);

    return d;
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

  Future closeTask(String id) async {
    await task.doc(id).update({
      "Active": false,
    });
  }

  Future changeName(String id, name) async {
    await client.doc(id).update({
      "ClientName": name,
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
    // var dd = await dailyTask
    //     .snapshots()
    //     .map((event) => event.docs.where((element) =>
    //         element["User"] == name && element["Date"] == formatted))
    //     .toList();

    // return dd;

    return await dailyTask
        .where("User", isEqualTo: name)
        .where("Date", isEqualTo: formatted)
        .get();
  }
}
