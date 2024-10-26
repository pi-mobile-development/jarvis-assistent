import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jarvis_assistent/Chat/main_screen.dart';
import 'package:jarvis_assistent/Login/login_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:jarvis_assistent/Utils/configs.dart';
import 'package:jarvis_assistent/Utils/utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: firebaseOptions);
  bool isLoggedIn = auth.currentUser != null;
  if(isLoggedIn) setLoggedUser();

  runApp(MainApp(isLoggedIn: isLoggedIn));
}

class MainApp extends StatelessWidget {
  final bool isLoggedIn;

  MainApp({required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: isLoggedIn ? Mainscreen() : LoginPage(),
    );
  }
}
