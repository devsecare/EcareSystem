// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ecaresystem/constants.dart';
// import 'package:ecaresystem/screens/admin/task_list.dart';
// import 'package:ecaresystem/screens/department/department.dart';
// import 'package:ecaresystem/screens/employee/employee.dart';
// import 'package:ecaresystem/services/auth.dart';
// import 'package:ecaresystem/services/database/database.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';

// class AdminScreen extends StatefulWidget {
//   const AdminScreen({Key? key}) : super(key: key);

//   @override
//   _AdminScreenState createState() => _AdminScreenState();
// }

// class _AdminScreenState extends State<AdminScreen> {
//   final _auth = Get.find<AuthService>();

//   late QuerySnapshot user;
//   late QuerySnapshot tasks;
//   late QuerySnapshot department;
//   bool _loading = true;

//   @override
//   void initState() {
//     test();
//     super.initState();
//   }

//   test() async {
//     user = await DataBase("").getUserCount();
//     tasks = await DataBase("").getTask();
//     department = await DataBase("").getDepartment();
//     setState(() {
//       _loading = false;
//     });
//   }

//   Future<void> _pull() async {
//     test();
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
//             "Worksheet Admin",
//             style: GoogleFonts.poppins(
//               fontSize: 20.0,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           backgroundColor: Colors.transparent,
//           actions: [
//             IconButton(
//                 onPressed: () {
//                   Get.to(() => const TaskListScreen());
//                 },
//                 icon: const Icon(Icons.add)),
//             IconButton(
//                 onPressed: () {
//                   Get.defaultDialog(
//                       middleText: "Are you sure you want to exit?",
//                       onCancel: () {
//                         Get.back();
//                       },
//                       onConfirm: () {
//                         _auth.signout();
//                         Get.back();
//                       });
//                   // _auth.signout();
//                 },
//                 icon: const Icon(Icons.exit_to_app))
//           ],
//         ),
//         body: _loading
//             ? const Center(
//                 child: CircularProgressIndicator(
//                   color: Colors.white,
//                 ),
//               )
//             : RefreshIndicator(
//                 onRefresh: _pull,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     children: [
//                       Expanded(
//                         child: GridView(
//                           gridDelegate:
//                               const SliverGridDelegateWithMaxCrossAxisExtent(
//                             childAspectRatio: 3 / 2,
//                             maxCrossAxisExtent: 200,
//                             mainAxisSpacing: 20,
//                             crossAxisSpacing: 20,
//                           ),
//                           children: [
//                             GestureDetector(
//                               onTap: () {
//                                 Get.to(() => EmployeeScreen(
//                                       user: user,
//                                     ));
//                               },
//                               child: Container(
//                                 alignment: Alignment.center,
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     const Text(
//                                       "Employees",
//                                       style: h1,
//                                     ),
//                                     Text(
//                                       "${user.docs.length}",
//                                       style: h1,
//                                     ),
//                                   ],
//                                 ),
//                                 decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(15)),
//                               ),
//                             ),
//                             GestureDetector(
//                               onTap: () {
//                                 Get.to(() => const TaskListScreen());
//                               },
//                               child: Container(
//                                 alignment: Alignment.center,
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     const Text(
//                                       "Total Tasks",
//                                       style: h1,
//                                     ),
//                                     Text(
//                                       "${tasks.docs.length}",
//                                       style: h1,
//                                     ),
//                                   ],
//                                 ),
//                                 decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(15)),
//                               ),
//                             ),
//                             GestureDetector(
//                               onTap: () {
//                                 Get.to(() =>
//                                     DepartmentScreen(department: department));
//                               },
//                               child: Container(
//                                 alignment: Alignment.center,
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     const Text(
//                                       "Department",
//                                       style: h1,
//                                     ),
//                                     Text(
//                                       "${department.docs.length}",
//                                       style: h1,
//                                     ),
//                                   ],
//                                 ),
//                                 decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(15)),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//       ),
//     );
//   }
// }
