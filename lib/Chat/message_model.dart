class MessageModel {
  //final int id;
  final String message;
  final MessageFrom messageFrom;

  MessageModel({
    //required this.id,
    required this.message,
    required this.messageFrom,
  });

  Map<String, Object?> toMap() {
    return {
      //'id': id,
      'message': message,
      'who': messageFrom,
    };
  }

  @override
  String toString() {
    return 'Message{message: $message, age: $messageFrom}';
  }
}

enum MessageFrom { USER, IA }