import 'package:jarvis_assistant/Utils/configs.dart';

import '../Login/login_model.dart';

Future<void> signOut() async {
  await googleSignIn.signOut();
  await auth.signOut();
}

void setLoggedUser() {
  loggedUser = UserModel(
      username: auth.currentUser!.displayName!,
      email: auth.currentUser!.email!,
      userID: auth.currentUser!.uid,
      photoUrl: auth.currentUser!.photoURL,
      phoneNumber: auth.currentUser!.phoneNumber
  );
}