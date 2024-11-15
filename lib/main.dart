import 'package:flutter/material.dart';
import 'package:jarvis_assistant/Chat/chat_view.dart';
import 'package:jarvis_assistant/Login/login_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:jarvis_assistant/Utils/configs.dart';
import 'package:jarvis_assistant/Utils/utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: firebaseOptions);
  bool isLoggedIn = auth.currentUser != null;
  if(isLoggedIn) setLoggedUser();

  runApp(MainApp(isLoggedIn: isLoggedIn));
}

class MainApp extends StatelessWidget {
  final bool isLoggedIn;

  const MainApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: isLoggedIn ? const ChatView() : const LoginPage(),
    );
  }
}
