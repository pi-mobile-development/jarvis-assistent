import 'dart:ffi';

import 'package:jarvis_assistent/Chat/message_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseMessages {
  final Database _database;

  DatabaseMessages(this._database);

  Future<void> insertMessage(MessageModel message) async {
  // Get a reference to the database.
  final db = await _database;
  await db.insert(
    'messages',
    message.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
  }

Future<List<MessageModel>> messages() async {
 
  final db = await _database;


  final List<Map<String, Object?>> messageMap = await db.query('messages');

  return [
    for (final {
          'id': id as int,
          'message': message as String,
          'who': who as String,
        } in messageMap)
      MessageModel(id:id, message: message, messageFrom: who == 'USER' ? MessageFrom.USER : MessageFrom.IA),
  ];
}

Future<int> contQuerry() async{
  final db = await _database;

  final sql = 'SELECT MAX(id) FROM messages';

  List ids = await db.rawQuery(sql);

  if (ids.length == 0){
    return 0;
  }else{
    return int.parse(ids[0]);
  }




  

}
  
}



