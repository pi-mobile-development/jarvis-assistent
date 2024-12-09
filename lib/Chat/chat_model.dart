import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String message;
  final MessageFrom messageFrom;
  final String? imagePath;
  final Timestamp? timestamp; // Corrigido: FieldValue para Timestamp

  MessageModel({
    required this.message,
    required this.messageFrom,
    this.timestamp,
    this.imagePath,
  });

  // Converte para Map para salvar no Firestore
  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'messageFrom': messageFrom.name, // Salva como string
      'imagePath': imagePath,
      'timestamp': FieldValue.serverTimestamp(), // Incluído para garantir a consistência
    };
  }

  // Converte de Map para MessageModel
  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      message: map['message'] ?? '',
      messageFrom: MessageFrom.values.firstWhere(
        (e) => e.name == map['messageFrom'],
        orElse: () => MessageFrom.USER, // Valor padrão em caso de erro
      ),
      timestamp: map['timestamp'] ?? Timestamp.now(), // Corrigido
      imagePath: map['imagePath'],
    );
  }

  @override
  String toString() {
    return 'Message{message: $message, from: $messageFrom, image: $imagePath, timestamp: $timestamp}';
  }
}

enum MessageFrom { USER, IA }
