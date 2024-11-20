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

  Map<String, Object?> toMap() {
    return {
      //'id': id,
      'message': message,
      'who': messageFrom,
      'image': imagePath
    };
  }

  @override
  String toString() {
    return 'Message{message: $message, from: $messageFrom, image: $imagePath}';
  }
}

enum MessageFrom { USER, IA }