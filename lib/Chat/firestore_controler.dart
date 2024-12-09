import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jarvis_assistant/Chat/chat_model.dart';

class FirestoreController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Salva uma mensagem no Firestore
  Future<void> saveMessage(MessageModel message) async {
    await _firestore.collection('messages').add(message.toMap());
  }

  // Obtém todas as mensagens do Firestore
  Stream<List<MessageModel>> getMessages() {
    return _firestore
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => MessageModel.fromMap(doc.data())).toList());
  }

  
}
