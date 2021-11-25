import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthService extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Rxn<User> user = Rxn<User>();

  @override
  void onInit() {
    user.bindStream(_auth.authStateChanges());
    super.onInit();
  }

  Future signInwithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      Get.defaultDialog(middleText: "${e.message}");
    }
  }

  Future signUp(
    String email,
    String password,
  ) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      Get.defaultDialog(middleText: "${e.message}");
    }
  }

  Future signout() async {
    return await _auth.signOut();
  }
}
