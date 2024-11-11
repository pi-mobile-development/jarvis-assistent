import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:jarvis_assistant/Chat/message_model.dart';
import 'package:jarvis_assistant/Utils/db.dart';



class GeminiController {
  final GenerativeModel _model;
  final DatabaseMessages _database;
  int cont;

  GeminiController(this._model, this._database,this.cont);

  final isLoading = ValueNotifier(false);

  late final ChatSession _chat;

  //final messages = <MessageModel>[];

  void startChat(){
    _chat = _model.startChat();
  }

  Future<String> onSendMessage(String prompt) async{

    final iaResponse = await _chat.sendMessage(Content.text(prompt));

    if(iaResponse.text != null){
      return iaResponse.text!;
    }

    return "Erro: Sem Resposta"; 

  }

  Future<String> onSendImageMessage(String prompt,File image) async{

    final imageBytes = await image.readAsBytes();
    final content = Content.multi([
          TextPart(prompt),
          DataPart('image/jpeg', imageBytes),
    ]);

    var iaResponse = await _chat.sendMessage(content);

    if(iaResponse.text != null){
      return iaResponse.text!;
    }
    return "Erro: Sem Resposta"; 

  }

  Future<void> onSendMessageDB(String prompt) async{

    final iaResponse = await _chat.sendMessage(Content.text(prompt));

    if(iaResponse.text != null){
      final message = MessageModel(id: await _database.contQuerry(), message: iaResponse.text!, messageFrom: MessageFrom.IA);
      _database.insertMessage(message);
    }

  
  }

  Future<void> onSendImageMessageDB(String prompt,File image) async{

    final imageBytes = await image.readAsBytes();
    final content = Content.multi([
          TextPart(prompt),
          DataPart('image/jpeg', imageBytes),
    ]);

    var iaResponse = await _chat.sendMessage(content);

    if(iaResponse.text != null){
      final message = MessageModel(id:await _database.contQuerry(), message: iaResponse.text!, messageFrom: MessageFrom.IA);
      _database.insertMessage(message);      
    }
    

  }
}