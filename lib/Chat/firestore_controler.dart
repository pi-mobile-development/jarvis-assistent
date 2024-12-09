import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jarvis_assistant/Chat/chat_model.dart';
import 'package:jarvis_assistant/Utils/configs.dart';


class FirestoreController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Salva uma mensagem no Firestore
  Future<void> saveMessage(MessageModel message) async {
    await _firestore.collection('usuarios/${loggedUser.userID}/messages').add(message.toMap());
  }

  Future<List<MessageModel>> getMessages() async {
    List<MessageModel> messages = [];
    final snapshot = await _firestore.collection('usuarios/${loggedUser.userID}/messages').get();
    snapshot.docs.forEach((doc) {
      messages.add(MessageModel.fromMap(doc.data()));
    });

    return messages;
  }
}
