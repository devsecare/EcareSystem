// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ecaresystem/screens/department/department_filter.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';

// class DepartmentScreen extends StatefulWidget {
//   final QuerySnapshot department;
//   const DepartmentScreen({Key? key, required this.department})
//       : super(key: key);

//   @override
//   _DepartmentScreenState createState() => _DepartmentScreenState();
// }

// class _DepartmentScreenState extends State<DepartmentScreen> {
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
//           backgroundColor: Colors.transparent,
//           title: Text(
//             "Departments",
//             style: GoogleFonts.poppins(
//               fontSize: 20.0,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         body: ListView.builder(
//             itemCount: widget.department.docs.length,
//             itemBuilder: (context, index) {
//               return Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: ListTile(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   onTap: () {
//                     Get.to(() => DepartmentFilter(
//                         department: widget.department.docs[index]
//                             ['Department']));
//                   },
//                   tileColor: Colors.white,
//                   title: Text(
//                     "${widget.department.docs[index]["Department"]}",
//                     style: GoogleFonts.poppins(
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               );
//             }),
//       ),
//     );
//   }
// }
