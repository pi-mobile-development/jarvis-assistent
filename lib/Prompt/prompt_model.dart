class Prompt {
  int? id;
  String userID;
  String title;
  String prompt;
  String createdAt;
  String updatedAt;

  // Construtor
  Prompt({
    this.id,
    required this.userID,
    required this.title,
    required this.prompt,
    required this.createdAt,
    required this.updatedAt
  });

  // Método para converter um Map (do SQLite) em um objeto Prompt
  factory Prompt.fromMap(Map<String, dynamic> map) {
    return Prompt(
      id: map['id'],
      userID: map['userID'],
      prompt: map['prompt'],
      title: map['title'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  // Método para converter um objeto Prompt em um Map (do SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userID': userID,
      'title': title,
      'prompt': prompt,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}