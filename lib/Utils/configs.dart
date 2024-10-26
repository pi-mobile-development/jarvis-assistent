import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jarvis_assistent/Login/login_model.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

const FirebaseOptions firebaseOptions = FirebaseOptions(
  apiKey: "AIzaSyByqMX_fTHSe8mQN9ti39KoEPiGcj5CaxE",
  appId: "1:450684093170:android:f26db28f7920c06be4066b",
  messagingSenderId: "450684093170",
  projectId: "jarvis-assistant-958d5",
  storageBucket: "jarvis-assistant-958d5.appspot.com",
);

late UserModel loggedUser;
