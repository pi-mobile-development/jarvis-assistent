import 'package:jarvis_assistent/Chat/message_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseMessages {
  final Database _database;

  DatabaseMessages(this._database);

  Future<void> insertMessage(MessageModel message) async {
  // Get a reference to the database.
  final db = await _database;
  await db.insert(
    'Messages',
    message.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}
  
}

