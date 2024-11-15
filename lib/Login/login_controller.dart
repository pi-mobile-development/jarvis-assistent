import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jarvis_assistant/Utils/configs.dart';
import '../Utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'login_model.dart';

class LoginController {

  static late UserModel userLoged;

  Future<bool> loginGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      if (googleAuth == null) return false; // O login foi cancelado

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await auth.signInWithCredential(credential);

      if(userCredential.user == null) return false;

      setLoggedUser();

      return true;

      //return userCredential.user; // Retorna o usuário autenticado
    } catch (error) {
      debugPrint("Login failed: $error");
      return false;
    }
  }
}