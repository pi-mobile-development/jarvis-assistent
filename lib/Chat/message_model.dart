class MessageModel {
  final String message;
  final MessageFrom messageFrom;

  MessageModel({
    required this.message,
    required this.messageFrom,
  });
}

enum MessageFrom { USER, IA }
