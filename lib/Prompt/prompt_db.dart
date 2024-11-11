import 'package:flutter/foundation.dart';
import 'prompt_model.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteCore {
  
  static const _dbName = 'prompts';

  static Future<void> _createTablePrompts(Database database) async {
    await database.execute("""
        CREATE TABLE $_dbName (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          userID TEXT,
          title TEXT,
          prompt TEXT,
          createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
          updatedAt TEXT NOT NULL DEFAULT (datetime('now'))
        )
        """);
  }

  static Future<Database> _getDatabase() async {
    return openDatabase('produtos.db', version: 1,
        onCreate: (Database database, int version) async {
          await _createTablePrompts(database);
        }
    );
  }

  static Future<int> createPrompt(Prompt prompt) async {
    final db = await _getDatabase();

    final dados = prompt.toMap();
    final id = await db.insert(_dbName, dados,
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Prompt>> getPrompts() async {
    final db = await _getDatabase();
    List<Map<String, dynamic>> dados = await db.query(_dbName, orderBy: "id");
    List<Prompt> prompts = [];
    for (var element in dados) {
      prompts.add(Prompt.fromMap(element));
    }

    return prompts;
  }

  static Future<Prompt?> getPromptById(int id) async {
    final db = await _getDatabase();
    List<Map<String, dynamic>> dados = await db.query(_dbName, where: "id = ?", whereArgs: [id], limit: 1);
    Prompt? prompt;
    if(dados.isNotEmpty && dados[0].isNotEmpty) {
      prompt = Prompt.fromMap(dados[0]);
    }
    return prompt;
  }

  static Future<Prompt?> getPromptByUserId(String id) async {
    final db = await _getDatabase();
    List<Map<String, dynamic>> dados = await db.query(_dbName, where: "userID = ?", whereArgs: [id], limit: 1);
    Prompt? prompt;
    if(dados.isNotEmpty && dados[0].isNotEmpty) {
      prompt = Prompt.fromMap(dados[0]);
    }
    return prompt;
  }

  static Future<int> updatePrompt(Prompt prompt) async {
    final db = await _getDatabase();

    final dados = prompt.toMap();
    print(dados);

    final result = await db.update(_dbName, dados, where: "id = ?", whereArgs: [prompt.id]);
    return result;
  }

  static Future<void> deletePrompt(int id) async {
    final db = await _getDatabase();
    try {
      await db.delete(_dbName, where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Erro ao apagar o prompt, id=$id: $err");
    }
  }
}