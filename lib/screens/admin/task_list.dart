// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ecaresystem/screens/admin/task_filter.dart';
// import 'package:ecaresystem/services/auth.dart';
// import 'package:ecaresystem/services/database/database.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';

// import 'admin_add_task.dart';

// class TaskListScreen extends StatefulWidget {
//   const TaskListScreen({Key? key}) : super(key: key);

//   @override
//   _TaskListScreenState createState() => _TaskListScreenState();
// }

// class _TaskListScreenState extends State<TaskListScreen> {
//   Future<void> _pull() async {
//     getdd();
//     setState(() {});
//   }

//   late QuerySnapshot data;
//   late List<QueryDocumentSnapshot> dd;
//   bool _loading = true;
//   final cro = Get.find<AuthService>();
//   @override
//   void initState() {
//     getdd();
//     super.initState();
//   }

//   getdd() async {
//     data = await DataBase("").getTask();
//     dd = data.docs;
//     dd.sort((a, b) {
//       if (b["Active"]) {
//         return 1;
//       }
//       return -1;
//     });
//     setState(() {
//       _loading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomLeft,
//             colors: [Colors.lightBlueAccent, Colors.blueGrey]),
//       ),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         appBar: AppBar(
//           elevation: 0.0,
//           title: Text(
//             "Task List",
//             style: GoogleFonts.poppins(
//               fontSize: 20.0,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           backgroundColor: Colors.transparent,
//           actions: [
//             IconButton(
//                 onPressed: () {
//                   Get.to(() => const AddTaskScreen());
//                 },
//                 icon: const Icon(Icons.add)),
//           ],
//         ),
//         body: _loading
//             ? const Center(
//                 child: CircularProgressIndicator(),
//               )
//             : RefreshIndicator(
//                 onRefresh: _pull,
//                 child: ListView.builder(
//                   itemCount: data.docs.length,
//                   itemBuilder: (context, index) {
//                     return Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: ListTile(
//                         selected: dd[index]["Active"],
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         selectedTileColor: Colors.white,
//                         onTap: () {
//                           Get.to(() => TaskFilter(
//                                 taskname: dd[index]["Taskname"],
//                                 id: dd[index].reference.id,
//                               ));
//                         },
//                         tileColor: Colors.grey[300],
//                         title: Text(
//                           "${dd[index]["Taskname"]}",
//                           style: GoogleFonts.poppins(color: Colors.black),
//                         ),
//                         subtitle: Text(
//                           "${dd[index]["Clientname"]}",
//                           style: GoogleFonts.poppins(color: Colors.black45),
//                         ),
//                         trailing: Text(
//                           "${dd[index]["EstHours"]}",
//                           style: const TextStyle(
//                             color: Colors.green,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//       ),
//     );
//   }
// }
