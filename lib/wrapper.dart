import 'package:ecaresystem/pages/login_page.dart';
import 'package:ecaresystem/screens/admin/admin.dart';
import 'package:ecaresystem/screens/home_taskl.dart';
import 'package:ecaresystem/services/auth.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  final cro = Get.find<AuthService>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => cro.user.value == null
        ? const LoginPage()
        : cro.user.value!.email == "laxman@ecareinfoway.com"
            ? const AdminScreen()
            : const HomeTaskList());
  }
}
