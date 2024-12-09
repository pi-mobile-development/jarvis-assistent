class MessageModel {
  //final int id;
  final String message;
  final MessageFrom messageFrom;
  final String? imagePath;

  MessageModel({
    //required this.id,
    required this.message,
    required this.messageFrom,
    this.imagePath
  });

  // Converte para Map para salvar no Firestore
  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'messageFrom': messageFrom.name, // Salva como string
      'imagePath': imagePath,
    };
  }

  // Converte de Map para MessageModel
  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      message: map['message'] ?? '',
      messageFrom: MessageFrom.values.firstWhere((e) => e.name == map['messageFrom']),
      imagePath: map['imagePath'],
    );
  }

  @override
  String toString() {
    return 'Message{message: $message, from: $messageFrom, image: $imagePath}';
  }
}

enum MessageFrom { USER, IA }